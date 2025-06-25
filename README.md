# DataCheck (Internet check)
Check data is getting or not in iOS using Swift

'https://www.apple.com/library/test/success.html' is the url from apple, but not official listed api. 
If it removes from the apple, use your own api.
Both scenarios handled here.



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



 Check and improve if any, thank you...
