import UIKit
import AVFoundation
class CameraVideoViewController: UIViewController {
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currtenCamera: AVCaptureDevice?
    var videoOutput: AVCaptureMovieFileOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    let error:Error? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        self.setupCaptureSessionPHGWallpapers("best")
    }
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    }
    func setupDevice(){
        if #available(iOS 10.0, *) {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            let devices = deviceDiscoverySession.devices
            for device in devices{
                if device.position == AVCaptureDevice.Position.back{
                    backCamera = device
                }else if device.position == AVCaptureDevice.Position.front{
                    frontCamera = device
                }
            }
            currtenCamera = backCamera
        } else {
        }
    }
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currtenCamera!)
            captureSession.addInput(captureDeviceInput)
            videoOutput = AVCaptureMovieFileOutput()
            let maxDuration:CMTime = CMTimeMake(600, 10)
            videoOutput?.maxRecordedDuration = maxDuration
            videoOutput?.minFreeDiskSpaceLimit = 1024*1024
            if self.captureSession.canAddOutput(videoOutput!){
                  captureSession.addOutput(videoOutput!)
            }
        }catch{
            print(error)
        }
    }
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}
extension CameraVideoViewController: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print(fileURL)
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(outputFileURL)
        let filemainURL = outputFileURL
        do{
            let asset = AVURLAsset(url: filemainURL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            let userReponseThumbImageData = try Data(contentsOf: filemainURL)
            print(userReponseThumbImageData)
            print(uiImage)
        }
        catch let error as Error{
            print(error)
            return
    }
    }
}
