//
//  Song.swift
//  App
//
//  Created by Ibrahim DOGAN on 8.01.2020.
//

import FluentMySQL
import Vapor

final class Song: Codable {
    var id: Int?
    var artist: String
    var title: String
    var creatorID: User.ID
    
    init(artist: String, title: String, creatorID: User.ID) {
        self.artist = artist
        self.title = title
        self.creatorID = creatorID
    }
    
}

extension Song: MySQLModel {}
extension Song: Content {}
extension Song: Migration {}
extension Song: Parameter {}

extension Song {
    
    var genres: Siblings<Song, Genre, SongGenrePivot> {
        return siblings()
    }
    
    var creator: Parent<Song, User> {
        return parent(\.creatorID)
    }
}
