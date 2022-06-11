import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import GoogleSignIn

public final class FirebaseClient {
    
    public static let shared = FirebaseClient()
    
    private init() {}
    
    public func initializeApp() {
        guard let configurationFileURL = Bundle.module.url(forResource: "GoogleService-Info", withExtension: "plist"),
              let options = FirebaseOptions(contentsOfFile: configurationFileURL.path)
        else {
            fatalError("Firebase configuration failed")
        }
        FirebaseApp.configure(options: options)
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
    
    public func getCurrentUser() -> UserModel? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return UserModel(email: currentUser.email, name: currentUser.displayName, photo: currentUser.photoURL)
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            print("Signed out")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func uploadFiles(window: NSWindow, fileURLs: [URL], completion: ((URL, Progress?) -> Void)? = nil) {
        if Auth.auth().currentUser != nil {
            _uploadFiles(fileURLs: fileURLs, completion: completion)
        } else {
            signIn(presenting: window) {
                self._uploadFiles(fileURLs: fileURLs, completion: completion)
            }
        }
    }
    
    private func _uploadFiles(fileURLs: [URL], completion: ((URL, Progress?) -> Void)? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Not signed in")
            return
        }
        let storage = Storage.storage()
        let themesReference = storage.reference().child("themes/" + userID)
        fileURLs.forEach { url in
            let themeReference = themesReference.child(url.lastPathComponent)
            let task = themeReference.putFile(from: url, metadata: nil)
            task.observe(.progress) { snapshot in
                completion?(url, snapshot.progress)
            }
            task.resume()
        }
    }
    
    public func loadFiles(window: NSWindow, to url: URL, completion: @escaping () -> Void) {
        if Auth.auth().currentUser == nil {
            signIn(presenting: window) {
                self._loadFiles(to: url, completion: completion)
            }
        } else {
            _loadFiles(to: url, completion: completion)
        }
    }
    
    private func _loadFiles(to url: URL, completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Not signed in")
            return
        }
        let storage = Storage.storage()
        let userStorageReference = storage.reference().child("themes/" + userID)
        Task {
            try await withThrowingTaskGroup(of: URL.self) { group in
                try await userStorageReference.listAll().items.forEach { item in
                    group.addTask {
                        let writeURL = url.appendingPathComponent(item.name)
                        defer { print("Written file at", writeURL.path) }
                        return try await item.writeAsync(toFile: writeURL)
                    }
                }
                try await group.waitForAll()
            }
            completion()
        }
    }
}


// Time elapsed 5.220346927642822 s.
