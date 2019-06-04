import UIKit
import DKChainableAnimationKit
class TabbarCustom: UIViewController {
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var vBlurMenuActive: UIView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btncategories: UIButton!
    @IBOutlet weak var btnYourWallpaper: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    lazy var isActiveMenu:Bool = false
    @IBAction func abtnShare(_ sender: UIButton) {
        let textToShare = "Wallpaper"
        if let myWebsite = NSURL(string: linkApp) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    enum Screen:Int {
        case Home = 0
        case CategogiesView = 1
        case YourWallpapers = 2
        case Setting = 3
    }
    var buttonTemp:UIButton?
    lazy var Home:UIViewController? = {
        let homeController = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        return homeController
    }()
    lazy var CategogiesView:UINavigationController? = {
        let categogiesViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategogiesView") as? UINavigationController
        return categogiesViewController
    }()
    lazy var YourWallpapers:UINavigationController? = {
        let yourWallpapersController = self.storyboard?.instantiateViewController(withIdentifier: "YourWallpapers") as? UINavigationController
        return yourWallpapersController
    }()
    lazy var Setting:UIViewController? = {
        let settingController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
        return settingController
    }()
    var currentViewCOntroller:AnyObject?
    func ChangeDisplayViewLoad(index:Int){
        let vc = CheckCollection(index: index)
        if index == Screen.Home.rawValue{
            let vC = (vc as! UIViewController)
            vC.didMove(toParentViewController: self)
            self.addChildViewController(vC)
            vC.view.frame = self.view.bounds
            self.view.addSubview(vC.view)
            currentViewCOntroller = vC
        }else if index == Screen.Setting.rawValue{
            let vC = (vc as! UIViewController)
            vC.didMove(toParentViewController: self)
            self.addChildViewController(vC)
            vC.view.frame = self.view.bounds
            self.view.addSubview(vC.view)
            currentViewCOntroller = vC
        }else{
            let vC = (vc as! UINavigationController)
            vC.didMove(toParentViewController: self)
            self.addChildViewController(vC)
            vC.view.frame = self.view.bounds
            self.view.addSubview(vC.view)
            currentViewCOntroller = vC
        }
    }
    func changeTag(index:Int){
        currentViewCOntroller?.removeFromParentViewController()
        ChangeDisplayViewLoad(index: index)
        self.bringAllToFont()
    }
    func CheckCollection(index:Int) ->AnyObject {
        if(index == Screen.Home.rawValue){
            return Home!
        }else if(index == Screen.CategogiesView.rawValue){
            return CategogiesView!
        }else if(index == Screen.YourWallpapers.rawValue){
            return YourWallpapers!
        }else if index == Screen.Setting.rawValue{
            return Setting!
        }
        return Home!
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(hideChup), name: .hideChup, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showChup), name: .showChup, object: nil)
        changeTag(index: Screen.CategogiesView.rawValue)
        self.setUpBeganUI()
    }
    func setUpBeganUI(){
        self.btnHome.isHidden = true
        self.btncategories.isHidden = true
        self.btnYourWallpaper.isHidden = true
        self.btnSetting.isHidden = true
        self.vBlurMenuActive.isHidden = true
        self.btnHome.alpha = 0.0
        self.btncategories.alpha = 0.0
        self.btnYourWallpaper.alpha = 0.0
        self.btnSetting.alpha = 0.0
        self.vBlurMenuActive.alpha = 0
        self.btnHome.tag = 1
        self.btncategories.tag = 2
        self.btnYourWallpaper.tag = 3
        self.btnSetting.tag = 4
        self.buttonTemp = self.btncategories
    }
    func bringAllToFont(){
        self.view.bringSubview(toFront: self.btnShare)
        self.view.bringSubview(toFront: self.vBlurMenuActive)
        self.view.bringSubview(toFront: self.btnHome)
        self.view.bringSubview(toFront: self.btncategories)
        self.view.bringSubview(toFront: self.btnYourWallpaper)
        self.view.bringSubview(toFront: self.btnSetting)
        self.view.bringSubview(toFront: self.btnMenu)
    }
    private var isMenuEnable:Bool = true
    @IBAction func abtnMenu(_ sender: UIButton) {
        if self.isMenuEnable{
            if !self.isActiveMenu{
                self.vBlurMenuActive.isHidden = false
                self.vBlurMenuActive.animation.makeOpacity(0.7).animate(0.2)
                self.btnMenu.animation.rotate(45).spring.bounce.animate(0.5)
                self.animationActiveMenu()
            }else{
                self.vBlurMenuActive.animation.makeOpacity(0.0).animate(0.2).animationCompletion = {
                    self.vBlurMenuActive.isHidden = true
                }
                self.btnMenu.animation.rotate(-45).spring.bounce.animate(0.5)
                self.animationInactiveMenu()
            }
            self.isActiveMenu = !self.isActiveMenu
        }
        self.isMenuEnable = false
    }
    @IBAction func abtnHome(_ sender: UIButton) {
        if currentViewCOntroller as? UIViewController != Home{
            self.changeTag(index: Screen.Home.rawValue)
            self.buttonTemp?.setImage(UIImage(named: "tabbar_\(String(describing: self.buttonTemp!.tag))_off"), for: .normal)
            self.btnHome.setImage(UIImage(named: "tabbar_\(String(describing: 1))_on"), for: .normal)
            self.buttonTemp = self.btnHome
        }
        OffHome()
    }
    @IBAction func abtncategories(_ sender: UIButton) {
        if currentViewCOntroller as? UINavigationController != CategogiesView{
            self.changeTag(index: Screen.CategogiesView.rawValue)
            self.buttonTemp?.setImage(UIImage(named: "tabbar_\(String(describing: self.buttonTemp!.tag))_off"), for: .normal)
            self.btncategories.setImage(UIImage(named: "tabbar_\(String(describing: 2))_on"), for: .normal)
            self.buttonTemp = self.btncategories
        }
        Off()
    }
    @IBAction func abtnyourWallpaper(_ sender: UIButton) {
        if currentViewCOntroller as? UINavigationController != YourWallpapers{
            self.changeTag(index: Screen.YourWallpapers.rawValue)
            self.buttonTemp?.setImage(UIImage(named: "tabbar_\(String(describing: self.buttonTemp!.tag))_off"), for: .normal)
            self.btnYourWallpaper.setImage(UIImage(named: "tabbar_\(String(describing: 3))_on"), for: .normal)
            self.buttonTemp = self.btnYourWallpaper
        }
        Off()
    }
    func Off(){
        self.vBlurMenuActive.animation.makeOpacity(0.0).animate(0.2).animationCompletion = {
            self.vBlurMenuActive.isHidden = true
        }
        self.btnMenu.animation.rotate(-45).spring.bounce.animate(0.5).animationCompletion = {
            self.btnMenu.setImage(#imageLiteral(resourceName: "closeBtn"), for: .normal)
        }
        self.animationInactiveMenu()
        self.isActiveMenu = !self.isActiveMenu
    }
    func OffHome(){
        self.vBlurMenuActive.animation.makeOpacity(0.0).animate(0.2).animationCompletion = {
            self.vBlurMenuActive.isHidden = true
        }
        self.btnMenu.animation.rotate(-45).spring.bounce.animate(0.5).animationCompletion = {
            self.btnMenu.setImage(#imageLiteral(resourceName: "closeBtn"), for: .normal)
        }
        self.animationInactiveMenu()
        self.isActiveMenu = !self.isActiveMenu
    }
    @IBAction func abtnSetting(_ sender: UIButton) {
        if currentViewCOntroller as? UIViewController != Setting{
            self.changeTag(index: Screen.Setting.rawValue)
            self.buttonTemp?.setImage(UIImage(named: "tabbar_\(String(describing: self.buttonTemp!.tag))_off"), for: .normal)
            self.btnSetting.setImage(UIImage(named: "tabbar_\(String(describing: 4))_on"), for: .normal)
            self.buttonTemp = self.btnSetting
        }
        Off()
    }
    func animationActiveMenu(){
        self.btnHome.isHidden = false
        self.btncategories.isHidden = false
        self.btnYourWallpaper.isHidden = false
        self.btnSetting.isHidden = false
        self.btnSetting.animation.moveY(-208).makeOpacity(1.0).animate(0.4).animationCompletion = {
                self.isMenuEnable = true
        }
        self.btnYourWallpaper.animation.moveY(-156).makeOpacity(1.0).animate(0.3)
        self.btncategories.animation.moveY(-104).makeOpacity(1.0).animate(0.2)
        self.btnHome.animation.moveY(-52).makeOpacity(1.0).animate(0.1)
    }
    func animationInactiveMenu(){
        self.btnSetting.animation.moveY(208).makeOpacity(0.0).animate(0.4).animationCompletion = {
            self.btnSetting.isHidden = true
                self.isMenuEnable = true
        }
        self.btnYourWallpaper.animation.moveY(156).makeOpacity(0.0).animate(0.3).animationCompletion = {
            self.btnYourWallpaper.isHidden = true
        }
        self.btncategories.animation.moveY(104).makeOpacity(0.0).animate(0.2).animationCompletion = {
            self.btncategories.isHidden = true
        }
        self.btnHome.animation.moveY(52).makeOpacity(0.0).animate(0.1).animationCompletion = {
             self.btnHome.isHidden = true
        }
    }
    @objc func hideChup(){
        self.btnMenu.isHidden = true
        self.btnShare.isHidden = true
    }
    @objc func showChup(){
        self.btnMenu.isHidden = false
        self.btnShare.isHidden = false
    }
    @IBAction func OffTap(_ sender: UITapGestureRecognizer) {
        if currentViewCOntroller as? UIViewController != Home{
            self.OffHome()
        }else{
            self.Off()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewCOntroller = currentViewCOntroller {
            currentViewCOntroller.viewWillDisappear(animated)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
