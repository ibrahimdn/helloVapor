//
//  SongContoller.swift
//  App
//
//  Created by Ibrahim DOGAN on 8.01.2020.
//

import Vapor
import Fluent

struct SongsController {
    func boot(router: Router) throws {
        let songsRoute = router.grouped("api", "songs")
        songsRoute.get(use: getAllSongs)
        songsRoute.post(use: createSong)
    }
    
    func getAllSongs(req: Request) throws -> Future<[Song]>{
        return Song.query(on: req).all()
    }
    
    func createSong(req: Request) throws -> Future<Song>{
        let song = try req.content.decode(Song.self)
        return song.save(on: req)
    }
}
