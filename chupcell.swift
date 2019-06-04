import UIKit
import Photos
import PhotosUI
@available(iOS 9.1, *)
class chupcell: UICollectionViewCell {
    @IBOutlet weak var livephoto: PHLivePhotoView!
    func exportLivePhoto (mov:String,jpg:String) {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: mov), options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: jpg), options: options)
        }, completionHandler: { (success, error) -> Void in
            if !success {
                DTLog((error?.localizedDescription)!)
            }else{
                NotificationCenter.default.post(name: .SaveSCMy, object: nil)
            }
        })
    }
}
