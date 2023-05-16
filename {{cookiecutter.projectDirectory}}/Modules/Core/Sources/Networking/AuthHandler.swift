import Alamofire
import Fetch
import Foundation
import Models

public class AuthHandler: RequestInterceptor {
    private let actor: CredentialsRefreshActor = .init()

    // MARK: - RequestAdapter

    public func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = CredentialsController.shared.currentCredentials?.accessToken {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }

    // MARK: - RequestRetrier

    public func retry(_ request: Alamofire.Request, for _: Alamofire.Session, dueTo _: Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              let refreshToken = CredentialsController.shared.currentCredentials?.refreshToken,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        Task {
            await actor.addRequest(completion)
            await actor.refresh(refreshToken: refreshToken)
        }
    }
}

actor CredentialsRefreshActor {
    typealias RequestRetryCompletion = (Alamofire.RetryResult) -> Void

    private static let apiLogger = APILogger(verbose: true)
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()

    func addRequest(_ request: @escaping RequestRetryCompletion) async {
        requestsToRetry.append(request)
    }

    func refresh(refreshToken: String) async {
        guard !isRefreshing else { return }

        isRefreshing = true

        defer {
            requestsToRetry.removeAll()
            isRefreshing = false
        }

        guard let urlRequest = try? API.Auth.tokenRefresh(refreshToken).asURLRequest() else {
            requestsToRetry.forEach { $0(.doNotRetry) }
            return
        }

        let response = await AF.request(urlRequest)
            .validate()
            .serializingDecodable(Credentials.self)
            .response

        let statusCode = response.response?.statusCode

        switch response.result {
        case .success(let credentials):
            CredentialsController.shared.currentCredentials = credentials
            requestsToRetry.forEach { $0(.retry) }

        case .failure:
            if statusCode == 401 {
                CredentialsController.shared.currentCredentials = nil
            }
            requestsToRetry.forEach { $0(.doNotRetry) }
        }
    }
}
