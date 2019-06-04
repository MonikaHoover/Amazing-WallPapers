import UIKit
import AVFoundation
class Click_Live_PhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var Coll_ClickLive: UICollectionView!
    @IBAction func abtn_back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    lazy var downloadPhotoQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    var downloadingTasks = Dictionary<IndexPath,Operation>()
    let photoCache:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    var btnDownload:UIButton = {
        let btnDownload = UIButton()
        btnDownload.setImage( #imageLiteral(resourceName: "saveBtn"), for: .normal)
        btnDownload.addTarget(self, action: #selector(btnDownload(_:)), for: .touchUpInside)
        return btnDownload
    }()
    @objc func btnDownload(_ sender: UIButton!) {
        if #available(iOS 9.1, *) {
            guard let cell = (Coll_ClickLive.visibleCells.first as? Click_LivePhotoCollectionViewCell) else {
                return
            }
            if cell.filePath != ""{
                self.S()
            }
        }
    }
    @objc func S(){
        if #available(iOS 9.1, *) {
            guard let cell = (Coll_ClickLive.visibleCells.first as? Click_LivePhotoCollectionViewCell) else {
                return
            }
            cell.exportLivePhoto()
        } else {
        }
    }
    @objc func SaveSC(){
        let ac = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(S), name: .SLClick, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloaddata), name: .LiveCate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadprogress(_:)), name: .CSeeallLoadpercent_livewallpaperHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(initLive), name: .CSeeallinitLive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SaveSC), name: .CSaveSCClick, object: nil)
        view.addSubview(btnDownload)
        btnDownload.frame = CGRect(x: (view.frame.size.width/2)-50.5, y: view.frame.size.height-93
            , width: 101, height: 48)
    }
    @objc func loadprogress(_ notification: Notification){
        DispatchQueue.main.async {
            guard let data = notification.userInfo as? [String: Any] else{
                return
            }
            guard let index = data["index"] as? Int else{
                return
            }
            guard let precent = data["precent"] as? CGFloat else{
                return
            }
            if index == self.Coll_ClickLive.indexPath(for: self.Coll_ClickLive.visibleCells.first!)?.row{
                if #available(iOS 9.1, *) {
                    let cell = (self.Coll_ClickLive.visibleCells.first) as! Click_LivePhotoCollectionViewCell
                    cell.shapeLayer.isHidden = false
                    cell.pulsatingLayer.isHidden = false
                    cell.trackLayer.isHidden = false
                    cell.percentageLabel.isHidden = false
                    cell.percentageLabel.text = "\(Int(precent * 100))% "
                    cell.shapeLayer.strokeEnd = precent
                    if precent >= 0.99{
                        UIView.animate(withDuration: 1) {
                            cell.percentageLabel.text = "99% "
                            cell.shapeLayer.strokeEnd = 0.99
                        }
                    }
                    else{
                        UIView.animate(withDuration: 1) {
                            cell.percentageLabel.isHidden = false
                        }
                    }
                } else {
                }
            }
        }
    }
    @objc func initLive(_ notification: Notification){
        guard let data = notification.userInfo as? [String: Any] else{
            return
        }
        guard let index = data["index"] as? Int else{
            return
        }
        if #available(iOS 9.1, *) {
            let cell = (self.Coll_ClickLive.visibleCells.first) as! Click_LivePhotoCollectionViewCell
            if index == self.Coll_ClickLive.indexPath(for: self.Coll_ClickLive.visibleCells.first!)?.row{
                if let label = cell.contentView.viewWithTag(10) as? UILabel{
                    label.removeFromSuperview()
                }
                if let sublayers = cell.contentView.layer.sublayers{
                    for sublayer in sublayers{
                        if sublayer.name == "shapeLayer" || sublayer.name == "pulsatingLayer" || sublayer.name == "trackLayer"{
                            sublayer.removeFromSuperlayer()
                        }
                    }
                }
                cell.contentView.bringSubview(toFront: cell.Click_live)
                cell.Live_Photo.isHidden = true
                if cell.Click_live.livePhoto == nil{
                    let userPhoto = PhotoLiveCategories[index]
                    let keyCache = "LivePH-\(userPhoto.id)"
                    for live in livePhotoTemp{
                        if keyCache == live.key{
                            cell.Click_live.livePhoto = live.value.livePhoto
                            cell.Click_live.isMuted = true
                            break
                        }
                    }
                }
                cell.loadingMainView.isHidden = true
                cell.reloadInputViews()
                cell.Click_live.startPlayback(with: .full)
            }
        } else {
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        disconected()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoLiveCategories.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            self.disconected()
        }
    }
    func disconected(){
        for download in downloadingTasks{
            if (download.value as! DownloadVideoOperation).downloadtask?.state == .running{
                (download.value as! DownloadVideoOperation).downloadtask?.cancel()
                (download.value as! DownloadVideoOperation).downloadtask?.suspend()
            }
        }
        downloadPhotoQueue.cancelAllOperations()
        downloadingTasks.removeAll()
        }
    var onceOnly = false
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            let indexToScrollTo = temp
            self.Coll_ClickLive.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if #available(iOS 9.1, *) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Coll_LivePhoto", for: indexPath) as! Click_LivePhotoCollectionViewCell
            let userPhoto = PhotoLiveCategories[indexPath.row]
            let keyCache = userPhoto.id
            let documentsURL = FileManager.default
            let manager = documentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
            let filePaths = manager.appendingPathComponent("\(keyCache).mov")
            let fileTemp = manager.appendingPathComponent("live-\(keyCache).jpg")
            cell.loadingMainView.isHidden = true
            cell.imageLoading.isHidden = true
            cell.Live_Photo.isHidden = true
            if documentsURL.fileExists(atPath: filePaths.path)
            {
                if let label = cell.contentView.viewWithTag(10) as? UILabel{
                    label.removeFromSuperview()
                }
                if let sublayers = cell.contentView.layer.sublayers{
                    for sublayer in sublayers{
                        if sublayer.name == "shapeLayer" || sublayer.name == "pulsatingLayer" || sublayer.name == "trackLayer"{
                            sublayer.removeFromSuperlayer()
                        }
                    }
                }
                cell.Live_Photo.isHidden = true
                cell.loadingMainView.isHidden = false
                cell.imageLoading.isHidden = false
                cell.imageLoading.image = self.generateThumbnail(url: filePaths)
                for live in livePhotoTemp{
                    if "LivePH-\(keyCache)" == live.key{
                        cell.loadingMainView.isHidden = true
                        if let label = cell.contentView.viewWithTag(10) as? UILabel{
                            label.removeFromSuperview()
                        }
                        if let sublayers = cell.contentView.layer.sublayers{
                            for sublayer in sublayers{
                                if sublayer.name == "shapeLayer" || sublayer.name == "pulsatingLayer" || sublayer.name == "trackLayer"{
                                    sublayer.removeFromSuperlayer()
                                }
                            }
                        }
                        cell.contentView.bringSubview(toFront: cell.Click_live)
                        cell.Live_Photo.isHidden = true
                        cell.Click_live.livePhoto = live.value.livePhoto
                        cell.Click_live.isMuted = true
                        cell.filePath = keyCache
                        if !collectionView.isDecelerating {
                            cell.Click_live.startPlayback(with: .full)
                        }
                        break
                    }
                }
            }else{
                if let downloadedVid = photoCache.object(forKey: keyCache as AnyObject) as? Data{
                    if let label = cell.contentView.viewWithTag(10) as? UILabel{
                        label.removeFromSuperview()
                    }
                    if let sublayers = cell.contentView.layer.sublayers{
                        for sublayer in sublayers{
                            if sublayer.name == "shapeLayer" || sublayer.name == "pulsatingLayer" || sublayer.name == "trackLayer"{
                                sublayer.removeFromSuperlayer()
                            }
                        }
                    }
                    let documents = FileManager.default
                    let manager = documents.urls(for: .documentDirectory, in: .allDomainsMask).first!
                    let fileURL = manager.appendingPathComponent("\(keyCache).mov")
                    do{
                        try downloadedVid.write(to: fileURL, options: .atomic)
                    }catch{
                        print(" Lỗi Lưu Video ")
                    }
                    cell.Live_Photo.isHidden = true
                    cell.loadingMainView.isHidden = false
                    cell.imageLoading.isHidden = false
                    cell.imageLoading.image = self.generateThumbnail(url: filePaths)
                    cell.loadVideoWithVideoURL(fileURL, imagedTemp: "LivePH-\(keyCache)", index: indexPath.row)
                }else{
                    cell.layoutIfNeeded()
                    if let label = cell.contentView.viewWithTag(10) as? UILabel{
                        label.removeFromSuperview()
                    }
                    if let sublayers = cell.contentView.layer.sublayers{
                        for sublayer in sublayers{
                            if sublayer.name == "shapeLayer" || sublayer.name == "pulsatingLayer" || sublayer.name == "trackLayer"{
                                sublayer.removeFromSuperlayer()
                            }
                        }
                    }
                    cell.setupCircleLayers()
                    cell.setupPercentageLabel()
                    cell.shapeLayer.isHidden = false
                    cell.pulsatingLayer.isHidden = false
                    cell.trackLayer.isHidden = false
                    cell.percentageLabel.isHidden = false
                    cell.Live_Photo.isHidden = false
                    if let image = UIImage(contentsOfFile: fileTemp.path) { cell.Live_Photo.image = image } else { cell.Live_Photo.image = #imageLiteral(resourceName: "catch")  }
                    cell.shapeLayer.strokeEnd = 0
                    cell.percentageLabel.text = "0%"
                    cell.Click_live.livePhoto = nil
                    cell.filePath = ""
                    if !collectionView.isDecelerating {
                        let id = IndexPath(item: indexPath.row, section: 0)
                        let downloadPhoto = DownloadVideoOperation(indexPath: id, videoURL: userPhoto.link, needPercent: 0, delegate: self as DownloadVideoOperationDelegate, key: keyCache)
                        startDownloadImage(operation: downloadPhoto, indexPath: id)
                    }
                }
            }
            cell.frame.origin.y = self.Coll_ClickLive.bounds.origin.y
             return cell
        } else {
            let cell = UICollectionViewCell()
            return cell;
        }   
    }
    func reloadVisibleCells() {
        UIView.setAnimationsEnabled(false)
        self.Coll_ClickLive.performBatchUpdates({
            let visibleCellIndexPaths = self.Coll_ClickLive.indexPathsForVisibleItems
            self.Coll_ClickLive.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.bounds.size.height
        if offsetY >= scrollView.contentSize.height {
        }
        reloadVisibleCells()
    }
    func startDownloadImage(operation:DownloadVideoOperation, indexPath: IndexPath) {
        if let _ = downloadingTasks[indexPath] {
            return
        }
        downloadingTasks[indexPath] = operation
        downloadPhotoQueue.addOperation(operation)
    }
    @objc func reloaddata(){
        Coll_ClickLive.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Coll_ClickLive.frame.size.width, height: Coll_ClickLive.frame.size.height)
    }
}
extension Click_Live_PhotoViewController: DownloadVideoOperationDelegate {
    func DownloadVideoDidFail(operation: DownloadVideoOperation) {
    }
    func DownloadVideoDidFinish(operation: DownloadVideoOperation, video: Data) {
        let userPhoto = PhotoLiveCategories[operation.indexPath.item]
        let keyCache = userPhoto.id
        self.photoCache.setObject(video as AnyObject, forKey: keyCache as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        self.Coll_ClickLive.reloadItems(at: [id])
        downloadingTasks.removeValue(forKey: operation.indexPath)
    }
}
extension Click_Live_PhotoViewController{
    func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: kCMTimeZero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
extension Click_Live_PhotoViewController{
    override func didReceiveMemoryWarning() {
    }
}
