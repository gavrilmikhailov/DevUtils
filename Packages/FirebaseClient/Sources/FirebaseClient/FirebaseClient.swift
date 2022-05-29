import FirebaseCore
import FirebaseAuth
import GoogleSignIn

public final class FirebaseClient {
    
    public static let shared = FirebaseClient()
    
    private init() {}
    
    public func initializeApp() {
        _initializeApp()
    }
    
    public func handleOpen(url: URL) {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    public func signIn(presenting window: NSWindow) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let gidConfiguration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: gidConfiguration, presenting: window) { user, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("Signed in", authResult?.user.email ?? "")
            }
        }
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            print("Signed out")
        } catch {
            print(error.localizedDescription)
        }
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
