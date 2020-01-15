import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    var migrations = MigrationConfig()
    
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Song.self, database: .mysql)
    migrations.add(model: Genre.self, database: .mysql)
    migrations.add(model: SongGenrePivot.self, database: .mysql)

    services.register(migrations)
    
    var databases = DatabasesConfig()
    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost",
                                            port: 3306,
                                            username: "root",
                                            password: "00000000",
                                            database: "vapor")
    
    let database = MySQLDatabase(config: mysqlConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)

    // Register providers first
    try services.register(FluentMySQLProvider())
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

}
