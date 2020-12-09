enum HTTPHeader: String {
    case contentType = "Content-Type"
    case organizationId = "X-Bourbon-Organization-Id"
    case userToken = "X-Gist-User-Token"
}

enum ContentTypes: String {
    case json = "application/json"
}
