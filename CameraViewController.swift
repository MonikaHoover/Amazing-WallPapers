import UIKit
import AVFoundation
import CameraManager
import Photos
import PhotosUI
import MobileCoreServices
var checkCamera = 0
@available(iOS 10.0, *)
class CameraViewController: UIViewController {
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var kindOf:Int?
    @IBOutlet weak var btn_switchCamera: UIButton!
    @IBOutlet weak var btn_Flash: UIButton!
    var frontCamera: AVCaptureDevice?
    @IBOutlet weak var btn_TouchCamera: UIButton!
    @IBOutlet var cameraview: UIView!
    @IBOutlet weak var Switch_camera: UIImageView!
    var currtenCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraimage: UIImage?
    var cameraManager = CameraManager()
    @IBAction func abtn_switchCamera(_ sender: Any) {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
    }
    @IBAction func abtn_flash(_ sender: Any) {
        switch cameraManager.changeFlashMode() {
        case .off:
            btn_Flash.setImage(#imageLiteral(resourceName: "flash-off"), for: .normal)
        case .on:
            btn_Flash.setImage(#imageLiteral(resourceName: "flash-on"), for: .normal)
        case .auto:
          btn_Flash.setImage(#imageLiteral(resourceName: "flash-auto"), for: .normal)
        }
    }
    @IBAction func abtn_back(_ sender: Any) {
        NotificationCenter.default.post(name: .showChup, object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func abtn_TouchCamera(_ sender: Any) {
        switch cameraManager.cameraOutputMode {
        case .stillImage:
            cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                if error != nil {
                    self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                }
                else {
                    let vc: PictureViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ShowImage") as? PictureViewController
                    if let validVC: PictureViewController = vc,
                    let capturedImage = image{
                        validVC.imagePicture = capturedImage
                        validVC.cameraManager = self.cameraManager
                        self.navigationController!.pushViewController(validVC, animated: true)
                    }
                }
            })
        case .videoWithMic:
            cameraManager.startRecordingVideo()
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                self.cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
                    let asset = AVURLAsset(url: videoURL!)
                    let generator = AVAssetImageGenerator(asset: asset)
                    generator.appliesPreferredTrackTransform = true
                    let time = NSValue(time: CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, asset.duration.timescale))
                    generator.generateCGImagesAsynchronously(forTimes: [time]) { [weak self] _, image, _, _, _ in
                        if let image = image, let data = UIImagePNGRepresentation(UIImage(cgImage: image)) {
                            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                            let imageURL = urls[0].appendingPathComponent("LiveMy\(String(Int(LivePhoToMyCoreData.share.getID()!)! + 1))IMG.jpg")
                            try? data.write(to: imageURL)
                            let image = imageURL.path
                            let mov = videoURL?.path
                            let output = FilePaths.VidToLive.livePath
                            let assetIdentifier = UUID().uuidString
                            let _ = try? FileManager.default.createDirectory(atPath: output, withIntermediateDirectories: true, attributes: nil)
                            do {
                                try FileManager.default.removeItem(atPath: output + "/IMG.JPG")
                                try FileManager.default.removeItem(atPath: output + "/IMG.MOV")
                            } catch {
                            }
                            let movOut = urls[0].appendingPathComponent("LiveMy\(String(Int(LivePhoToMyCoreData.share.getID()!)! + 1))IMG.MOV")
                            let imaOut = urls[0].appendingPathComponent("LiveMy\(String(Int(LivePhoToMyCoreData.share.getID()!)! + 1))IMG.JPG")
                            JPEG(path: image).write(imaOut, assetIdentifier: assetIdentifier)
                            QuickTimeMov(path: mov!).write(movOut,
                                                           assetIdentifier: assetIdentifier)
                            _ = DispatchQueue.main.sync {
                                LivePhoToMyCoreData.share.saveData(id: String(Int(LivePhoToMyCoreData.share.getID()!)! + 1), linkDataMOV: movOut.path, linkDataIMG: imaOut.path)
                                let livePT:PHLivePhotoView = PHLivePhotoView()
                                PHLivePhoto.request(withResourceFileURLs: [ movOut, imaOut],
                                                    placeholderImage: nil,
                                                    targetSize: UIScreen.main.bounds.size,
                                                    contentMode: PHImageContentMode.aspectFit,
                                                    resultHandler: { (livePhoto, info) -> Void in
                                                        livePT.livePhoto = livePhoto
                                                        livePhotoMyTemp["LiveMy\(String(Int(LivePhoToMyCoreData.share.getID()!)!))"] = livePT
                                                        NotificationCenter.default.post(name: .reloadLiveWallpapers, object: nil)
                                })
                            }
                        }
                    }
                })
                NotificationCenter.default.post(name: .showChup, object: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
            break
        case .videoOnly:
            break
        }
        btn_TouchCamera.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.abtn_back4vnRWallpapers("byebye", self)
        let currentCameraState = cameraManager.currentCameraStatus()
        if currentCameraState == .accessDenied{
            navigationController?.popToRootViewController(animated: true)
            let alert = UIAlertController(title: "Camera Access Denied", message: "You need to go to settings app and grant acces to the camera device to use it", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.abtn_flashJkXWallpapers("baby", self)
        }else{
            if self.kindOf! == 1{
                addCameraToView()
                cameraManager.addPreviewLayerToView(cameraview, newCameraOutputMode: CameraOutputMode.stillImage)
            }else{
                addCameraToView()
                cameraManager.addPreviewLayerToView(cameraview, newCameraOutputMode: CameraOutputMode.videoWithMic)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkCamera = 1
        self.abtn_TouchCamerawHKrWallpapers("viewwiwlll", self)
        navigationController?.tabBarController?.tabBar.isHidden = true
        if self.kindOf! == 1{
            btn_Flash.setImage(#imageLiteral(resourceName: "flash-off"), for: .normal)
            if cameraManager.hasFlash {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(abtn_flash(_:)))
                btn_Flash.addGestureRecognizer(tapGesture)
            }
            btn_switchCamera.setImage(#imageLiteral(resourceName: "icon-switchCamera"), for: .normal)
            let cameraTypeGesture = UITapGestureRecognizer(target: self, action: #selector(abtn_switchCamera(_:)))
            btn_switchCamera.addGestureRecognizer(cameraTypeGesture)
            cameraManager.animateCameraDeviceChange = false
            cameraManager.cameraOutputQuality = .high
            cameraManager.shouldFlipFrontCameraImage = true
            cameraManager.animateShutter = true
            cameraManager.exposureMode = .custom
            cameraManager.resumeCaptureSession()
            btn_TouchCamera.isHidden = false
            btn_TouchCamera.setImage(UIImage(named: "icon-Takephoto"), for: .normal)
        }else{
            btn_Flash.isHidden = true
            btn_switchCamera.setImage(#imageLiteral(resourceName: "icon-switchCamera"), for: .normal)
            btn_TouchCamera.setImage(UIImage(named: "icon-recordvideo"), for: .normal)
            let cameraTypeGesture = UITapGestureRecognizer(target: self, action: #selector(abtn_switchCamera(_:)))
            btn_switchCamera.addGestureRecognizer(cameraTypeGesture)
            cameraManager.animateCameraDeviceChange = false
            cameraManager.cameraOutputQuality = .high
            cameraManager.shouldFlipFrontCameraImage = true
            cameraManager.animateShutter = true
            cameraManager.exposureMode = .custom
            cameraManager.resumeCaptureSession()
            btn_TouchCamera.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        cameraManager.stopCaptureSession()
    }
    func setupInputOutput(){
    }
    fileprivate func addCameraToView()
    {
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
