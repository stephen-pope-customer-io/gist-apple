import Alamofire

protocol GistNetworkRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParameters? { get }
}

enum RequestParameters {
    case body(_:Decodable)
    case id(_:String)
}
