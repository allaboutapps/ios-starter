import Foundation
import Alamofire
import Fetch
import Models

public class AuthHandler: RequestInterceptor {
    
    private typealias RefreshCompletion = (_ credentials: Credentials?, _ statusCode: Int?) -> Void
    private typealias RequestRetryCompletion = (Alamofire.RetryResult) -> Void
    
    private static let apiLogger = APILogger(verbose: true)
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
    private let lock = NSLock()
    private let queue = DispatchQueue(label: "network.auth.queue")
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - RequestAdapter
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = CredentialsController.shared.currentCredentials?.accessToken {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    // MARK: - RequestRetrier
    
    public func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        lock.lock() ; defer { lock.unlock() }
        
        guard let response = request.task?.response as? HTTPURLResponse,
            let refreshToken = CredentialsController.shared.currentCredentials?.refreshToken,
            response.statusCode == 401 else {
                completion(.doNotRetry)
                return
        }
        
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            refreshCredentials(refreshToken) { [weak self] (credentials, statusCode) in
                guard let self = self else { return }
                
                self.lock.lock() ; defer { self.lock.unlock() }
                
                if let credentials = credentials {
                    CredentialsController.shared.currentCredentials = credentials
                    self.requestsToRetry.forEach { $0(.retry) }
                } else {
                    if statusCode == 401 {
                        CredentialsController.shared.currentCredentials = nil
                    }
                    self.requestsToRetry.forEach { $0(.doNotRetry) }
                }
                
                self.requestsToRetry.removeAll()
            }
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshCredentials(_ refreshToken: String, completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        guard let urlRequest = try? API.Auth.tokenRefresh(refreshToken).asURLRequest() else {
            completion(nil, nil)
            return
        }
        
        session
            .request(urlRequest)
            .validate()
            .responseDecodable(queue: queue, completionHandler: { [weak self] (response: DataResponse<Credentials, AFError>) in
                guard let self = self else { return }
                
                let statusCode = response.response?.statusCode

                switch response.result {
                case .success(let credentials):
                    completion(credentials, statusCode)
                case .failure:
                    completion(nil, statusCode)
                }
                self.isRefreshing = false
            })
    }
}
