import UIKit
import Photos
import PhotosUI
import MobileCoreServices
class YourWallpapers: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imageLibrary:UIImage?
    @IBOutlet weak var FadedView: UIView!
    @IBOutlet weak var View_My: UIView!
    @IBOutlet weak var btn_CreateWall: UIButton!
    @IBOutlet weak var btn_CreateLive: UIButton!
    var imagePicker: UIImagePickerController!
    var btn_expand_state = 0
    lazy var WallpapersControlller:UIViewController? = {
        let wallpapersController = self.storyboard?.instantiateViewController(withIdentifier: "Wallpapers_My")
        return wallpapersController
    }()
    lazy var LiveWallpapersController:UIViewController? = {
        let livewallpapersController = self.storyboard?.instantiateViewController(withIdentifier: "LiveWallpapers_My")
        return livewallpapersController
    }()
    var currentViewCOntroller:UIViewController?
    @IBOutlet weak var btn_expand: UIButton!
    @IBAction func abtn_Expand(_ sender: Any) {
        if btn_expand_state == 0{
            btn_expand.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
            let rotation = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/4))
            self.btn_expand.transform = rotation
            }, completion: nil)
            btn_expand_state = 1
            UIView.animate(withDuration: 0.5) {
                self.btn_CreateLive.alpha = 1
                self.btn_CreateWall.alpha = 1
                self.FadedView.alpha = 1
            }
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.5
            animation.values = [32, 0 ]
            btn_CreateWall.layer.add(animation, forKey: "move")
            let animation1 = CAKeyframeAnimation(keyPath: "transform.translation.y")
            animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation1.duration = 0.5
            animation1.values = [32, 0 ]
            btn_CreateLive.layer.add(animation, forKey: "move")
        }else{
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
                self.btn_expand.transform = CGAffineTransform.identity
            }, completion: nil)
            UIView.animate(withDuration: 0.3) {
                self.btn_expand_state = 0
                self.btn_CreateLive.alpha  = 0
                self.btn_CreateWall.alpha  = 0
                self.FadedView.alpha = 0
            }
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.3
            animation.values = [0, 32 ]
            btn_CreateWall.layer.add(animation, forKey: "move")
            let animation1 = CAKeyframeAnimation(keyPath: "transform.translation.y")
            animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation1.duration = 0.3
            animation1.values = [0, 32 ]
            btn_CreateLive.layer.add(animation, forKey: "move")
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_expand.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeDisplay), name: Notification.Name("ChangeDislay") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chup(_:)), name: .Wallpapers_Screen , object: nil)
        ChangeDisplayViewLoad(index: 0)
        btn_CreateLive.set(image: #imageLiteral(resourceName: "iconCreateLiveWallpapers") , title: "Create Live Wallpapers     ", titlePosition: .left, additionalSpacing: 8, state: .normal)
        btn_CreateWall.set(image: #imageLiteral(resourceName: "iconCreateWallpapers"), title: "Create Wallpapers     ", titlePosition: .left, additionalSpacing: 8, state: .normal)
        btn_CreateLive.alpha = 0
        btn_CreateWall.alpha  = 0
        FadedView.alpha  = 0
        FadedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TapFadedView(_:))))
    }
    @objc  func TapFadedView(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
            self.btn_expand.transform = CGAffineTransform.identity
        }, completion: nil)
        UIView.animate(withDuration: 0.5) {
            self.btn_expand_state = 0
            self.btn_CreateLive.alpha  = 0
            self.btn_CreateWall.alpha  = 0
            self.FadedView.alpha = 0
        }
    }
    func ChangeDisplayViewLoad(index:Int){
        let vc = CheckCollection(index: index)
        vc.didMove(toParentViewController: self)
        self.addChildViewController(vc)
        vc.view.frame = self.View_My.bounds
        View_My.addSubview(vc.view)
        currentViewCOntroller = vc
    }
    @objc func ChangeDisplay(noti:Notification){
        print("Change:\(noti.object as! Int)")
        currentViewCOntroller?.view.removeFromSuperview()
        currentViewCOntroller?.removeFromParentViewController()
        ChangeDisplayViewLoad(index: noti.object as! Int)
    }
    func CheckCollection(index:Int) ->UIViewController {
        if(index == 0){
            return WallpapersControlller!
        }else{
            return LiveWallpapersController!
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func abtn_CreateLive(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeMovie as String]
        present(picker, animated: true, completion: nil)
    }
    @IBAction func abtn_TakePhotoWallpaper(_ sender: Any) {
    }
    @objc func chup(_ notification: Notification){
        guard let data = notification.userInfo as? [String: Any] else{
            return
        }
        guard let index = data["index"] as? Int else{
            return
        }
        if #available(iOS 10.0, *) {
            let vc:CameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "showCamera") as! CameraViewController
            vc.kindOf = index
            navigationController?.pushViewController(vc, animated: true)
        } else {
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewCOntroller = currentViewCOntroller {
            currentViewCOntroller.viewWillDisappear(animated)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = false
        self.btn_expand.transform = CGAffineTransform.identity
        self.btn_expand_state = 0
        FadedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TapFadedView(_:))))
        NotificationCenter.default.post(name: .LibaryWallpaper, object: nil)
        btn_CreateLive.set(image: #imageLiteral(resourceName: "iconCreateLiveWallpapers") , title: "Create Live Wallpapers     ", titlePosition: .left, additionalSpacing: 8, state: .normal)
        btn_CreateWall.set(image: #imageLiteral(resourceName: "iconCreateWallpapers"), title: "Create Wallpapers     ", titlePosition: .left, additionalSpacing: 8, state: .normal)
        btn_CreateLive.alpha = 0
        btn_CreateWall.alpha  = 0
        FadedView.alpha  = 0
    }
}
