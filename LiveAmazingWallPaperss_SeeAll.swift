import UIKit
import AVFoundation
class LiveWallpapers_SeeAll: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var liveWallpaers_SeeAllEnter:Int?
    @IBOutlet weak var Coll_LiveCate: UICollectionView!
    lazy var downloadPhotoQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    var downloadingTasks = Dictionary<IndexPath,Operation>()
    let photoCacheLivePhotoSeeAll:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoLiveCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveWallpapers_Cell", for: indexPath) as! CollViewCell1
        let userPhoto = imageLivePhoto[self.convertLiveToPhoto(indexCurrent: indexPath.row)]
        let keyCache = userPhoto.id
        let documentsURL = FileManager.default
        let manager = documentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
        let filePath = manager.appendingPathComponent("live-\(keyCache).jpg")
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
        cell.percentageLabel.isHidden = true
        if UIImage(contentsOfFile: filePath.path) != nil
        {
            cell.bringSubview(toFront: cell.LivePhotoCate)
            cell.LivePhotoCate.image = UIImage(contentsOfFile: filePath.path)!
        }else{
            if let downloadedVid = photoCacheLivePhotoSeeAll.object(forKey: keyCache as AnyObject) as? UIImage{
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
                cell.LivePhotoCate.image = downloadedVid
                if let data = UIImageJPEGRepresentation(cell.LivePhotoCate.image!, 1.0)
                {
                    do {
                        try data.write(to: filePath)
                        print("file saved")
                    } catch {
                        print("error saving file:", error)
                    }
                }
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
                cell.LivePhotoCate.image =  #imageLiteral(resourceName: "catePN")
                cell.filePath = ""
                if !collectionView.isDecelerating {
                    let id = IndexPath(item: indexPath.row, section: 0)
                    let downloadPhoto = DownloadPhotoOperation(indexPath: id, photoURL: userPhoto.link, needPercent: 4, delegate: self as DownloadPhotoOperationDelegate)
                    startDownloadImage(operation: downloadPhoto, indexPath: id)
                }
            }
        }
        return  cell
    }
    func Fail(){
        let ac = UIAlertController(title: "Warring!", message: "The livephoto loading! Please wait!!.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadprogress(_:)), name: .SeeallLoadpercent_livewallpaperHome, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        GetDataLive.sharedInstance.get()
        Coll_LiveCate.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        disconected()
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
            for cellVisible in self.Coll_LiveCate.visibleCells{
                if index == self.Coll_LiveCate.indexPath(for: cellVisible)?.row{
                    let cell = (self.Coll_LiveCate.cellForItem(at: IndexPath(item: index, section: 0))) as! CollViewCell1
                    cell.shapeLayer.isHidden = false
                    cell.pulsatingLayer.isHidden = false
                    cell.trackLayer.isHidden = false
                    cell.percentageLabel.isHidden = false
                    cell.percentageLabel.text = "\(Int(precent * 100))% "
                    cell.shapeLayer.strokeEnd = precent
                    if precent > 0 && precent < 0.99{
                        cell.shapeLayer.isHidden = false
                        cell.pulsatingLayer.isHidden = false
                        cell.trackLayer.isHidden = false
                        cell.percentageLabel.isHidden = false
                        cell.LivePhotoCate.isHidden = false
                    }else if precent >= 0.99{
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
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width >= 768{
            return CGSize(width: WIPA(w: 184), height: HIPA(h: 212))
        }else{
            return CGSize(width: WIPH(w: 120), height: HIPH(h: 196))
        }
    }
    func reloadVisibleCells() {
        UIView.setAnimationsEnabled(false)
        self.Coll_LiveCate.performBatchUpdates({
            let visibleCellIndexPaths = self.Coll_LiveCate.indexPathsForVisibleItems
            self.Coll_LiveCate.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadVisibleCells()
    }
    func startDownloadImage(operation:DownloadPhotoOperation, indexPath: IndexPath) {
        if let _ = downloadingTasks[indexPath] {
            return
        }
        downloadingTasks[indexPath] = operation
        downloadPhotoQueue.addOperation(operation)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            self.disconected()
        }
    }
    func disconected(){
        for download in downloadingTasks{
            if (download.value as! DownloadPhotoOperation).downloadtask?.state == .running{
                (download.value as! DownloadPhotoOperation).downloadtask?.cancel()
            }
        }
        downloadPhotoQueue.cancelAllOperations()
        downloadingTasks.removeAll()
    }
    @objc func reloadLive(){
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        temp = indexPath
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Click_Live_PhotoViewController = storyBoard.instantiateViewController(withIdentifier: "Click_Live_PhotoViewController") as! Click_Live_PhotoViewController
        self.present(Click_Live_PhotoViewController, animated: true, completion: nil)
    }
}
extension LiveWallpapers_SeeAll: DownloadPhotoOperationDelegate {
    func downloadPhotoDidFail(operation: DownloadPhotoOperation) {
    }
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation, image:UIImage){
        let userPhoto = imageLivePhoto[self.convertLiveToPhoto(indexCurrent: operation.indexPath.row)]
        let keyCache = userPhoto.id
        self.photoCacheLivePhotoSeeAll.setObject(image, forKey: keyCache as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        self.Coll_LiveCate.reloadItems(at: [id])
        downloadingTasks.removeValue(forKey: operation.indexPath)
    }
}
extension LiveWallpapers_SeeAll{
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
    func convertLiveToPhoto(indexCurrent:Int)->Int{
        for image in 0..<imageLivePhoto.count{
            if PhotoLiveCategories[indexCurrent].id == imageLivePhoto[image].id{
                return image
            }
        }
        return -1
    }
}
