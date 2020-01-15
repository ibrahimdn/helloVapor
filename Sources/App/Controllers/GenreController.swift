//
//  Genre.swift
//  App
//
//  Created by Ibrahim DOGAN on 10.01.2020.
//

import Vapor

struct GenresContoller: RouteCollection {
    func boot(router: Router) throws {
        let genresRoutes = router.grouped("api","genres")
        genresRoutes.post(use: createGenre)
        genresRoutes.get(use: getAllGenres)
        genresRoutes.get(Genre.parameter, use: getGenre)
        genresRoutes.get(Genre.parameter, "songs", use: getSongs)

    }
    
    func createGenre(req: Request) throws -> Future<Genre> {
        return try req.content.decode(Genre.self).flatMap(to: Genre.self) { (genre) in
            return genre.save(on: req)
        }
    }
    
    func getAllGenres(req: Request) throws -> Future<[Genre]> {
        return Genre.query(on: req).all()
    }
    
    func getGenre(req: Request) throws -> Future <Genre> {
        return try req.parameters.next(Genre.self)
    }
    
    func getSongs(req: Request) throws -> Future<[Song]> {
        return try req.parameters.next(Genre.self).flatMap(to: [Song].self, { (genre) in
            return try genre.songs.query(on: req).all()
        })
    }
  

}


