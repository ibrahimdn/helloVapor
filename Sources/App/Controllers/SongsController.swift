//
//  SongContoller.swift
//  App
//
//  Created by Ibrahim DOGAN on 8.01.2020.
//

import Vapor
import Fluent

struct SongsController: RouteCollection {
    func boot(router: Router) throws {
        let songsRoute = router.grouped("api", "songs")
        songsRoute.get(use: getAllSongs)
        songsRoute.post(use: createSong)
        songsRoute.get(Song.parameter, use: getSong)
        songsRoute.delete(Song.parameter, use: deleteSong)
        songsRoute.put(Song.parameter, use: updateSong)
        songsRoute.get(Song.parameter, "creator", use: getCreator)
        songsRoute.get(Song.parameter, "genres" ,use: getGenres)
        songsRoute.post(Song.parameter, "genres", Genre.parameter, use: addGenre)
    }
    
    func getAllSongs(req: Request) throws -> Future<[Song]>{
        return Song.query(on: req).all()
    }
    
    func createSong(req: Request) throws -> Future<Song>{
        let song = try req.content.decode(Song.self)
        return song.save(on: req)
    }
    
    func getSong(req: Request) throws -> Future<Song> {
        return try req.parameters.next(Song.self)
    }
    
    func deleteSong(req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Song.self).flatMap(to: HTTPStatus.self, { (song) in
            return song.delete(on: req).transform(to: .noContent)
        })
    }
    
    func updateSong(req: Request) throws -> Future<Song> {
        return try flatMap(to: Song.self, req.parameters.next(Song.self), req.content.decode(Song.self), { (song, newSong)in
            song.artist = newSong.artist
            song.title = newSong.title
            return song.save(on: req)
        })
    }
    
    func getCreator(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(Song.self).flatMap(to: User.self, { (song) in
            return song.creator.get(on: req)
        })
    }
    
    func getGenres(req: Request) throws -> Future<[Genre]> {
        return try req.parameters.next(Song.self).flatMap(to: [Genre].self, { (song) in
            return try song.genres.query(on: req).all()
        })
    }
    
    func addGenre(req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Song.self), req.parameters.next(Genre.self), { (song, genre) in
            let pivot = try SongGenrePivot(song.requireID(), genre.requireID())
            return pivot.save(on: req).transform(to: .ok)
        })
    }
 
    
}
