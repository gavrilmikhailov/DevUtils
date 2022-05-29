import FirebaseCore
import FirebaseAuth
import FirebaseStorage
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
    
    public func signIn(presenting window: NSWindow, completion: (() -> Void)? = nil) {
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
                completion?()
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
    
    public func uploadFiles(window: NSWindow, fileURLs: [URL]) {
        if Auth.auth().currentUser != nil {
            _uploadFiles(fileURLs: fileURLs)
        } else {
            signIn(presenting: window) {
                self._uploadFiles(fileURLs: fileURLs)
            }
        }
    }
    
    private func _uploadFiles(fileURLs: [URL]) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Not signed in")
            return
        }
        let storage = Storage.storage()
        let themesReference = storage.reference().child("themes/" + userID)
        fileURLs.forEach { url in
            let themeReference = themesReference.child(url.lastPathComponent)
            let uploadTask = themeReference.putFile(from: url, metadata: nil)
            uploadTask.resume()
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
