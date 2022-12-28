enum HTTPHeader: String {
    case contentType = "Content-Type"
    case siteId = "X-Gist-CIO-Site-Id"
    case userToken = "X-Gist-User-Token"
}

enum ContentTypes: String {
    case json = "application/json"
}
