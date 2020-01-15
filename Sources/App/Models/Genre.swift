//
//  Genre.swift
//  App
//
//  Created by Ibrahim DOGAN on 10.01.2020.
//
import FluentMySQL
import Vapor


final class Genre: Codable{
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Genre: MySQLModel {}
extension Genre: Content {}
extension Genre: Migration {}
extension Genre: Parameter {}



extension Genre {
    // Song sınıfında yaptığımız gibi ilk parametremiz
    // extension yazdığımız model, ikincisi ilişki içerisinde olacağı model
    // üçüncüsü ile bağlantıyı sağlayacak modelimiz.
    var songs: Siblings<Genre, Song, SongGenrePivot> {
        return siblings()
    }
}
