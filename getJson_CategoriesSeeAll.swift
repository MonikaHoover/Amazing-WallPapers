import Foundation
class getJson_CategoriesSeeAll: NSObject {
    static let sharedInstance = getJson_CategoriesSeeAll()
    @objc func fetchFeedForUrlString(){
        PhotoCategoriesSeeAll.removeAll()
        URLSession.shared.dataTask(with: link_Categories_SeeAll!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        photoCateSeeAll = imageResult
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
