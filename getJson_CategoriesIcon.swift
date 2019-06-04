import Foundation
class getJson_CategoriesIcon: NSObject {
    static let sharedInstance = getJson_CategoriesIcon()
    var imageCurrent = [[String : AnyObject]]()
    @objc func fetchFeedForUrlString(){
        URLSession.shared.dataTask(with: link_Categories_icon!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        self.imageCurrent = (imageResult["IconCategories"] as? [[String : AnyObject]])!
                        for image in self.imageCurrent{
                        let user = UserInfo(id: image["id"] as! String, link: image["link"] as! String)
                          PhotoIcon.append(user)
                        }
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
