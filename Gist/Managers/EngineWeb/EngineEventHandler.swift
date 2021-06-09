import Foundation
import UIKit

typealias EngineEventProperties = [String: AnyObject]

enum EngineEvent: String {
    case bootstrapped
    case routeLoaded
    case routeError
    case routeChanged
    case sizeChanged
    case tap
    case error
}

struct TapProperties {
    let action: String
    let system: Bool
}

class EngineEventHandler {
    static func getTapProperties(properties: EngineEventProperties) -> TapProperties? {
        guard let parameters = properties["parameters"],
              let action = parameters["action"] as? String,
              let system = parameters["system"] as? Bool else {
            return nil
        }
        return TapProperties(action: action, system: system)
    }

    static func getSizeProperties(properties: EngineEventProperties) -> CGSize? {
        guard let parameters = properties["parameters"],
              let width = parameters["width"] as? Int,
              let height = parameters["height"] as? Int else {
            return nil
        }
        return CGSize(width: width, height: height)
    }

    static func getRouteChangedProperties(properties: EngineEventProperties) -> String? {
        return extractRoute(properties: properties)
    }

    static func getRouteErrorProperties(properties: EngineEventProperties) -> String? {
        return extractRoute(properties: properties)
    }

    static func getRouteLoadedProperties(properties: EngineEventProperties) -> String? {
        return extractRoute(properties: properties)
    }

    private static func extractRoute(properties: EngineEventProperties) -> String? {
        guard let parameters = properties["parameters"],
              let route = parameters["route"] as? String else {
            return nil
        }
        return route
    }
}
