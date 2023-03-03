//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Ahmed Eslam on 12/02/2023.
//

import UIKit

enum Sections   : Int {
    case Trendingmovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {

    
    public var selectedTitle: Title?
    private var randomTrendingMovie : Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles : [String] = ["Trending Movies" ,"Trending Tv" , "Popular", "Top Rated" , "Upcoming Movies"]

    
    private let homeFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier
        )
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
      headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        self.headerView?.playButton.addTarget(self, action:#selector(self.playButtonClick),  for: .touchUpInside)
        self.headerView?.downloadButton.addTarget(self, action:#selector(self.downloadButtonClick),  for: .touchUpInside)


        
        
    }
 

     func buttonPressed(viewModel: TitlePreviewViewodel ){
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
//            vc.configure(with: viewModel)
            vc.configure2(with: viewModel , title: (self?.selectedTitle! ?? self?.randomTrendingMovie)! )

            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func downloadButtonClick(){
        guard let title = self.selectedTitle else { return ()}
       
        DataPersistenceManager.shared.downloadTitleWith(model: title) {result in
            switch result {
            case .success():
                NotificationCenter.default.post(name:Notification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }

        }
        
    }
        
    
    
    @objc func playButtonClick(){
       
        let title = self.selectedTitle

//        let VCC = TitlePreviewViewController()
//        VCC.playSelectedTitle = title
//        VCC.downloadButton.addTarget(VCC, action:#selector(VCC.downloadButtonClick),  for: .touchUpInside)


        guard let titleName = title?.original_title ?? title?.original_title else {
            return
        }
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                let title = title
                guard  let titleOverview = title?.overview else {
                    return
                }
                
                guard self != nil else {
                    return
                }
                let viewModel = TitlePreviewViewodel(title: titleName, youtubeView: videoElement, titleOverView: titleOverview)
                
                    
                self?.buttonPressed(viewModel: viewModel)
                
                
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    


    public func configureHeroHeaderView(){
        APICaller.shared.getTrendingMovies {[weak self] result in
            switch result {
            case .success(let titles):
                self?.selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = self?.selectedTitle
                
                self?.headerView?.configure(with: TitleViewModel(titleName: self?.selectedTitle?.original_title ?? "", posterURL: self?.selectedTitle?.poster_path ?? "", titleOverView: ""))
                let title = self?.selectedTitle
                guard (title?.original_title ?? title?.original_title) != nil else {
                    return
                }
        
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
            
        
        }
    
        
        
        
       
        
        
    }
    private func configureNavbar() {
        var image = UIImage(named: "netflixlogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target:self ,action: nil)
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image:UIImage(systemName: "person"), style: .done, target: self, action: nil),UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
//        let negativeSpacer = UIBarButtonItem()
//        negativeSpacer.width = -20
//
        
        navigationController?.navigationBar.tintColor = .white
        
        
        
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    
  
   
}
 
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self

        switch indexPath.section {
        case Sections.Trendingmovies.rawValue:
            
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles) :
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpComingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            
                APICaller.shared.getTopRated { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case.failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capatalizeFirstLtter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset ))
        
    }
}


extension HomeViewController : CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewodel,titlemodel : Title) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            
        
            vc.configure2(with: viewModel , title: (titlemodel ) )
            
//            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    
       func playButtonWasPressed(viewModel:  TitlePreviewViewodel){
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
        
    }
    
}


