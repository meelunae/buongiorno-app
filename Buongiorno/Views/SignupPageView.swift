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
    @State private var password = ""
    @State private var confirmPassword = ""
    var body: some View {

        LoginTextField(text: $displayName, placeholder: "Display name")
        LoginTextField(text: $username, placeholder: "Username")
        LoginTextField(text: $email, placeholder: "Email")
        
        SecureLoginTextField(text: $password, placeholder: "Password")
        SecureLoginTextField(text: $confirmPassword, placeholder: "Confirm Password")


        Button("Signup") {
            print(confirmPassword)
            signupAPICall(displayName: displayName, username: username, email: email, password: password, confirmPassword: confirmPassword)
        }
        .disabled(displayName.count < 3 && username.count < 3 && password.count < 8 && confirmPassword.count < 8 && email.count < 1)
        .opacity(username.count < 3 ? 0.5 : 1.0)
        .foregroundColor(.white)
        .frame(width: 300, height: 50)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
    }
}



func signupAPICall(displayName: String, username: String, email: String, password: String, confirmPassword: String ) {
    guard let url = URL(string: "http://127.0.0.1:8080/user") else {
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


