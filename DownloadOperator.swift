import UIKit
protocol DownloadPhotoOperationDelegate:class {
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation, image:UIImage)
    func downloadPhotoDidFail(operation:DownloadPhotoOperation)
}
class DownloadPhotoOperation:Operation,URLSessionDelegate,URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if needPercent == 1{
            let percent  = CGFloat (totalBytesWritten)  /  CGFloat (totalBytesExpectedToWrite)
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
            NotificationCenter.default.post(name: .Loadpercent_wallpaperHome, object: nil, userInfo: inFor)
        }else if needPercent == 2{
            let percent  = CGFloat (totalBytesWritten)  /  CGFloat (totalBytesExpectedToWrite)
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
            NotificationCenter.default.post(name: .ClickLoadpercent_wallpaperHome, object: nil, userInfo: inFor)
        }else if needPercent == 4{
            let percent  = CGFloat (totalBytesWritten)  /  CGFloat (totalBytesExpectedToWrite)
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
             NotificationCenter.default.post(name: .SeeallLoadpercent_livewallpaperHome, object: nil, userInfo: inFor)
        }else{
            let percent  = CGFloat (totalBytesWritten)  /  CGFloat (totalBytesExpectedToWrite)
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
            NotificationCenter.default.post(name: .SeeallLoadpercent_wallpaperHome, object: nil, userInfo: inFor)
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let imgData = try? Data(contentsOf: location) else {
            handleFail()
            return
        }
        if isCancelled { return }
        if let downloadedImage = UIImage(data: imgData) {
            DispatchQueue.main.async(execute: {
                print("finished download")
                self.delegate?.downloadPhotoDidFinish(operation: self, image: downloadedImage)
            })
        } else {
            handleFail()
        }
    }
    let indexPath:IndexPath
    let photoURL:String
    let needPercent:Int
    weak var downloadtask = URLSessionDownloadTask()
    weak var delegate:DownloadPhotoOperationDelegate?
    init(indexPath:IndexPath, photoURL:String,needPercent:Int, delegate:DownloadPhotoOperationDelegate?) {
        self.indexPath = indexPath
        self.photoURL = photoURL
        self.delegate = delegate
        self.needPercent = needPercent
    }
    override func main() {
        if isCancelled { return }
        guard let url = URL(string: photoURL) else {
            handleFail()
            return
        }
        if isCancelled { return }
        print("begin download file")
        let configuration = URLSessionConfiguration.ephemeral
        weak var operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        downloadtask = urlSession.downloadTask(with: url)
        downloadtask?.resume()
    }
    private func handleFail() {
        DispatchQueue.main.async(execute: {
            self.delegate?.downloadPhotoDidFail(operation: self)
        })
    }
}
