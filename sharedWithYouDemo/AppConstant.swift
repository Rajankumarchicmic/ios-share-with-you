//
//  AppConstant.swift
//  sharedWithYouDemo
//
//  Created by ChicMic on 22/08/23.
//

import Foundation
import UIKit
struct AppConstant {
    static let baseUrl = "https://72c1-112-196-113-2.ngrok-free.app/opinion"
    
    func loadImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }

}
