//
//  LoginView.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import LocalAuthentication
import SwiftUI

struct LoginPageView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var username = ""
    @State private var password = ""
    @State private var biometricsType = ""
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            Spacer()
            VStack {
                VStack {
                    Image(systemName: "sun.and.horizon.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:150, height:150)
                        .foregroundStyle(Color.orange)
                    Text("Buongiorno")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom)

                    Form {
                        Section(content: {
                            LabeledContent {
                                TextField("Username", text: $username)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .textContentType(.username)
                            } label: {
                                Text("Username")
                                    .fontWeight(.semibold)
                                    .frame(width: 100)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            LabeledContent {
                                SecureField("Password", text: $password)
                            } label: {
                                Text("Password")
                                    .fontWeight(.semibold)
                                    .frame(width: 100)
                                    .multilineTextAlignment(.trailing)
                            }
                        }, footer: {
                            HStack {
                                Spacer()
                                Button(action: {
                                    loginAPICall(username: username, password: password)
                                }, label: {
                                    Label("Login", systemImage: "arrow.right.to.line")
                                })
                                .padding()
                                .disabled(username.count < 3 && password.count < 8)
                                .opacity(username.count < 3 ? 0.5 : 1.0)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 40)
                                .background(Color.orange.opacity(0.8))
                                .cornerRadius(10)
                                Spacer()
                            }
                            .padding()
                        })
                        
                    }
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                }
                
                                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red) // Set text color to red
                        .padding()
                }
                
                
                /* Button("Authenticate with Face ID") {
                 authenticate()
                 }
                 .padding()
                 .foregroundColor(.white)
                 .frame(width: 300, height: 50)
                 .background(Color.orange.opacity(0.8))
                 .cornerRadius(10)
                 */
                Text("Don't have an account yet?")
                NavigationLink("Sign up", destination: SignupPageView())
                    .foregroundStyle(.orange)
            }
        }
    }
    
        func loginAPICall(username: String, password: String) {
            guard let url = URL(string: "http://127.0.0.1:1337/api/auth/login") else {
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
                        KeychainWrapper.standard.set(successResponse.accessToken, forKey: "BuongiornoAccessToken")
                        if let refreshToken = successResponse.refreshToken {
                            KeychainWrapper.standard.set(refreshToken, forKey: "BuongiornoRefreshToken")
                        }
                            
                        self.isLoggedIn = true
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
    
    //MARK: Biometrics authentication
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
                    if let text = KeychainWrapper.standard.string(forKey: "BuongiornoAccessToken") {
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

#Preview {
    LoginPageView()
}
