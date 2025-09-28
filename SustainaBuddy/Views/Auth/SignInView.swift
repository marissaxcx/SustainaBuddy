//
//  SignInView.swift
//  SustainaBuddy
//
//  SwiftUI view with Sign in with Apple button
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authManager: AppleAuthManager

    var body: some View {
        ZStack {
            Color.sleekDark.ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Welcome to SustainaBuddy")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)
                    Text("Sign in to join the community and sync your progress.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                SignInWithAppleButton(.signIn, onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                }, onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        authManager.handle(authorization: authorization)
                        // Update in-app profile name if available
                        if !authManager.displayName.isEmpty {
                            appState.userProfile.name = authManager.displayName
                        }
                    case .failure:
                        break
                    }
                })
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 48)
                .cornerRadius(10)
                .padding(.horizontal, 24)

                if !authManager.displayName.isEmpty {
                    Text("Signed in as \(authManager.displayName)")
                        .foregroundColor(.glowingCyan)
                        .font(.footnote)
                        .padding(.top, 4)
                }

                Spacer()
            }
            .padding(.top, 100)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AppState())
            .environmentObject(AppleAuthManager())
            .preferredColorScheme(.dark)
    }
}