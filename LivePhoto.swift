import UIKit
import Photos
import PhotosUI
import MobileCoreServices
struct FilePaths {
    static let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask,true)[0] as AnyObject
    struct VidToLive {
        static var livePath = FilePaths.documentsPath.appending("/")
    }
}
@available(iOS 9.1, *)
class LivePhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var livePhotoView: PHLivePhotoView! 
    @IBAction func abtn_Save(_ sender: Any) {
        self.exportLivePhoto()
        let myalert = UIAlertController(title: "Save", message: "Save Successfully", preferredStyle: UIAlertControllerStyle.alert)
        myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Selected")
        })
        self.present(myalert, animated: true, completion: nil)
    }
    func loadVideoWithVideoURL(_ videoURL: URL) {
        livePhotoView.livePhoto = nil
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = NSValue(time: CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, asset.duration.timescale))
        generator.generateCGImagesAsynchronously(forTimes: [time]) { [weak self] _, image, _, _, _ in
            if let image = image, let data = UIImagePNGRepresentation(UIImage(cgImage: image)) {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let imageURL = urls[0].appendingPathComponent("image.jpg")
                try? data.write(to: imageURL, options: [.atomic])
                let image = imageURL.path
                let mov = videoURL.path
                let output = FilePaths.VidToLive.livePath
                let assetIdentifier = UUID().uuidString
                let _ = try? FileManager.default.createDirectory(atPath: output, withIntermediateDirectories: true, attributes: nil)
                do {
                    try FileManager.default.removeItem(atPath: output + "/IMG.JPG")
                    try FileManager.default.removeItem(atPath: output + "/IMG.MOV")
                } catch {
                }
                _ = DispatchQueue.main.sync {
                    PHLivePhoto.request(withResourceFileURLs: [ URL(fileURLWithPath: FilePaths.VidToLive.livePath + "/IMG.MOV"), URL(fileURLWithPath: FilePaths.VidToLive.livePath + "/IMG.JPG")],
                                        placeholderImage: nil,
                                        targetSize: self!.view.bounds.size,
                                        contentMode: PHImageContentMode.aspectFit,
                                        resultHandler: { (livePhoto, info) -> Void in
                                            self?.livePhotoView.livePhoto = livePhoto
                    })
                }
            }
        }
    }
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeMovie as String]
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let url = info[UIImagePickerControllerMediaURL] as? URL {
                self.loadVideoWithVideoURL(url)
            }
        }
    }
    func exportLivePhoto () {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: FilePaths.VidToLive.livePath + "/IMG.MOV"), options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: FilePaths.VidToLive.livePath + "/IMG.JPG"), options: options)
        }, completionHandler: { (success, error) -> Void in
            if !success {
                DTLog((error?.localizedDescription)!)
            }
        })
    }
}
