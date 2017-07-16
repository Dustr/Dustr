//
//  ViewController.swift
//  DustrApp
//
//  Created by Hamza Ghani on 7/9/17.
//  Copyright © 2017 Dustr. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   var imgArray = [UIImage]()
   var index = 0
    
    
    
    @IBOutlet weak var currentImage: UIImageView!
   
    
    @IBAction func addPhoto(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            
            //after it is complete
        }

    }
    
    
    func loadPhotos() {
        let imagesManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic    //balance between image quality and speed
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            // if there images
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    
                    imagesManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        image, error in
                        
                        self.imgArray.append(image!)
                    })
                }
            }
            
        }

        
        
    }
    
    
    @IBAction func nextPhoto(_ sender: Any) {
        currentImage.image = imgArray[index]
        index += 1
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentImage.image = image
        }
            
        else {
            //error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
