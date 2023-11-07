//
//  ProfileViewModel.swift
//  Buongiorno
//
//  Created by Meelunae on 04/08/23.
//

import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class ProfileViewModel: ObservableObject {
    
    // MARK: - Profile Details
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @Published var displayName: String = "undefined"
    @Published var username: String = "undefined"
    @Published var bio: String = "undefined"
    @Published var profilePictureURL: String = "undefined"
    @Published var pronouns: String = "undefined"
    @Published var friendsCount: Int = 0
    @Published var scoreCount: Int = 0
    
    
    init() {
        fetchProfileData()
    }
    // MARK: - Profile Image
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - Private Methods
    
     func patchProfileData(displayName: String, pronouns: String, bio: String, completion: @escaping (Bool) -> Void) {
         guard let url = URL(string: "http://127.0.0.1:1337/api/user/") else {
            completion(false)
            return
        }
        guard let authToken = KeychainWrapper.standard.string(forKey: "GdayAuthToken") else {
            completion(false)
            return
        }
        
        let updateData: [String: Any] = [
            "displayName": displayName,
            "pronouns": pronouns,
            "bio": bio
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updateData)
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false)
                    print("Error: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        print(String(data: data, encoding: .utf8))
                        do {
                            let decoder = JSONDecoder()
                            let decodedObject = try decoder.decode(APIResponse<UserDetailsDTO>.self, from: data)
                            print(decodedObject)
                        }  catch let error {
                            print("Error decoding JSON: \(error)")
                        }
                        if let successResponse = try? decoder.decode(APIResponse<UserDetailsDTO>.self, from: data) {
                            print(successResponse)
                            guard let user = successResponse.data else {
                                completion(false)
                                return
                            }
                            print(user)
                            DispatchQueue.main.async {
                                self.displayName = user.displayName
                                self.bio = user.bio
                                self.pronouns = user.pronouns
                                completion(true)
                            }
                        } else if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                            print("Error: \(errorResponse)")
                            completion(false)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                }
            }
            task.resume()
        }
        catch {
            completion(false)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func fetchProfileData() {
        guard let url = URL(string: "http://127.0.0.1:1337/api/user/emanuele") else {
            return
        }
        guard let authToken = KeychainWrapper.standard.string(forKey: "GdayAuthToken") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    if let successResponse = try? decoder.decode(APIResponse<UserDetailsDTO>.self, from: data) {
                        guard let user = successResponse.data else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.username = user.username
                            self.profilePictureURL = user.profilePicture
                            self.bio = user.bio
                            self.scoreCount = user.score
                            self.friendsCount = 0
                            self.pronouns = user.pronouns
                            self.displayName = user.displayName
                        }
                    } else if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                        print("Error: \(errorResponse)")
                        return
                    } else {
                        return
                    }
                }
            }
        }
        task.resume()

    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
