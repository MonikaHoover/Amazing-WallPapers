import Foundation
class GetDataPhotoSeeAll: NSObject {
    static let sharedInstance = GetDataPhotoSeeAll()
    var imageCurrent = [[String : AnyObject]]()
    let notification = NotificationCenter()
    func get(){
        PhotoCategoriesSeeAll.removeAll()
        if dictionary_cate == "N"{
            PhotoCategoriesSeeAll = NewArrival_SeeAll_List
        }else if dictionary_cate == "P"{
            PhotoCategoriesSeeAll = Popular_SeeAll_List
        }else{
            guard let catePT = photoCateSeeAll else{
                return
            }
            self.imageCurrent = (catePT[dictionary_cate] as? [[String : AnyObject]])!
            for image in self.imageCurrent{
                let user = UserInfo(id: image["id"] as! String, link: image["link"] as! String)
                PhotoCategoriesSeeAll.append(user)
            }
        }
        NotificationCenter.default.post(name: .CategoriesDownload, object: nil)
    }
}
