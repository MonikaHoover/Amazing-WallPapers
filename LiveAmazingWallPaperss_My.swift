import UIKit
class LiveWallpapers_My: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width >= 768{
            return CGSize(width: WIPA(w: 184), height: HIPA(h: 212))
        }else{
            return CGSize(width: WIPH(w: 93), height: HIPH(h: 152))
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if #available(iOS 10.0, *) {
            return LivePhoToMyCoreData.share.getAllData().count + 1
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if #available(iOS 9.1, *) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveWallpapers_Cell", for: indexPath) as! Live_Library_CollectionViewCell
            if #available(iOS 10.0, *) {
                if indexPath.row != LivePhoToMyCoreData.share.getAllData().count{
                    var l = LivePhoToMyCoreData.share.getAllData()[indexPath.row].linkDataIMG!
                    let range = l.index(l.endIndex, offsetBy: -3)..<l.endIndex
                    l.removeSubrange(range)
                    l = l + "jpg"
                    print(l)
                    cell.createVideo.image = UIImage(contentsOfFile: LivePhoToMyCoreData.share.getAllData()[indexPath.row].linkDataIMG!)
                }else{
                    cell.createVideo.image = #imageLiteral(resourceName: "plusImageBtn")
                }
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                var space: CGFloat = 0.0
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
                let cell = UICollectionViewCell()
                return cell;
            }
            } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveWallpapers_Cell", for: indexPath) as! Live_Library_CollectionViewCell
            return cell
            }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        temp = indexPath
        if #available(iOS 10.0, *) {
            if indexPath.row == LivePhoToMyCoreData.share.getAllData().count{
                let inFor = ["index": 2] as [String : Int]
                NotificationCenter.default.post(name: .Wallpapers_Screen, object: nil, userInfo: inFor)
                NotificationCenter.default.post(name: .hideChup, object: nil)
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let chup = storyBoard.instantiateViewController(withIdentifier: "chup") as! chup
                self.present(chup, animated: true, completion: nil)
            }
        } else {
        }
    }
    @IBOutlet weak var LiveWallpapers_Coll: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .reloadLiveWallpapers, object: nil)
    }
    @objc func reload(){
        self.loading.isHidden = true
        self.LiveWallpapers_Coll.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if checkCamera == 1{
            self.loading.isHidden = false
            self.loading.startAnimating()
            checkCamera = 0
        }else{
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
    }
}
