import UIKit
var indexLibrary = IndexPath()
class Wallpapers_My: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    let documentsPhoto = FileManager.default
    var string:String = ""
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width >= 768{
            return CGSize(width: WIPA(w: 184), height: HIPA(h: 212))
        }else{
            return CGSize(width: WIPH(w: 93), height: HIPH(h: 152))
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if #available(iOS 10.0, *) {
            if TakePhotoCoreData.share.getID() != "-1"{
                return TakePhotoCoreData.share.getAllData().count + 1
            }
        } else {
        }
        return 1
    }
   @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Wallpapers_Cell", for: indexPath) as! CollViewCell1
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var space: CGFloat = 0.0
    if #available(iOS 10.0, *) {
        if indexPath.row != TakePhotoCoreData.share.getAllData().count{
            let documentsPhoto = FileManager.default
            let manager = documentsPhoto.urls(for: .documentDirectory, in: .userDomainMask).first!
            let id = TakePhotoCoreData.share.getAllData()[indexPath.row].id
            let filePath = manager.appendingPathComponent("yourPhoto\(id!).jpg").path
            if UIImage(contentsOfFile: filePath) != nil{
                cell.LivePhotoCate.image = UIImage(contentsOfFile: filePath)!
            }
        }else{
            cell.LivePhotoCate.image = #imageLiteral(resourceName: "plusImageBtn")
        }
        if UIScreen.main.bounds.width >= 768{
            space = WIPA(w: 14)
        }else{
            space = WIPH(w: 0)
        }
        var minimumLine:CGFloat = 0
        if UIScreen.main.bounds.width >= 768{
            minimumLine = WIPH(w: 1)
        }else{
            minimumLine = WIPH(w: 1)
        }
        if UIScreen.main.bounds.width >= 768{
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space)
            layout.minimumLineSpacing = minimumLine
        }else{
            layout.minimumInteritemSpacing = 1
        }
        return cell
    } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Wallpapers_Cell", for: indexPath) as! CollViewCell1
        return cell
    }
    }
    @objc func reloadcollection(){
        Wallpapers_Coll.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexLibrary = indexPath
        if #available(iOS 10.0, *) {
            if indexPath.row == TakePhotoCoreData.share.getAllData().count{
                let inFor = ["index": 1] as [String : Int]
                NotificationCenter.default.post(name: .Wallpapers_Screen, object: nil, userInfo: inFor)
                NotificationCenter.default.post(name: .hideChup, object: nil)
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let Click_Image_Library_ViewController = storyBoard.instantiateViewController(withIdentifier: "Click_Image_Library_ViewController") as! Click_Image_Library_ViewController
                self.present(Click_Image_Library_ViewController, animated: true, completion: nil)
            }
        } else {
        }
    }
    @IBOutlet weak var Wallpapers_Coll: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadcollection), name: .LibaryWallpaper, object: nil)
    }
}
