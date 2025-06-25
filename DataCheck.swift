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

    /// Returns true if device has actual internet access (not just Wi-Fi connected)
    func hasRealInternet(completion: @escaping (Bool) -> Void) {
        guard isNetworkPathSatisfied else {
            completion(false)
            return
        }
        
        // Light-weight ping to verify real internet access
        guard let url = URL(string: "https://www.apple.com/library/test/success.html") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}

/*
// Use case -


 DataCheck.shared.hasRealInternet { isConnected in
     if isConnected {
         // ✅ Proceed with API call
     } else {
         // ❌ Show offline message or handle fallback
     }
 }

 
 */
