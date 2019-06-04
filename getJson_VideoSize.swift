import Foundation
class getJson_VideoSize: NSObject {
    static let sharedInstance = getJson_VideoSize()
    var imageCurrent = [[String : AnyObject]]()
    @objc func fetchFeedForUrlString(){
        URLSession.shared.dataTask(with: link_Video_Size!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        self.imageCurrent = (imageResult["videosize"] as? [[String : AnyObject]])!
                        print(self.imageCurrent)
                        for image in self.imageCurrent{
                            let user = VideoInfo(id: image["id"] as! String, size: image["size"] as! String)
                            VideoSize.append(user)
                        }
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
    @objc func getsize(key:String)->Float{
        for videosize in VideoSize{
            if videosize.id == key{
                return Float(videosize.size)!
            }
        }
        return 0.0
    }
}
