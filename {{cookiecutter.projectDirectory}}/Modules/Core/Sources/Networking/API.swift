import Alamofire
import Fetch
import Foundation
import Models
import Utilities

public enum API {
    public static func setup() {
        APIClient.shared.setup(with: Fetch.Config(
            baseURL: Config.API.baseURL,
            timeout: Config.API.timeout,
            eventMonitors: [APILogger(verbose: Config.API.verboseLogging)],
            interceptor: AuthHandler(),
            jsonDecoder: Decoders.standardJSON,
            cache: MemoryCache(defaultExpiration: .seconds(Config.Cache.defaultExpiration)),
            shouldStub: Config.API.stubRequests)
        )
        
        registerStubs()
    }
    
    static func registerStubs() {
        let itemsStubResponse = StubResponse(statusCode: 200, fileName: "items.json", delay: 0.5, bundle: Bundle.module)
        APIClient.shared.stubProvider.register(stub: itemsStubResponse, for: API.Example.list())
    }

    public enum Auth {
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
    
    public enum Example {
        public static func list() -> Resource<[Item]> {
            return Resource(
                method: .get,
                path: "/example")
        }
    }
}
