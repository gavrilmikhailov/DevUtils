import FirebaseCore
import FirebaseAuth

public final class FirebaseClient {
    
    public init() {}
    
    public func initializeApp() {
        guard let configurationFileURL = Bundle.module.url(forResource: "GoogleService-Info", withExtension: "plist"),
              let options = FirebaseOptions(contentsOfFile: configurationFileURL.path) else {
            print("Firebase App configuration failed")
            return
        }
        FirebaseApp.configure(options: options)
        Auth.auth().signIn(withEmail: "gavrilmikhailov@gmail.com", password: "") { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let result = result {
                result.user.getIDTokenResult(forcingRefresh: false) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    if let result = result {
                        print("Token", result.token)
                    }
                }
            }
        }
    }
}
