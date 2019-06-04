import Foundation
import UIKit
let categories = ["Abstracts","Animals","Cities","Science","Flowers","Sports","Mountains","Underwater","Nature","Other"]
let live_categories = ["live-Abstracts","live-Animals","live-Cities","live-Science","live-Flowers","live-Sports","live-Mountains","live-Underwater","live-Nature","live-Other"]
var json_imageHome:[String] = []
var json_idImageHome:[String] = []
var json_LiveImageHome:[String] = []
var PhotoIcon:Array<UserInfo> = [UserInfo]()
var PhotoCategoriesSeeAll:Array<UserInfo> = [UserInfo]()
var PhotoLiveCategories:Array<UserInfo> = [UserInfo]()
var PhotoList:Array<UserInfo> = [UserInfo]()
var LivePhotoList:Array<UserInfo> = [UserInfo]()
var NewArrival_SeeAll_List:Array<UserInfo> = [UserInfo]()
var NewArrival_Horizal_List:Array<UserInfo> = [UserInfo]()
var NewArrival_Live_List:Array<UserInfo> = [UserInfo]()
var Popular_SeeAll_List:Array<UserInfo> = [UserInfo]()
var Popular_Horizal_List:Array<UserInfo> = [UserInfo]()
var Popular_Live_List:Array<UserInfo> = [UserInfo]()
var ClickCategories = [[String : AnyObject]]()
var live_dictionary_cate = ""
var dictionary_cate:String = ""
var photosListBuffer:Array<UserInfo> = [UserInfo]()
var downloadedData = ""
var VideoSize:Array<VideoInfo> = [VideoInfo]()
var photoCateSeeAll:NSDictionary?
var liveCateSeeAll:NSDictionary?
extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(r: 70, g: 70, b: 70)
    static let outlineStrokeColor = UIColor.rgb(r: 1, g: 255, b: 198)
    static let trackStrokeColor = UIColor.rgb(r: 98, g: 104, b: 111)
    static let pulsatingFillColor = UIColor.rgb(r: 94, g: 207, b: 218)
}
var imageLivePhoto:[imageLivePhotoModels] = []
