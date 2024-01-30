import Vapor
import PostgresNIO

public func configure(_ app: Application) async throws {
    let password = "YOUR PASSWORD" // password for postgres user
    let tenant = "YOUR PROJECT REFERENCE" // project reference ID
    
    let logger = Logger(label: "postgres-logger")
    let config = PostgresConnection.Configuration(
        host: "aws-0-eu-west-2.pooler.supabase.com",
        port: 6543,
        username: "postgres.\(tenant)",
        password: password,
        database: "postgres",
        tls: .disable
    )
    
    do {
        let connection = try await PostgresConnection.connect(on: app.eventLoopGroup.next(), configuration: config, id: 1, logger: logger)
        print(connection)
    } catch {
        print("\n\nFailed to execute...\n\n🚨 \(String(reflecting: error))\n\n")
    }
}
