//
//  LoginView.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import LocalAuthentication
import SwiftUI

struct LoginPageView: View {
    @State private var isAuthenticated: Bool = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var username = ""
    @State private var password = ""
    @State private var biometricsType = ""
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                LoginTextField(text: $username, placeholder: "Username")
                SecureLoginTextField(text: $password, placeholder: "Password")
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red) // Set text color to red
                        .padding()
                }
                
                Button("Login") {
                    loginAPICall(username: username, password: password)
                }
                .padding()
                .disabled(username.count < 3 && password.count < 8)
                .opacity(username.count < 3 ? 0.5 : 1.0)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                
                Button("Authenticate with Face ID") {
                    authenticate()
                }
                .padding()
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                
                NavigationLink("Don't have an account yet?", destination: SignupPageView())
            }
        }
    }
    
    func loginAPICall(username: String, password: String) {
        guard let url = URL(string: "http://192.168.1.42:8080/login") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    if let successResponse = try? decoder.decode(AuthTokenResponse.self, from: data) {
                        print("Saving token in Keychain")
                        KeychainWrapper.standard.set(successResponse.token, forKey: "GdayAuthToken")
                    } else if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                        errorMessage = errorResponse.reason
                        showError = true
                    } else {
                        errorMessage = "An unknown error has occurred."
                        showError = true
                    }
                }
                
            }
        }
        task.resume()
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if context.biometryType == .faceID {
                biometricsType = "Authenticate with Face ID"
            } else if context.biometryType == .touchID {
                biometricsType = "Authenticate with Touch ID"
            } else {
                biometricsType = "Authenticate with Biometrics"
            }
            
            // Perform biometric authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: biometricsType) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        } else {
            // Biometric authentication not available or not set up on the device
            completion(false, error)
        }
    }
    
    func authenticate() {
        authenticateWithBiometrics { success, error in
            if success {
                DispatchQueue.main.async {
                    if let text = KeychainWrapper.standard.string(forKey: "GdayAuthToken") {
                        print(text)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = error?.localizedDescription ?? "Authentication failed"
                    showError = true
                }
            }
        }
    }
}
