import FirebaseCore
import FirebaseAuth

public final class FirebaseClient {
    
    public init() {}
    
    public func initializeApp() {
        _initializeApp()
    }
    
    private func _initializeApp() {
        guard let configurationFileURL = Bundle.module.url(forResource: "GoogleService-Info", withExtension: "plist"),
              let options = FirebaseOptions(contentsOfFile: configurationFileURL.path)
        else {
            fatalError("Firebase configuration failed")
        }
        FirebaseApp.configure(options: options)
    }
}
