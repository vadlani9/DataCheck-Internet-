# DataCheck (Internet check)
Check data is getting or not in iOS using Swift

// Access the function
NetworkChecker.shared.hasRealInternet { isConnected in
    if isConnected {
        // ✅ Proceed with API call
    } else {
        // ❌ Show offline message or handle fallback
    }
}
