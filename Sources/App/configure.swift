import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    let password = "YOUR PASSWORD" // password for postgres user
    let tenant = "YOUR PROJECT REFERENCE" // project reference ID
    
    let templateWorking = "postgresql://postgres:\(password)@db.\(tenant).supabase.co:5432/postgres"
    let templateFailing = "postgresql://postgres.\(tenant):\(password)@aws-0-eu-west-2.pooler.supabase.com:6543/postgres"
    
    // Change this to toggle Connection Pool on/off (pooler).
    let failing = true
    
    guard let url = URL(string: failing ? templateFailing : templateWorking) else {
        print("URL failed to construct")
        return
    }
    
    app.logger.info("Using database with URL: \(url.absoluteString)")
    
    var postgresConfig = try SQLPostgresConfiguration(url: url)
    postgresConfig.coreConfiguration.tls = .disable
    app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    
    do {
        let db = app.db as! PostgresDatabase
        let rows = try await db.simpleQuery("SELECT version();").get()
        print(rows) // if this gets executed, it worked fine
    } catch {
        print("\n\nFailed to execute...\n\n🚨 \(String(reflecting: error))\n\n")
    }
}
