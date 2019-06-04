import Foundation
class GetDataLive: NSObject {
    static let sharedInstance = GetDataLive()
    var imageCurrent = [[String : AnyObject]]()
    let notification = NotificationCenter()
    func get(){
        PhotoLiveCategories.removeAll()
        if dictionary_cate == "N"{
            PhotoLiveCategories = NewArrival_Live_List
        }else if dictionary_cate == "P"{
            PhotoLiveCategories = Popular_Live_List
        }else{
            guard let catePT = liveCateSeeAll else{
                return
            }
            self.imageCurrent = (catePT[live_dictionary_cate] as? [[String : AnyObject]])!
            for image in self.imageCurrent{
                let user = UserInfo(id: image["id"] as! String, link: image["link"] as! String)
                PhotoLiveCategories.append(user)
            }
        }
    }
}
