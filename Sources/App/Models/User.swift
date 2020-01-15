//
//  User.swift
//  App
//
//  Created by Ibrahim DOGAN on 7.01.2020.
//

import Foundation
import Fluent
import Vapor
import FluentMySQL

final class User: Codable {
    var id: UUID?
    var name: String
    var userName: String
    
    init(name: String, userName: String) {
        self.name = name
        self.userName = userName
    }
}

extension User: MySQLUUIDModel{}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}

extension User{
    var songs: Children <User, Song> {
        return children(\.creatorID)
    }
}
