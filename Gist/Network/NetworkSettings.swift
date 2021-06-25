protocol NetworkSettings {
    var analyticsAPI: String { get }
    var queueAPI: String { get }
    var gistAPI: String { get }
    var gist: String { get }
    var renderer: String { get }
}

struct NetworkSettingsProduction: NetworkSettings {
    let analyticsAPI = "https://analytics.api.gist.build"
    let queueAPI = "https://queue.api.gist.build"
    let gistAPI = "https://api.gist.build"
    let gist = "https://app.gist.build"
    let renderer = "https://code.gist.build/renderer/0.0.3"
}

struct NetworkSettingsDevelopment: NetworkSettings {
    let analyticsAPI = "https://analytics.api.dev.gist.build"
    let queueAPI = "https://queue.api.dev.gist.build"
    let gistAPI = "https://api.dev.gist.build"
    let gist = "https://app.dev.gist.build"
    let renderer = "https://code.gist.build/renderer/0.0.3"
}

struct NetworkSettingsLocal: NetworkSettings {
    let analyticsAPI = "http://analytics.api.local.gist.build:88"
    let queueAPI = "http://queue.api.local.gist.build:86"
    let gistAPI = "http://api.local.gist.build:83"
    let gist = "http://app.local.gist.build:8000"
    let renderer = "http://app.local.gist.build:8080/web"
}
