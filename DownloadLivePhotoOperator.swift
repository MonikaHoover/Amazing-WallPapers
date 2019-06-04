import UIKit
protocol DownloadVideoOperationDelegate:class {
    func DownloadVideoDidFinish(operation:DownloadVideoOperation, video:Data)
    func DownloadVideoDidFail(operation:DownloadVideoOperation)
}
class DownloadVideoOperation:Operation,URLSessionDelegate,URLSessionDownloadDelegate {
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if needPercent == 1{
            let percent  =    CGFloat (totalBytesWritten) / CGFloat(getJson_VideoSize.sharedInstance.getsize(key: key))
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
            NotificationCenter.default.post(name: .Loadpercent_livewallpaperHome, object: nil, userInfo: inFor)
            print("Image downloading: \(key)")
            print("Total need download: \(CGFloat(getJson_VideoSize.sharedInstance.getsize(key: key)))")
            print("Downloading:\(totalBytesWritten)....")
            print("Precent Downloading:\(percent)")
        }else if needPercent == 2{
        }else{
            let percent  =    CGFloat (totalBytesWritten) / CGFloat(getJson_VideoSize.sharedInstance.getsize(key: key))
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
            NotificationCenter.default.post(name: .CSeeallLoadpercent_livewallpaperHome, object: nil, userInfo: inFor)
            print("Image downloading: \(key)")
            print("Total need download: \(CGFloat(getJson_VideoSize.sharedInstance.getsize(key: key)))")
            print("Downloading:\(totalBytesWritten)....")
            print("Precent Downloading:\(percent)")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let vidData = try? Data(contentsOf: location) else {
            handleFail()
            return
        }
        if isCancelled { return }
        DispatchQueue.main.async(execute: {
            self.delegate?.DownloadVideoDidFinish(operation: self, video: vidData)
            print("finished download")
        })
    }
    let indexPath:IndexPath
    let videoURL:String
    let key:String
    let needPercent:Int
    weak var downloadtask = URLSessionDownloadTask()
    weak var delegate:DownloadVideoOperationDelegate?
    init(indexPath:IndexPath, videoURL:String,needPercent:Int, delegate:DownloadVideoOperationDelegate?,key:String) {
        self.indexPath = indexPath
        self.videoURL = videoURL
        self.delegate = delegate
        self.needPercent = needPercent
        self.key = key
    }
    override func main() {
        if isCancelled { return }
        guard let fileURL = URL(string: videoURL) else {
            handleFail()
            return
        }
        if self.isCancelled { return }
        let configuration = URLSessionConfiguration.ephemeral
        weak var operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        downloadtask = urlSession.downloadTask(with: fileURL)
        downloadtask?.resume()
    }
    private func handleFail() {
        DispatchQueue.main.async(execute: {
            self.delegate?.DownloadVideoDidFail(operation: self)
        })
    }
}
