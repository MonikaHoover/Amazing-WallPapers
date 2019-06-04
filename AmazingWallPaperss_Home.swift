import UIKit
import CoreData
class Wallpapers_Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    lazy var downloadPhotoQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    var downloadingTasks = Dictionary<IndexPath,Operation>()
    let photoCache:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    @IBOutlet weak var CollView_WallHome: UICollectionView!
    @objc func btnDownload(_ sender: UIButton!) {
        guard let cell = (CollView_WallHome.visibleCells.first as? CollViewCell_Home) else {
            return
        }
        if cell.downloaded{
            self.S()
        }
    }
    @objc func S(){
        UIImageWriteToSavedPhotosAlbum((CollView_WallHome.visibleCells.first as! CollViewCell_Home).Img_Home.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    var btnDownload:UIButton = {
        let btnDownload = UIButton()
        btnDownload.setImage( #imageLiteral(resourceName: "saveBtn"), for: .normal)
        btnDownload.addTarget(self, action: #selector(btnDownload(_:)), for: .touchUpInside)
        return btnDownload
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnDownloadDnagqWallpapers("drag", nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadprogress(_:)), name: .Loadpercent_wallpaperHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(S), name: .SWHome, object: nil)
        self.disconectedHrHtWallpapers("but")
        view.addSubview(btnDownload)
        btnDownload.frame = CGRect(x: (view.frame.size.width/2)-50.5, y: view.frame.size.height-HIPH(h: 93)
            , width: 101, height: 48)
        self.view.backgroundColor = UIColor.rgb(r: 70, g: 70, b: 70)
    }
    override func viewWillAppear(_ animated: Bool) {
        CollView_WallHome.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.disconected()
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
            if index == self.CollView_WallHome.indexPath(for: self.CollView_WallHome.visibleCells.first!)?.row{
                let cell = (self.CollView_WallHome.visibleCells.first) as! CollViewCell_Home
                cell.shapeLayer.isHidden = false
                cell.pulsatingLayer.isHidden = false
                cell.trackLayer.isHidden = false
               cell.percentageLabel.isHidden = false
                cell.percentageLabel.text = "\(Int(precent * 100))% "
                cell.shapeLayer.strokeEnd = precent
                if precent == 1{
                    UIView.animate(withDuration: 1) {
                        cell.percentageLabel.isHidden = true
                        cell.shapeLayer.strokeEnd = 0
                        cell.shapeLayer.isHidden = true
                        cell.pulsatingLayer.isHidden = true
                        cell.trackLayer.isHidden = false
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userPhoto = PhotoList[indexPath.row]
        let keyCache = userPhoto.id
        let DocumentsURL = FileManager.default
        let Manager = DocumentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
        let filePath = Manager.appendingPathComponent("\(keyCache).jpg")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_WallpapersHome", for: indexPath) as! CollViewCell_Home
        cell.shapeLayer.strokeEnd = 0
        cell.shapeLayer.isHidden = true
        cell.pulsatingLayer.isHidden = true
        cell.trackLayer.isHidden = true
        cell.percentageLabel.isHidden = true
        if UIImage(contentsOfFile: filePath.path) != nil{
            cell.contentView.bringSubview(toFront: cell.Img_Home)
            cell.Img_Home.image = UIImage(contentsOfFile: filePath.path)!
            cell.downloaded = true
        }else{
            if let downloadedIMG = photoCache.object(forKey: keyCache as AnyObject) as? UIImage{
                 cell.contentView.bringSubview(toFront: cell.Img_Home)
                cell.Img_Home.image = downloadedIMG
                cell.downloaded = true
                if let data = UIImageJPEGRepresentation(cell.Img_Home.image!, 1.0)
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
                cell.downloaded = false
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
                cell.Img_Home.image =  #imageLiteral(resourceName: "catch")
                cell.shapeLayer.strokeEnd = 0
                cell.percentageLabel.text = "0%"
                if !collectionView.isDecelerating {
                    let id = IndexPath(item: indexPath.row, section: 0)
                    let downloadPhoto = DownloadPhotoOperation(indexPath: id, photoURL: userPhoto.link, needPercent: 1, delegate: self as DownloadPhotoOperationDelegate)
                    startDownloadImage(operation: downloadPhoto, indexPath: id)
                }
            }
        }
        cell.frame.origin.y = self.CollView_WallHome.bounds.origin.y
        return cell
    }
    func reloadVisibleCells() {
        UIView.setAnimationsEnabled(false)
        self.CollView_WallHome.performBatchUpdates({
            let visibleCellIndexPaths = self.CollView_WallHome.indexPathsForVisibleItems
            self.CollView_WallHome.reloadItems(at: visibleCellIndexPaths)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.CollView_WallHome.frame.size.width, height: self.CollView_WallHome.frame.size.height)
    }
    @objc func reload(){
        CollView_WallHome.reloadData()
    }
}
extension Wallpapers_Home: DownloadPhotoOperationDelegate {
    func downloadPhotoDidFail(operation: DownloadPhotoOperation) {
    }
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation, image:UIImage) {
        let userPhoto = PhotoList[operation.indexPath.item]
        let keyCache = userPhoto.id
        self.photoCache.setObject(image, forKey: keyCache as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        self.CollView_WallHome.reloadItems(at: [id])
        downloadingTasks.removeValue(forKey: operation.indexPath)
    }
}
