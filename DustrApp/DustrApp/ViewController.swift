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
    
    fileprivate var assetArray = [PHAsset]()
    
    fileprivate var deletionArray = [PHAsset]()
    
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
        kolodaView?.swipe(.left)
        //arrayToDelete.append(assetArray[kolodaView?.currentCardIndex])
    }
    
    @IBAction func dRightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    
    @IBAction func dUndoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    func loadPhotos() {
        let imagesManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            // if there images
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    let currentimage = fetchResult.object(at: i)
                    assetArray.append(currentimage)
                    imagesManager.requestImage(for: currentimage as PHAsset, targetSize: CGSize(width: currentimage.pixelHeight, height: currentimage.pixelWidth), contentMode: .aspectFit, options: requestOptions, resultHandler: {
                        image, error in
                        self.dataSource.append(image!)
                    })
                }
            }
        }
    }
}

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
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
