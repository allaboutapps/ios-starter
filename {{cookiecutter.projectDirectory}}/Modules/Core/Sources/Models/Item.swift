import Foundation

public struct Item: Codable, Hashable {  
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
