import Foundation

struct AppStoreLookUpResult: Decodable {
    let version: String?
    let trackViewUrl: String?
    let trackId: Int?
}

struct AppStoreLookUp: Decodable {
    let results: [AppStoreLookUpResult]
}
