//
//  Extensions.swift
//  NetflixClone
//
//  Created by Ahmed Eslam on 14/02/2023.
//

import Foundation

extension String{
    func capatalizeFirstLtter() -> String {
        
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
