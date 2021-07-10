public enum GistEnvironment {
    case local
    case development
    case production
}

class Settings {
    static var Environment: GistEnvironment = GistEnvironment.production
    static var Network: NetworkSettings {
        switch Environment {
        case .development:
            return NetworkSettingsDevelopment()
        case .local:
            return NetworkSettingsLocal()
        case .production:
            return NetworkSettingsProduction()
        }
    }
}
