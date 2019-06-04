import UIKit
import NVActivityIndicatorView
import Photos
import PhotosUI
class LoadingViewController: UIViewController {
    let cellWidth:CGFloat = 200
    let cellHeight:CGFloat = 200
    var timer:Timer!
    var time:Double = 0
    var finish = false
    var TimerLoading:Timer!
    var activityIndicatorView:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animationLoadinghRhoNWallpapers("viewDIdIN")
        if UserDefaults.standard.integer(forKey: "noti") == 0{
            UserDefaults.standard.set(1, forKey: "noti")
            UserDefaults.standard.synchronize()
            setLNotification()
        }
        self.loadingData()
        self.TimerLoading = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkData), userInfo: nil, repeats: true)
         self.setUpLivePhoto()
        let x = self.view.frame.size.width/2 - self.cellWidth/2
        let y = self.view.frame.size.height/2 - self.cellHeight/2
        let frameAc = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        activityIndicatorView = NVActivityIndicatorView(frame: frameAc,
                                                        type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.orbit.rawValue)!)
        self.checkDataUTZbTWallpapers("wallPageIn")
        activityIndicatorView.color = UIColor.white
        activityIndicatorView.startAnimating()
        self.view.addSubview(activityIndicatorView)
        if #available(iOS 10.0, *) {
            self.view.setGradients(color_01: UIColor(displayP3Red: 51/255, green: 50/255, blue: 55/255, alpha: 1.0), color_02: UIColor(displayP3Red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0))
        } else {
        }
        self.preparejSfWallpapers("se")
    }
    func setLNotification(){
        ABNScheduler.cancelAllNotifications()
        var dateValue: Date?
        let repeatingValue = Repeats.Daily
        var co = DateComponents()
        co.year = 2017
        co.day = 25
        co.month = 08
        co.hour = 08
        co.minute = 00
        co.second = 00
        let calendar = Calendar.current
        dateValue = calendar.date(from: co)
        let note = ABNotification(alertBody: "This app has added new Wallpaper and Live Wallpaper.Please go watch anh save them all!!!")
        note.alertAction = "New Hottt!!!"
        note.repeatInterval = repeatingValue
        let _ = note.schedule(fireDate: dateValue!)
    }
    func getTodayString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let currentDateStr = formatter.string(from: Date())
        return currentDateStr
    }
    func loadingData(){
        getJson_VideoSize.sharedInstance.fetchFeedForUrlString()
        getJson_HomeImage.sharedInstance.fetchFeedForUrlString()
        getJson_LiveHomeImage.sharedInstance.fetchFeedForUrlString()
        getJson_CategoriesIcon.sharedInstance.fetchFeedForUrlString()
        getJson_Popular_Horizal.sharedInstance.fetchFeedForUrlString()
        getJson_NewArrival_Horizal.sharedInstance.fetchFeedForUrlString()
        getJson_CategoriesSeeAll.sharedInstance.fetchFeedForUrlString()
        getJson_NewArrival_SeeAll.sharedInstance.fetchFeedForUrlString()
        getJson_Popular.sharedInstance.fetchFeedForUrlString()
        getJson_LiveCategories.sharedInstance.fetchFeedForUrlString()
        getJson_Cate_NewArrivals_Live.sharedInstance.fetchFeedForUrlString()
        getJson_Cate_Popular_Live.sharedInstance.fetchFeedForUrlString()
        getJson_ImgaeLivePhoto.sharedInstance.fetchFeedForUrlString()
    }
    @objc func checkData(){
        if VideoSize.count != 0 && PhotoList.count != 0 && LivePhotoList.count != 0 && PhotoIcon.count != 0 && Popular_Horizal_List.count != 0 && NewArrival_Horizal_List.count != 0 && photoCateSeeAll != nil && NewArrival_SeeAll_List.count != 0 && Popular_SeeAll_List.count != 0 && liveCateSeeAll != nil && NewArrival_Live_List.count != 0 && Popular_Live_List.count != 0 && imageLivePhoto.count != 0{
            TimerLoading.invalidate()
            TimerLoading = nil
            self.timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(animationLoading), userInfo: nil, repeats: false)
        }
    }
    func setUpLivePhoto(){
        time = Double(LivePhoToCoreData.share.getAllData().count)*0.01
        for live in LivePhoToCoreData.share.getAllData(){
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if #available(iOS 9.1, *) {
                let livePT:PHLivePhotoView = PHLivePhotoView()
                PHLivePhoto.request(withResourceFileURLs: [ urls[0].appendingPathComponent(live.linkDataMOV!), urls[0].appendingPathComponent(live.linkDataIMG!)],
                                    placeholderImage: nil,
                                    targetSize: self.view.bounds.size,
                                    contentMode: PHImageContentMode.aspectFit,
                                    resultHandler: { (livePhoto, info) -> Void in
                                        livePT.livePhoto = livePhoto
                })
                livePhotoTemp[live.id!] = livePT
            } else {
            }
        }
        for live in LivePhoToMyCoreData.share.getAllData(){
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if #available(iOS 9.1, *) {
                let livePT:PHLivePhotoView = PHLivePhotoView()
                PHLivePhoto.request(withResourceFileURLs: [ urls[0].appendingPathComponent(live.linkDataMOV!), urls[0].appendingPathComponent(live.linkDataIMG!)],
                                    placeholderImage: nil,
                                    targetSize: self.view.bounds.size,
                                    contentMode: PHImageContentMode.aspectFit,
                                    resultHandler: { (livePhoto, info) -> Void in
                                        livePT.livePhoto = livePhoto
                })
                livePhotoMyTemp["LiveMy\(live.id!)"] = livePT
            } else {
            }
        }
    }
    @objc func animationLoading(){
        self.activityIndicatorView.stopAnimating()
        let Tabbar = self.storyboard?.instantiateViewController(withIdentifier: "TabbarCustom") as! TabbarCustom
        self.navigationController?.pushViewController(Tabbar, animated: false)
        self.timer.invalidate()
        self.timer = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
