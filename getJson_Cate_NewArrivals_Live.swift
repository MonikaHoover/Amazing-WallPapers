import Foundation
class getJson_Cate_NewArrivals_Live: NSObject {
    static let sharedInstance = getJson_Cate_NewArrivals_Live()
    var imageCurrent = [[String : AnyObject]]()
     @objc func fetchFeedForUrlString(){
        URLSession.shared.dataTask(with: link_Cate_NewArrivals_Live!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        self.imageCurrent = (imageResult["NewArrival-SeeAll-Live"] as? [[String : AnyObject]])!
                        for image in self.imageCurrent{
                            let user = UserInfo(id: image["id"] as! String, link: image["link"] as! String)
                            NewArrival_Live_List.append(user)
                        }
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
