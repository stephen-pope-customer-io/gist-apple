protocol NetworkSettings {
    var analyticsAPI: String { get }
    var queueAPI: String { get }
    var gistAPI: String { get }
    var renderer: String { get }
}

struct NetworkSettingsProduction: NetworkSettings {
    let analyticsAPI = "https://analytics.api.gist.build"
    let queueAPI = "https://queue.api.gist.build"
    let gistAPI = "https://api.gist.build"
    let renderer = "https://renderer.gist.build/1.0"
}

struct NetworkSettingsDevelopment: NetworkSettings {
    let analyticsAPI = "https://analytics.api.dev.gist.build"
    let queueAPI = "https://queue.api.dev.gist.build"
    let gistAPI = "https://api.dev.gist.build"
    let renderer = "https://renderer.gist.build/1.0"
}

struct NetworkSettingsLocal: NetworkSettings {
    let analyticsAPI = "http://analytics.api.local.gist.build:88"
    let queueAPI = "http://queue.api.local.gist.build:86"
    let gistAPI = "http://api.local.gist.build:83"
    let renderer = "http://app.local.gist.build:8080/web"
}
