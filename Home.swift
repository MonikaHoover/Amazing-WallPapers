import UIKit
class Home: UIViewController {
    @IBOutlet weak var View_Home: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    lazy var WallpaperControlller:UIViewController? = {
        let wallpapersController = self.storyboard?.instantiateViewController(withIdentifier: "Wallpapers_Home")
        return wallpapersController
    }()
    lazy var LiveWallpapersController:UIViewController? = {
        let wallpapersController = self.storyboard?.instantiateViewController(withIdentifier: "LiveWallpapers_Home")
        return wallpapersController
    }()
    var currentViewCOntroller:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeDisplay), name: Notification.Name("ChangeDislay") , object: nil)
       ChangeDisplayViewLoad(index: 0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewCOntroller = currentViewCOntroller {
            currentViewCOntroller.viewWillDisappear(animated)
        }
    }
    private var changeTag:Int = 0
    func ChangeDisplayViewLoad(index:Int){
        let vc = CheckCollection(index: index)
        vc.didMove(toParentViewController: self)
        self.addChildViewController(vc)
        vc.view.frame = self.View_Home.bounds
        View_Home.addSubview(vc.view)
        currentViewCOntroller = vc
    }
    @objc func ChangeDisplay(noti:Notification){
        print("Change:\(noti.object as! Int)")
        self.changeTag = noti.object as! Int
        currentViewCOntroller?.view.removeFromSuperview()
        currentViewCOntroller?.removeFromParentViewController()
        ChangeDisplayViewLoad(index: noti.object as! Int)
    }
    func CheckCollection(index:Int) ->UIViewController {
        if(index == 0){
            return WallpaperControlller!
        }else{
            return LiveWallpapersController!
        }
    }
}
