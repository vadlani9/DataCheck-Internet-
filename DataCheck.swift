//
//  DataCheck.swift
//  NareshApp
//
//  Created by Naresh on 25/06/25.
//  Copyright © 2025 Naresh. All rights reserved.
//

import Foundation
import Network

final class DataCheck {
    static let shared = DataCheck()
    
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "DataCheckQueue")
    
    private var isMonitoring = false
    private var isNetworkPathSatisfied: Bool = false
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkPathSatisfied = path.status == .satisfied
        }
        
        monitor.start(queue: monitorQueue)
        isMonitoring = true
    }

    /// true if device has internet access
    func internetDataCheck(completion: @escaping (Bool) -> Void) {
        guard isNetworkPathSatisfied else {
            completion(false)
            return
        }
        
        // ping to verify real internet access
        // Step 1: Try Apple URL
        let appleURL = URL(string: "https://www.apple.com/library/test/success.html")!
        let customURL = URL(string: "\(yourcustomurlhere)/v1/health")!
        
        checkURL(appleURL) { success in
            if success {
                completion(true)
            } else {
                // Step 2: Fallback to custom health URL
                self.checkURL(customURL) { fallbackSuccess in
                    completion(fallbackSuccess)
                }
            }
        }
    }
    
    /// check a given URL
    private func checkURL(_ url: URL, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    /// Stop monitoring if needed (e.g., on app shutdown or testing)
    func stopMonitoring() {
        monitor.cancel()
        isMonitoring = false
    }
    
}


/*
 
 // Use case
 DataCheck.shared.internetDataCheck { isConnected in
     if isConnected {
         debugPrint("Getting Internet")
     } else {
         debugPrint("Not Getting Internet")
     }
 }
 
 // To stop monitoring
 DataCheck.shared.stopMonitoring()
 
 */
