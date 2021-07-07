import Foundation

class Bootstrap {
    let extensions: [GistExtendable]

    init(extensions: [GistExtendable]) {
        self.extensions = extensions
    }

    func setup() {
        Logger.instance.debug(message: "Starting Bootstrap")
        // Initialize Gist extensions
        for gistExtension in self.extensions {
            gistExtension.setup()
            Logger.instance.info(message: "Extension \(gistExtension.name) setup")
        }
        Logger.instance.debug(message: "Bootstrap Complete")
    }
}
