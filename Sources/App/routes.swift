import Vapor
import Crypto
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    //SONGS ROUTER
    let songsController = SongsController()
    try router.register(collection: songsController)
    
    //USER ROUTER
    let usersContoller = UserController()
    try router.register(collection: usersContoller)
    
    //GENRE ROUTER
    try router.register(collection: GenresContoller())
    
    struct InfoData: Content{
        let name: String
    }
    
    struct InfoResponse: Content{
        let request: InfoData
    }
    
    // Basic "Hello, world!" example
    router.get("user", String.parameter) { req -> String in
        let userName  = try req.parameters.next(String.self)
        print("hellooooo")
        return "Hello, \(userName)!"
    }
    
    router.post(InfoData.self, at: "info") { (req, data) -> InfoResponse in
        return InfoResponse(request: data)
    }
}
