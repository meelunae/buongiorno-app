//
//  SignupPageView.swift
//  Buongiorno
//
//  Created by Meelunae on 24/07/23.
//

import SwiftUI

struct SignupPageView: View {
    @State private var username = ""
    @State private var displayName = ""
    @State private var email = ""
    @State private var pronouns = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    var body: some View {
        
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack {
                
                Form {
                    Section(content: {
                        LabeledContent {
                            TextField("", text: $username)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .textContentType(.username)
                        } label: {
                            Text("Username")
                                .fontWeight(.semibold)
                                .frame(width: 150)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        LabeledContent {
                            TextField("", text: $email)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .textContentType(.username)
                        } label: {
                            Text("Email")
                                .fontWeight(.semibold)
                                .frame(width: 150)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        LabeledContent {
                            SecureField("", text: $password)
                        } label: {
                            Text("Password")
                                .fontWeight(.semibold)
                                .frame(width: 150)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        LabeledContent {
                            SecureField("", text: $confirmPassword)
                        } label: {
                            Text("Confirm Password")
                                .fontWeight(.semibold)
                                .frame(width: 150)
                                .multilineTextAlignment(.trailing)
                        }
                    })
                    
                    Section(content: {
                        LabeledContent {
                            TextField("", text: $displayName)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .textContentType(.username)
                        } label: {
                            Text("Display name")
                                .fontWeight(.semibold)
                                .frame(width: 150)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        LabeledContent {
                            TextField("e.g. he/him, she/her, they/them", text: $pronouns)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .textContentType(.username)
                        } label: {
                            Text("Pronouns")
                                .fontWeight(.semibold)
                                .frame(width: 150)
                                .multilineTextAlignment(.trailing)
                        }
                    }, footer: {
                        HStack {
                            Spacer()
                            Button(action: {
                                signupAPICall(displayName: displayName, username: username, email: email, password: password, confirmPassword: confirmPassword)
                            }, label: {
                                Label("Sign up", systemImage: "arrow.right.to.line")
                            })
                            .padding()
                            .disabled(displayName.count < 3 && username.count < 3 && password.count < 8 && confirmPassword.count < 8 && email.count < 1)
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
            }
        }
    }
}



func signupAPICall(displayName: String, username: String, email: String, password: String, confirmPassword: String ) {
    guard let url = URL(string: "http://127.0.0.1:1337/users") else {
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable] = ["display_name": displayName, "username": username, "email": email, "password": password, "confirmPassword": confirmPassword]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("Success: \(response)")
        } catch {
            print(error)
        }
    }
    task.resume()
}

#Preview {
    SignupPageView()
}
