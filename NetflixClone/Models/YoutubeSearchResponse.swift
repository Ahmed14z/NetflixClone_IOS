//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Ahmed Eslam on 25/02/2023.
//

import Foundation



struct YoutubeSearchResponse: Codable {
    let items : [VideoElement]
}

struct VideoElement : Codable {
    let id : IdVideoElement
}

struct IdVideoElement : Codable {
    let kind : String
    let videoId : String
}
