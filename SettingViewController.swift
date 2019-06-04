import UIKit
import MessageUI
import StoreKit
class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var btnRateApp: UIButton!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBOutlet weak var btnRestorePurchase: UIButton!
    @IBOutlet weak var btnPoli: UIButton!
    @available(iOS 10.0, *)
    func clearAllFile() {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print("Directory: \(paths)")
        do
        {
            let fileName = try fileManager.contentsOfDirectory(atPath: paths)
            for file in fileName {
                let filePath = URL(fileURLWithPath: paths).appendingPathComponent(file).absoluteURL
                try fileManager.removeItem(at: filePath)
                TakePhotoCoreData.share.deleteAllData()
                LivePhoToCoreData.share.deleteAllData()
                LivePhoToMyCoreData.share.deleteAllData()
                if #available(iOS 9.1, *) {
                    livePhotoTemp.removeAll()
                    livePhotoMyTemp.removeAll()
                    let ac = UIAlertController(title: "Cleared!", message: "The Cache is Cleared!!!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                } else {
                }
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    @IBAction func abtnRateApp(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlAppGuide, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urlAppGuide)
        }
        UserDefaults.standard.set(4, forKey: "Ran")
        UserDefaults.standard.set(10, forKey: "Show")
    }
    @IBAction func abtnFeedBack(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail(){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([mail])
            composeVC.setSubject("Wallpaper Feedback")
            composeVC.setMessageBody("Hey Bro! Here's my feedback.", isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Warring", message: "Mail services are not available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func abtnPoli(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: linkPoli)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: linkPoli)!)
        }
    }
    @IBAction func abtnRestorePurchase(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            self.clearAllFile()
        } else {
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.abtnFeedBackELDWallpapers("self")
        if #available(iOS 10.0, *) {
            self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1.0)
        } else {
        }
        self.abtnPoliAjUWallpapers("abtnCLick")
    }
    func setUpUI(){
        btnRateApp.set(image: #imageLiteral(resourceName: "iconRateOn"), title: "Rate our app", titlePosition: .T, additionalSpacing: 50, state: .normal)
        btnFeedBack.set(image: #imageLiteral(resourceName: "iconFeedback"), title: "Feedback", titlePosition: .right, additionalSpacing: 50, state: .normal)
        btnRestorePurchase.set(image: #imageLiteral(resourceName: "btnClear"), title: "Clear cache", titlePosition: .right, additionalSpacing: 50, state: .normal)
        btnPoli.set(image: #imageLiteral(resourceName: "privacy"), title: "Privacy Policy", titlePosition: .right, additionalSpacing: 50, state: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SettingViewController{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
