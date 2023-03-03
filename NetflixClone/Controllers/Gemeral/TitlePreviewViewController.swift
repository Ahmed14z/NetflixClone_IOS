//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Ahmed Eslam on 25/02/2023.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    private var headerView: HeroHeaderUIView?
    public var playSelectedTitle: Title?
    private var titles: [Title]?

    private var homeView: HomeViewController?


   
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
        
    }()
    
    private let overViewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Best Movie Ever"
        return label
        
    }()
    
    
    public let downloadButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
        
    }()
    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        configureConstraints()
        
        
        self.downloadButton.addTarget(self, action:#selector(self.downloadButtonClick),  for: .touchUpInside)

        
    }
    
    
    
    @objc func downloadButtonClick(){

//        let vc = HomeViewController()
        

        guard let title = playSelectedTitle else { return ()}
        
        print("test")

        DataPersistenceManager.shared.downloadTitleWith(model: title) {result in
            switch result {
            case .success():
                NotificationCenter.default.post(name:Notification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }

        }
        
    }

    
    func configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        
        let titleLabelConstraints = [
        
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let overViewLabelConstraints = [
        
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
          let downloadButtonConstraints = [
              downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor,constant: 25),
              downloadButton.widthAnchor.constraint(equalToConstant: 140),
              downloadButton.heightAnchor.constraint(equalToConstant: 40)
              
          ]
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)

        
    }
    
//    func configure2(with model : Title){
//        self.playSelectedTitle = model
//    }
    
    func configure2(with model : TitlePreviewViewodel,title : Title ){
//        guard let title = self.selectedTitle else { return ()}

        titleLabel.text = model.title
//        var titles : [Title] = model.title
//
//
        
        playSelectedTitle = title
        overViewLabel.text = model.titleOverView
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }


    func configure(with model : TitlePreviewViewodel ){
//        guard let title = self.selectedTitle else { return ()}

        titleLabel.text = model.title
//        var titles : [Title] = model.title
//
//
        overViewLabel.text = model.titleOverView
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }

}
