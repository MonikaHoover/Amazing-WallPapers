import UIKit
import Foundation
class getJson_LiveHomeImage: NSObject {
    static let sharedInstance = getJson_LiveHomeImage()
    var imageCurrent = [[String : AnyObject]]()
    @objc func fetchFeedForUrlString(){
        URLSession.shared.dataTask(with: link_LiveHome!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        self.imageCurrent = (imageResult["LiveHome"] as? [[String : AnyObject]])!
                        for image in self.imageCurrent{
                            let user = UserInfo(id: image["id"] as! String, link: image["link"] as! String)
                            LivePhotoList.append(user)
                        }
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
