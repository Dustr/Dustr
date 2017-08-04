//
//  ViewController.swift
//  DustrApp
//
//  Created by Hamza Ghani on 7/6/17.
//  Copyright © 2017 Dustr. All rights reserved.
//

import UIKit
import Photos
import Koloda

class ViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    
    fileprivate var dataSource = [UIImage]()
    
    fileprivate var currentAssetArray = [PHAsset]()
    
    fileprivate var deletionArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhotos()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dLeftButtonTapped() {
        deletionArray.add(currentAssetArray[kolodaView!.currentCardIndex])
        kolodaView?.swipe(.left)
    }
    
    @IBAction func dRightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    
    @IBAction func dUndoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    @IBAction func shareImageButton(_ sender: UIButton) {
        let image = dataSource[kolodaView!.currentCardIndex]
        
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.saveToCameraRoll ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func loadPhotos() {
        let imagesManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    let currentimage = fetchResult.object(at: i)
                    currentAssetArray.append(currentimage)
                    imagesManager.requestImage(for: currentimage as PHAsset, targetSize: CGSize(width: currentimage.pixelHeight, height: currentimage.pixelWidth), contentMode: .aspectFit, options: requestOptions, resultHandler: {
                        image, error in
                        self.dataSource.append(image!)
                    })
                }
            }
        }
    }
    
//    func checkPhotoLibraryPermission() {
//        let status = PHPhotoLibrary.authorizationStatus()
//        if (status == .authorized)
//            loadPhotos()
//        switch status {
//        case .authorized:
//        //handle authorized status
//        case .denied, .restricted :
//        //handle denied status
//        case .notDetermined:
//            // ask for permissions
//            PHPhotoLibrary.requestAuthorization() { status in
//                switch status {
//                case .authorized:
//                // as above
//                case .denied, .restricted:
//                // as above
//                case .notDetermined:
//                    // won't happen but still
//                }
//            }
//        }
//    }
    
}

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        if (deletionArray.count > 0) {
            PHPhotoLibrary.shared().performChanges( {
                PHAssetChangeRequest.deleteAssets(self.deletionArray)},
                completionHandler: {
                    success, error in
                    if(success) {
                        self.reloadPhotos()
                    } else{
                        print("There was an error")
                        self.reloadPhotos()
                    }
                }
            )
        }
        else {
            kolodaView.resetCurrentCardIndex()
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let fullscreenPhoto = UIImageView(image: dataSource[Int(index)])
        let newImageView = UIImageView(image: fullscreenPhoto.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func reloadPhotos() {
        deletionArray.removeAllObjects()
        currentAssetArray.removeAll()
        dataSource.removeAll()
        loadPhotos()
        kolodaView.resetCurrentCardIndex()
    }
    
}

// MARK: KolodaViewDataSource

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
