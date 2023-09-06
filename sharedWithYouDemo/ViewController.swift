//
//  ViewController.swift
//  sharedWithYouDemo
//
//  Created by ChicMic on 17/08/23.
//

import UIKit
import SharedWithYou
import LinkPresentation
import MessageUI

class ViewController: UIViewController, SWHighlightCenterDelegate {

    @IBOutlet weak var shareWithYou: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var sharedCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shareWithYouViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    let attributionView = SWAttributionView()
     var highlights: [SWHighlight] = []
    let viewModel = ViewModel()
    let highlightCenter = SWHighlightCenter()
        override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.delegate = self
            collectionView.dataSource = self
            sharedCollectionView.delegate = self
            sharedCollectionView.dataSource = self
            highlightCenter.delegate = self
        }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeight.constant = collectionView.contentSize.height + 20
        shareWithYouViewHeight.constant = sharedCollectionView.contentSize.height + 50
  scrollContentHeight.constant = (scrollView.contentSize.height)/3
        collectionView.reloadData()
    }
    @IBAction func selectImage(_ sender: UIImageView){
        
    }
    
    func generatePreviewForLocalImage(image: UIImage, url: URL, title: String) -> LPLinkMetadata {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.url = url
        metadata.imageProvider = NSItemProvider(object: image)
        return metadata
    }
    
    func fetchPreview(urlString: String, frame: CGRect)-> LPLinkView{
        
                guard let url = URL(string: urlString) else {
                    return LPLinkView()
                }
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return  LPLinkView()}
        let param = DynamicLinkGenerator().extractParametersFromURL(urlComponents)
                let linkPreview = LPLinkView()
                let provider = LPMetadataProvider()
                provider.startFetchingMetadata(for: url, completionHandler: {
                    [weak self] metaData, error in
                    guard let data = metaData, error == nil else{
                        return
                    }
                    DispatchQueue.main.async {
                        linkPreview.metadata =  data
                       // linkPreview.metadata.title = param?["title"]  ?? ""
//                        linkPreview.metadata = data

                        linkPreview.frame = frame
                    }

                })
        return linkPreview
            }
    
    func loadImage(itemProvider: NSItemProvider)-> UIImage{
        var returnImage = UIImage()
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            // Load the UIImage from the item provider
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    // Handle the image
                    DispatchQueue.main.async {
                        // Use the image on the main thread
                        returnImage =  image
                    }
                } else if let error = error {
                    // Handle the error
                    print("Error loading image:", error.localizedDescription)
                   
                } else {
                    print("Unknown error loading image")
                 
                }
            }
        } else {
            print("Item provider cannot load UIImage data")
            return UIImage()
        }
     return   returnImage
    }
    
    func highlightCenterHighlightsDidChange(_ highlightCenter: SWHighlightCenter) {
        
        self.highlights = highlightCenter.highlights
        sharedCollectionView.reloadData()
//        for highlight in highlightCenter.highlights{
//              let highlightUrl = highlight.url
//              print(highlightUrl)
//              let view = fetchPreview(urlString: "\(highlightUrl)")
//            let value = generateRichPreview(url: highlightUrl)
//            AppConstant().loadImageFromURL(value.1) { image in
//                DispatchQueue.main.async {
//                    self.highlightImage.image = image
//                }
//
//            }
////            desc.text = value.0
//              let attributionView = SWAttributionView()
//
//              attributionView.horizontalAlignment = .leading
//            attributionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 100)
//              attributionView.displayContext = .summary
//              attributionView.highlight = highlight
//             // view.addSubview(attributionView)
//            contactView.addSubview(attributionView)
//          self.highlight.addSubview(view)
//          }
    }
    
}

class CustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sharedCollectionView{
            return self.highlights.count
        }else{
            return viewModel.imageName.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.sharedCollectionView{
            if let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedCell", for: indexPath) as? SharedCell{
                let highlight = self.highlights[indexPath.row]
                let attributionView = SWAttributionView()

                attributionView.horizontalAlignment = .leading
                attributionView.frame =  CGRect(x: 0, y: 0, width: cell.contact.frame.width, height: 50)
                attributionView.displayContext = .summary
                attributionView.highlight = highlight
                cell.contact.addSubview(attributionView)
                cell.preView.addSubview(fetchPreview(urlString: "\(highlight.url)", frame: cell.preView.frame))
              //  cell.contact.backgroundColor = .red
                return cell
            }
        }else{
            if let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell{
                
                AppConstant().loadImageFromURL(viewModel.imageName[indexPath.row]) { image in
                   
                    DispatchQueue.main.async {
                        cell.image.layer.cornerRadius = 7
                        cell.image.image = image
                    }
                }
                
                cell.title.text = viewModel.title[indexPath.row]
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard  let vc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else{return}
            vc.imageName = viewModel.imageName[indexPath.row]
            vc.titleString = viewModel.title[indexPath.row]
            vc.desc = viewModel.desc[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
 
    }
    
}
