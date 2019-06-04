import Foundation
class getJson_LiveCategories: NSObject {
    static let sharedInstance = getJson_LiveCategories()
    var imageCurrent = [[String : AnyObject]]()
    @objc func fetchFeedForUrlString(){
        PhotoLiveCategories.removeAll()
        URLSession.shared.dataTask(with: link_Live_Categories!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        liveCateSeeAll = imageResult
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
