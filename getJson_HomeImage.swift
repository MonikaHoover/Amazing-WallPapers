import Foundation
class getJson_HomeImage: NSObject {
    static let sharedInstance = getJson_HomeImage()
    var imageCurrent = [[String : AnyObject]]()
    @objc func fetchFeedForUrlString(){
        URLSession.shared.dataTask(with: link_Home!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        self.imageCurrent = (imageResult["Home"] as? [[String : AnyObject]])!
                        for image in self.imageCurrent{
                            let user = UserInfo(id: image["id"] as! String, link: image["link"] as! String)
                            PhotoList.append(user)
                        }
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
