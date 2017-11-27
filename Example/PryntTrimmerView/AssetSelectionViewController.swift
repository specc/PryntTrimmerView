//
//  AssetSelectionViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 25/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class AssetSelectionViewController: UIViewController, UINavigationControllerDelegate {


    public var videoLength = 0.0;

    var fetchResult: PHFetchResult<PHAsset>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLibrary()
    }

    func loadLibrary() {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.fetchResult = PHAsset.fetchAssets(with: .video, options: nil)
            }
        }
    }

    func loadAssetRandomly() {

      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.mediaTypes = [kUTTypeImage, kUTTypeMovie] as [String]
      imagePickerController.videoQuality = .typeIFrame960x540
      imagePickerController.videoMaximumDuration = TimeInterval(15.0)
      imagePickerController.allowsEditing = false  // Hand the editing to an explicit Editor
      imagePickerController.delegate = self
      self.present(imagePickerController, animated: true, completion: nil)


    }

    func loadAsset(_ asset: AVAsset) {
        // override in subclass
    }
}

extension AssetSelectionViewController: UIImagePickerControllerDelegate {
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

    guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {

      return
    }

    picker.dismiss(animated:true, completion: nil)


    switch mediaType {

    case String(kUTTypeMovie):

      guard let movieUrl = info[UIImagePickerControllerMediaURL] as? NSURL else {
        return
      }

      guard let moviePath = movieUrl.relativePath else {
        return
      }

      let avAsset = AVAsset(url: movieUrl as URL)
      self.loadAsset(avAsset)
      videoLength = avAsset.duration.seconds


    default:
      return
    }

  }
}
