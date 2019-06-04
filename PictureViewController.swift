import UIKit
import CameraManager
class PictureViewController: UIViewController {
    var imagePicture:UIImage!
    var cameraManager = CameraManager()
    @IBAction func abtn_save(_ sender: Any) {
        do{
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            var fileURL:URL?
            if #available(iOS 10.0, *) {
                if TakePhotoCoreData.share.getID() == "-1"{
                    fileURL = documentsURL.appendingPathComponent("yourPhoto\(0).jpg")
                    TakePhotoCoreData.share.saveData(id: "0")
                }else{
                    let newId = Int(TakePhotoCoreData.share.getID()!)! + 1
                    print(newId)
                    fileURL = documentsURL.appendingPathComponent("yourPhoto\(newId).jpg")
                    TakePhotoCoreData.share.saveData(id: "\(newId)")
                }
                if let pngImageData = UIImageJPEGRepresentation(imagePicture, 1.0) {
                    try pngImageData.write(to: fileURL!, options: .atomic)
                }
            } else {
            }
        }catch{
            print("Lỗi chụp hình")
        }
        NotificationCenter.default.post(name: .showChup, object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func abtn_backtoCamera(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var photoimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.abtn_backcqJgXWallpapers("setinpapa", self)
        photoimage.image = imagePicture
        if cameraManager.cameraDevice == .front {
            self.abtn_saveToPpHWallpapers("inPapa", self)
            switch imagePicture.imageOrientation {
            case .up, .down:
                self.photoimage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            default:
                break
            }
        }
        NotificationCenter.default.post(name: .Library, object: nil)
    }
    @IBAction func abtn_back(_ sender: Any) {
        self.abtn_backtoCameraMJahpWallpapers("carama", self)
        NotificationCenter.default.post(name: .showChup, object: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }   
}
