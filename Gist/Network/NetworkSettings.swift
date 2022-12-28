protocol NetworkSettings {
    var queueAPI: String { get }
    var gistAPI: String { get }
    var renderer: String { get }
}

struct NetworkSettingsProduction: NetworkSettings {
    let queueAPI = "https://queue.api.gist.build"
    let gistAPI = "https://api.gist.build"
    let renderer = "https://renderer.gist.build/1.0"
}

struct NetworkSettingsDevelopment: NetworkSettings {
    let queueAPI = "https://queue.api.dev.gist.build"
    let gistAPI = "https://api.dev.gist.build"
    let renderer = "https://renderer.gist.build/1.0"
}

struct NetworkSettingsLocal: NetworkSettings {
    let queueAPI = "http://queue.api.local.gist.build:86"
    let gistAPI = "http://api.local.gist.build:83"
    let renderer = "http://app.local.gist.build:8080/web"
}
