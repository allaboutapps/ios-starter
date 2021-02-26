import Foundation
import Alamofire
import Fetch

public class API {
    
    public static func setup() {
        APIClient.shared.setup(with: Fetch.Config(
            baseURL: Config.API.baseURL,
            timeout: Config.API.timeout,
            eventMonitors: [APILogger(verbose: Config.API.verboseLogging)],
            interceptor: AuthHandler(),
            cache: MemoryCache(defaultExpiration: Config.Cache.defaultExpiration),
            shouldStub: Config.API.stubRequests)
        )
    }
    
    public struct Auth {
        public static func login(username: String, password: String) -> Resource<Credentials> {
            return Resource(
                method: .post,
                path: "/api/v1/auth/login",
                body: .encodable([
                    "grantType": "password",
                    "scope": "user",
                    "username": username,
                    "password": password
                ])
            )
        }
        
        public static func tokenRefresh(_ refreshToken: String) -> Resource<Credentials> {
            return Resource(
                method: .post,
                path: "/api/v1/auth/refresh",
                body: .encodable([
                    "grantType": "refreshToken",
                    "scope": "user",
                    "refreshToken": refreshToken
                ])
            )
        }
    }
}
