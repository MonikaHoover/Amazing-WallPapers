import UIKit
var temp:IndexPath = IndexPath()
class Wallpapers_SeeAll: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var coll_Categories_seeall: UICollectionView!
    lazy var downloadPhotoQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 16
        return queue
    }()
    var downloadingTasks = Dictionary<IndexPath,Operation>()
    let photoCache:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategories), name: .CategoriesDownload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadprogress(_:)), name: .SeeallLoadpercent_wallpaperHome, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        GetDataPhotoSeeAll.sharedInstance.get()
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
            for cellVisible in self.coll_Categories_seeall.visibleCells{
                if index == self.coll_Categories_seeall.indexPath(for: cellVisible)?.row{
                    let cell = (self.coll_Categories_seeall.cellForItem(at: IndexPath(item: index, section: 0))) as! CollViewCell1
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return PhotoCategoriesSeeAll.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Wallpapers_Cell", for: indexPath) as! CollViewCell1
        let userPhoto = PhotoCategoriesSeeAll[indexPath.row]
        let keyCache = userPhoto.id
      let DocumentsURL = FileManager.default
        let Manager = DocumentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
        let filePath = Manager.appendingPathComponent("\(keyCache).jpg")
        cell.shapeLayer.strokeEnd = 0
        cell.shapeLayer.isHidden = true
        cell.pulsatingLayer.isHidden = true
        cell.trackLayer.isHidden = true
        cell.percentageLabel.isHidden = true
        cell.needReload = false
        if UIImage(contentsOfFile: filePath.path) != nil{
            cell.contentView.bringSubview(toFront: cell.LivePhotoCate)
            cell.LivePhotoCate.image = UIImage(contentsOfFile: filePath.path)!
            cell.needReload = true
        }else{
            if let downloadedIMG = photoCache.object(forKey: keyCache as AnyObject) as? UIImage{
                cell.contentView.bringSubview(toFront: cell.LivePhotoCate)
                cell.LivePhotoCate.image = downloadedIMG
                if let data = UIImageJPEGRepresentation(cell.LivePhotoCate.image!, 1.0)
                {
                    do {
                        try data.write(to: filePath )
                        print("file saved")
                    } catch {
                        print("error saving file:", error)
                    }
                }
            }else {
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
                if !collectionView.isDecelerating {
                    let id = IndexPath(item: indexPath.row, section: 0)
                    let downloadPhoto = DownloadPhotoOperation(indexPath: id, photoURL: userPhoto.link, needPercent: 0, delegate: self as DownloadPhotoOperationDelegate)
                    startDownloadImage(operation: downloadPhoto, indexPath: id)
                }
            }
        }
        return  cell
    }
    @objc func reloadCategories(){
    coll_Categories_seeall.reloadData()
}
    func reloadVisibleCells() {
        let visibleCellIndexPaths = self.coll_Categories_seeall.indexPathsForVisibleItems
        for visibel in visibleCellIndexPaths{
            if let cell = self.coll_Categories_seeall.cellForItem(at: visibel) as? CollViewCell1{ 
                if !cell.needReload{
                    UIView.setAnimationsEnabled(false)
                    self.coll_Categories_seeall.performBatchUpdates({
                        let visiconvert = [visibel]
                        self.coll_Categories_seeall.reloadItems(at: visiconvert)
                    }) { (finished) in
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    temp = indexPath
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width >= 768{
            return CGSize(width: WIPA(w: 250), height: HIPA(h: 398))
        }else{
            return CGSize(width: WIPH(w: 120), height: HIPH(h: 196))
        }
    }
}
extension Wallpapers_SeeAll: DownloadPhotoOperationDelegate {
    func downloadPhotoDidFail(operation: DownloadPhotoOperation) {
    }
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation, image:UIImage) {
        let userPhoto = PhotoCategoriesSeeAll[operation.indexPath.item]
        let keyCache = userPhoto.id
        self.photoCache.setObject(image, forKey: keyCache as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        self.coll_Categories_seeall.reloadItems(at: [id])
        downloadingTasks.removeValue(forKey: operation.indexPath)
    }
}
