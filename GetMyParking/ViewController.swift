//
//  ViewController.swift
//  GetMyParking
//
//  Created by Suruchi Sinha on 1/14/18.
//  Copyright © 2018 Suruchi Sinha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomDataSource {    

    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var toastLabel: UILabel!
    
    var imageSize = CGSize(width: 0, height: 0)
    var collectionView: UICollectionView!
    var imagesArray = [String]()
    let cellReuseIdentifier = "imageCell"
    let imageHandler = ImageHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Shall fetch the list of image urls from the server.
//        imageHandler.getResourceList { (imageUrls) in
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()
    }
    
    ///Configures the content view with the collection view.
    func configureCollectionView() {
        let flowlayout = CustomLayout()
        flowlayout.delegate = self
        flowlayout.horizontalOffset = 10.0
        flowlayout.verticalOffset = 5.0
        flowlayout.maxWidth = self.contentView.bounds.width
        flowlayout.maxHeight = self.contentView.bounds.height
        collectionView = UICollectionView(frame: self.contentView.bounds , collectionViewLayout: flowlayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CustomImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        contentView.addSubview(collectionView)
    }
    
    @IBAction func downloadSmallestImageSize(_ sender: Any) {
        imageSize = CGSize(width: 30, height: 40)
        downloadImages()
    }

    @IBAction func downloadMidSizeImages(_ sender: Any) {
        imageSize = CGSize(width: 300, height: 400)
        downloadImages()
    }
    
    @IBAction func downloadLargeSizedImages(_ sender: Any) {
        imageSize = CGSize(width: 1000, height: 1200)
        downloadImages()
    }
    
    @IBAction func launchGalleryToUpload(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    ///Uploades image data to the server.
    func uploadImage(_ image: UIImage) {
        showToastMessage("Uploading Image!")
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        if imageData != nil {
            imageHandler.uploadImageToServer(imageData!, completion: { (imageUrl, uploadStatus) in
                let message: String
                if uploadStatus && imageUrl != nil {
                    DataModel.sharedInstance.setImageUrl(imageUrl!)
                    message = "Image uploaded successfully!"
                }else {
                    message = "Error in uploading image!"
                }
                self.showToastMessage(message)
            })
        }
    }
    
    ///Reloads collection view for displaying the images of the selected size.
    func downloadImages() {
        imagesArray.removeAll()
        ///Currently stores the url of the images uploaded. Though the urls shall be fetched from the server.
        let imageUrls = DataModel.sharedInstance.getImageUrls()
        if imageUrls != nil {
            imagesArray = imageUrls!
            reconfigureCollectionView()
        }
    }
    
    func reconfigureCollectionView() {
        collectionView.removeFromSuperview()
        collectionView = nil
        configureCollectionView()
    }
    
    
    func showToastMessage(_ message: String) {
        toastLabel.text = message
        self.toastView.isHidden = false
        self.toastView.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            self.toastView.alpha = 0.0
        }) { (finished: Bool) in
            self.toastView.isHidden = true
        }
    }
    
    ///UICollectionView delegate and datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CustomImageCell
        cell.setImageWithUrl(nil)
        let imageUrl = imagesArray[indexPath.row]
        imageHandler.downloadImageFromServer(imageUrl) { (image) in
            if image != nil {
                cell.setImageWithUrl(image)
            }
        }
        return cell
    }
    
    ///UIImagePickerController delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    ///CustomDataSource method
    func contentSizeForIndex() -> CGSize {
        return imageSize
    }

}

