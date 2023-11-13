//
//  AppDelegate.swift
//  Buongiorno
//
//  Created by Meelunae on 13/11/23.
//

import Foundation
import SDWebImageSwiftUI
import SDWebImagePhotosPlugin
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Supports HTTP URL as well as Photos URL globally
        SDImageLoadersManager.shared.loaders = [SDWebImageDownloader.shared, SDImagePhotosLoader.shared]
        // Replace default manager's loader implementation
        SDWebImageManager.defaultImageLoader = SDImageLoadersManager.shared
        // Add multiple caches
        let cache = SDImageCache(namespace: "tiny")
        cache.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB memory
        cache.config.maxDiskSize = 50 * 1024 * 1024 // 50MB disk
        SDImageCachesManager.shared.addCache(cache)
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
        return true
    }
}
