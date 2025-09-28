//
//  AppleAuthManager.swift
//  SustainaBuddy
//
//  Lightweight Sign in with Apple manager
//

import Foundation
import AuthenticationServices

class AppleAuthManager: NSObject, ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userIdentifier: String? = nil
    @Published var displayName: String = ""
    @Published var email: String = ""

    private let userIdKey = "appleUserIdentifier"

    override init() {
        super.init()
        restoreSession()
    }

    func restoreSession() {
        if let savedId = UserDefaults.standard.string(forKey: userIdKey) {
            userIdentifier = savedId
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: savedId) { [weak self] state, _ in
                DispatchQueue.main.async {
                    self?.isSignedIn = (state == .authorized)
                }
            }
        } else {
            isSignedIn = false
        }
    }

    func handle(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            self.userIdentifier = userId
            UserDefaults.standard.set(userId, forKey: userIdKey)

            if let name = appleIDCredential.fullName, !name.isEmpty {
                let formatter = PersonNameComponentsFormatter()
                self.displayName = formatter.string(from: name).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if let email = appleIDCredential.email {
                self.email = email
            }
            self.isSignedIn = true
        }
    }

    func signOut() {
        userIdentifier = nil
        displayName = ""
        email = ""
        isSignedIn = false
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
}