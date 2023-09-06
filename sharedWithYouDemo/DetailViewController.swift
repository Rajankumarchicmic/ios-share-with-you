//
//  DetailViewController.swift
//  sharedWithYouDemo
//
//  Created by ChicMic on 22/08/23.
//

import UIKit
import SharedWithYou
import LinkPresentation
import MessageUI
class DetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    var titleString = ""
    var imageName = ""
    var desc = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        AppConstant().loadImageFromURL(imageName) { image in
            DispatchQueue.main.async {
                self.image.image = image
            }
        }
        self.label.text = desc
    }
    
    @IBAction func shareContent(_ sender: UIButton){
        let data = ["imageURL": imageName, "title": titleString, "description":desc]
         DynamicLinkGenerator().generateDynamicLink(data: data, completion: { url in
//        var url1 =  DynamicLinkGenerator().addParametersToURL(baseURL: AppConstant.baseUrl, parameters: data)
             let activityItems: [Any] = [url]
      
             let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
             self.present(activityViewController, animated: true, completion: nil)
        })//DynamicLinkGenerator().addParametersToURL(baseURL: AppConstant.baseUrl, parameters: ["image": imageName, "title": titleString, "description": desc])
      
    }
     
    func generatePreviewForLocalImage() -> LPLinkMetadata {
        let metadata = LPLinkMetadata()
        metadata.title =  titleString
        metadata.originalURL = URL(string: AppConstant.baseUrl)
        metadata.url = URL(string: AppConstant.baseUrl)
      let  imageUrl = URL(string: imageName)
        metadata.imageProvider = NSItemProvider(contentsOf: imageUrl!)
        return metadata
    }
    func fetchPreview(urlString: String)-> LPLinkView{
        
        guard let url = URL(string: AppConstant.baseUrl) else {
                    return LPLinkView()
                }
                let linkPreview = LPLinkView()
                let provider = LPMetadataProvider()
                provider.startFetchingMetadata(for: url, completionHandler: {
                    [weak self] metaData, error in
                    guard let data = metaData, error == nil else{
                        return
                    }
                    DispatchQueue.main.async {
                      //  linkPreview.metadata = self?.generatePreviewForLocalImage(image: UIImage(named: self?.imageName ?? "")!, url: url) ?? data
                        linkPreview.metadata.title = self?.titleString  ?? ""
//                        linkPreview.metadata = data

                        linkPreview.frame = CGRect(x: 0, y: 0, width: 100, height: 120)
                    }

                })
        return linkPreview
            }
}
