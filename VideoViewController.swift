    import UIKit
    import AVFoundation
  class VideoViewController: UIViewController {
        var captureSession = AVCaptureSession()
        var backCamera: AVCaptureDevice?
        var frontCamera: AVCaptureDevice?
        var currentCamera: AVCaptureDevice?
        var videoOutput: AVCaptureMovieFileOutput
        var activeInput: AVCaptureDeviceInput!
        var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
        var cameraimage: UIImage?
        override func viewDidLoad() {
            super.viewDidLoad()
            setupCaptureSession()
            setupPreviewLayer()
            startRunningCaptureSession()
        }
        @IBAction func abtn_back(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
        @IBAction func abtn_record(_ sender: Any) {
            let setting = AVCapturePhotoSettings()
            videoOutput.
        }
        func setupCaptureSession(){
            captureSession.sessionPreset = AVCaptureSession.Preset.high
            setupDevice()
            setupInputOutput()
        }
        func  setupDevice(){
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            let devices = deviceDiscoverySession.devices
            for device in devices{
                if device.position == AVCaptureDevice.Position.back{
                    backCamera = device
                }else if device.position == AVCaptureDevice.Position.front{
                    frontCamera = device
                }
            }
            currentCamera = backCamera
        }
    func setupInputOutput(){do {
        let input = try AVCaptureDeviceInput(device: currentCamera!)
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            activeInput = input
        }
            } catch {
        print("Error setting device video input: \(error)")
        }
        if captureSession.canAddOutput(videoOutput){
                captureSession.addOutput(videoOutput)
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
            if !captureSession.isRunning {
                videoQueue().async {
                    self.captureSession.startRunning()
                }
            }
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "show"{
                let previewVC = segue.destination as! PictureViewController
                previewVC.imagePicture = self.cameraimage
            }
        }
    }
    extension CameraViewController: AVCapturePhotoCaptureDelegate{
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(){
                cameraimage = UIImage(data: imageData)
                performSegue(withIdentifier: "show", sender: nil)
            }
        }
}
