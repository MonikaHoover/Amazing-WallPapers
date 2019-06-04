import Foundation
class getJson_ImgaeLivePhoto: NSObject {
    static let sharedInstance = getJson_ImgaeLivePhoto()
    var imageCurrent = [[String : AnyObject]]()
    @objc func fetchFeedForUrlString(){
        URLSession.shared.dataTask(with: link_Cate_ImageLivePhoTo!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrappedData = data, let imageResult = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    DispatchQueue.main.async(execute: {
                        self.imageCurrent = (imageResult["imageLivePhoto"] as? [[String : AnyObject]])!
                        for image in self.imageCurrent{
                            let user = imageLivePhotoModels(id: image["id"] as! String, link: image["link"] as! String)
                            imageLivePhoto.append(user)
                        }
                    })
                }
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
}
