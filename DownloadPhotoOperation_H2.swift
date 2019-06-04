import Foundation
import UIKit
protocol DownloadPhotoOperation_H2Delegate:class {
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation_H2, image:UIImage)
    func downloadPhotoDidFail(operation:DownloadPhotoOperation_H2)
}
class DownloadPhotoOperation_H2:Operation,URLSessionDelegate,URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if needPercent{
            let percent  = CGFloat (totalBytesWritten)  /  CGFloat (totalBytesExpectedToWrite)
            let inFor = ["index": indexPath.row, "precent": percent] as [String : Any]
            NotificationCenter.default.post(name: .Loadpercent_wallpaperHome, object: nil, userInfo: inFor)
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
    let needPercent:Bool
    weak var downloadtask = URLSessionDownloadTask()
    weak var delegate:DownloadPhotoOperation_H2Delegate?
    init(indexPath:IndexPath, photoURL:String,needPercent:Bool, delegate:DownloadPhotoOperation_H2Delegate?) {
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
