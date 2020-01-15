//
//  UserContoller.swift
//  App
//
//  Created by Ibrahim DOGAN on 7.01.2020.
//

import Vapor
import Crypto

struct UserController: RouteCollection {
    func boot(router: Router) throws {
        // user route için /api/users üzerinden erişmek istiyorum.
        let usersRouters = router.grouped("api", "users")
        // user oluşturmak için yazdığımız fonksiyonu kaydettik.
        usersRouters.post(use: createUser)
        // get request'i ile tüm user'ları getireceğiz.
        usersRouters.get(use: getAllUsers)
        // parametre ile get isteği yapıp tek bir user getireceğiz.
        usersRouters.get(User.parameter, use: getUser)
        // User'ın tüm songlarını getirir
        usersRouters.get(User.parameter, "songs", use: getSongs)
    }
    
    func createUser(req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self, { (user) in
            return user.save(on: req)
        })
    }
    
    func getAllUsers(req: Request) throws -> Future<[User]>{
        return User.query(on: req).all()
    }
    
    func getUser(req: Request) throws -> Future <User>{
        return try req.parameters.next(User.self)
    }
    
    func getSongs(_ req: Request) throws -> Future <[Song]> {
         return try req.parameters.next(User.self).flatMap(to: [Song].self, { (user) in
             return try user.songs.query(on: req).all()
         })
     }
}
