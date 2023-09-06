//
//  DynamicLinkGenerator.swift
//  sharedWithYouDemo
//
//  Created by ChicMic on 23/08/23.
//

import Foundation
import Branch
import FirebaseCore
import FirebaseFirestore
import FirebaseDynamicLinks
class DynamicLinkGenerator {
    func addParametersToURL(baseURL: String, parameters: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    func extractParametersFromURL(_ url: URLComponents) -> [String: String]? {
        guard let queryItems = url.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        
        for queryItem in queryItems {
            if let value = queryItem.value {
                parameters[queryItem.name] = value
            }
        }
        
        return parameters.isEmpty ? nil : parameters
    }
    func handleDynamicLink(_ dynamicLink: DynamicLink?)-> [String: String]? {
         guard let dynamicLink = dynamicLink, let url = dynamicLink.url else {
             print("No dynamic link found.")
             return [:]
         }
        var parameters = [String: String]()
         if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems {
          
             
             for queryItem in queryItems {
                 if let value = queryItem.value {
                     parameters[queryItem.name] = value
                 }
             }
             
         }
        return parameters.isEmpty ? nil : parameters
     }

    
//    func generateDynamicLink(data:[String: String], completion: @escaping(_ urlData: String)->Void){
//        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
//        branchUniversalObject.title = data["title"] ?? ""
//        branchUniversalObject.contentDescription = data["description"] ?? ""
//        branchUniversalObject.imageUrl = data["imageURL"] ?? ""
////        for (key, value) in data{
//            branchUniversalObject.addMetadataKey("custom_key", value: "custom_value")
////        }
//
//
//        let linkProperties = BranchLinkProperties()
//     //   linkProperties.feature = "sharing"
//        linkProperties.channel = "ios"
//       // linkProperties.campaign = "summer_sale"
//
//        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
//            if let url = url {
//                print("Dynamic link URL: \(url)")
//                completion(url)
//                // Share or use the URL as needed
//            } else if let error = error {
//                print("Error creating dynamic link: \(error.localizedDescription)")
//            }
//        }
//
//    }
    
    func generateDynamicLink(data:[String:String],completion:@escaping(_ urlvaue: String)->Void) {

            guard let link = URL(string: "https://72c1-112-196-113-2.ngrok-free.app/opinion") else { return }
            
            let dynamicLinksDomain = "https://sharedemo1.page.link"
            let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomain)
            
            // Set iOS parameters
            let iOSParams = DynamicLinkIOSParameters(bundleID: "com.ios.sharedWithYou")
            iOSParams.minimumAppVersion = "1.0"
        linkBuilder?.iOSParameters = iOSParams
            
            // Set social media parameters for image preview
            let socialParams = DynamicLinkSocialMetaTagParameters()
            socialParams.imageURL = URL(string: data["imageURL"] ?? "")
        socialParams.title = data["title"] ?? ""
        socialParams.descriptionText = data["description"] ?? ""
        linkBuilder?.socialMetaTagParameters = socialParams
            
            // Set custom parameters
            let analyticsParams = DynamicLinkGoogleAnalyticsParameters(source: "app", medium: "dynamic-link", campaign: "example-campaign")
        linkBuilder?.analyticsParameters = analyticsParams
            
            // Create the dynamic link
        guard let longDynamicLink = linkBuilder?.url else { return }
            
            print("Long Dynamic Link: \(longDynamicLink)")

            // Shorten the dynamic link
            DynamicLinkComponents.shortenURL(
                longDynamicLink,
                options: nil
            ) { shortenedURL, warnings, error in
                if let error = error {
                    print("Error shortening URL: \(error.localizedDescription)")
                    return
                }
                
                if let shortenedURL = shortenedURL {
                    print("Shortened Dynamic Link: ")
                    completion("\(shortenedURL)")
                    // Share or use the shortenedURL as needed
                }
            }
    }
    
//    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink?) {
//        if let dynamicLink = dynamicLink,
//           let url = dynamicLink.url {
//            dynamicLink.url.qu
//
//
//            // Handle other parameters or navigate as necessary
//            print("Incoming Dynamic Link URL: \(url)")
//        }
//    }
  








}

