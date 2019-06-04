import UIKit
class CategogiesView: UIViewController ,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var CateAll: UITableView!
    struct CellCollectionCate {
        static let Cell_H = "Coll_H"
        static let Cell_V = "Coll_V"
        static let Cell_H2 = "Coll_H2"
    }
    enum CellCollectionCateType:Int {
        case Cell_H = 0
        case Coll_V = 1
        case Cell_H2 = 2
    }
    enum CellCollection_H_Type:Int {
        case cell_H_1 = 0
        case cell_H_2 = 1
    }
    var CellCollection_H:Int = 0
    var index:IndexPath = IndexPath()
    var lbl = ["Abstract","Animals","Cities","Science","Flowers","Sports","Mountains","Underwater","Nature","Other"]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.view.setGradients(color_01: UIColor(displayP3Red: 51/255, green: 50/255, blue: 55/255, alpha: 1.0), color_02: UIColor(displayP3Red: 11/255, green: 1/255, blue: 1/255, alpha: 1.0))
        } else {
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    lazy var downloadPhotoHorizal1:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    lazy var downloadPhotoHorizal2:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    lazy var downloadPhotoVertical:OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    var downloadingTaskHorizal1 = Dictionary<IndexPath,Operation>()
    var downloadingTaskHorizal2 = Dictionary<IndexPath,Operation>()
    var downloadingTaskVertical = Dictionary<IndexPath,Operation>()
    let photoCacheHorizal1:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    let photoCacheHorizal2:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    let photoCacheVertical:NSCache<AnyObject,AnyObject> = NSCache<AnyObject,AnyObject>()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        if indexPath.row == 0 {
            if UIScreen.main.bounds.width >= 768{
                height = HIPA(h: 30)
                return height
            }else{
                height = HIPH(h: 16)
                return height
            }
        }else if indexPath.row == 3 || indexPath.row == 6{
            if UIScreen.main.bounds.width >= 768{
                height = HIPA(h: 28)
                return height
            }else{
                height = HIPH(h: 28)
                return height
            }
        }else if indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 7{
            if UIScreen.main.bounds.width >= 768{
                height = HIPA(h: 48)
                return height
            }else{
                height = HIPH(h: 37)
                return height
            }
        }
        else if indexPath.row == 2 || indexPath.row == 5{
            if UIScreen.main.bounds.width >= 768{
                height = HIPA(h: 307)
                return height
            }else{
                height = HIPH(h: 152)
                return height
            }
        }else{
            if UIScreen.main.bounds.width >= 768{
                height = HIPA(h: 187)
                return height
            }else{
                height = HIPH(h: 317)
                return height
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLbl", for: indexPath) as! Name_Cate_TableViewCell
            if indexPath.row == 1 || indexPath.row == 4{
                cell.btn_Name.set(image: #imageLiteral(resourceName: "iconArrow"), title: "SEE ALL", titlePosition: .left, additionalSpacing: 8, state: .normal)
                cell.btn_Name.tintColor = UIColor.white
                cell.btn_Name.tag = indexPath.row
            }
            if indexPath.row == 1{
               cell.lbl_Name.text = "New WallPapers"
            }else if indexPath.row == 4{
                cell.lbl_Name.text = "Most Popular"
            }else if indexPath.row == 7{
                 cell.lbl_Name.text = "Top Categories"
            }
         cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_H", for: indexPath) as! Collection_H_TableViewCell
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_H2", for: indexPath) as! Collection_H2_TableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_None", for: indexPath) as! None_TableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_V", for: indexPath) as! Collection_V_TableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    @IBAction func abtnSeeAll(_ sender: UIButton) {
        if sender.tag == 1{
            dictionary_cate = "N"
            live_dictionary_cate = "N"
            if NewArrive != 1{
                NewArrive = 2
            }
        }else{
            dictionary_cate = "P"
            live_dictionary_cate = "P"
            if Popurlar != 1{
                Popurlar = 2
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == CellCollectionCateType.Cell_H.rawValue{
            return NewArrival_SeeAll_List.count
        }else if collectionView.tag == CellCollectionCateType.Coll_V.rawValue{
            return PhotoIcon.count
        }else if collectionView.tag == CellCollectionCateType.Cell_H2.rawValue{
            return Popular_SeeAll_List.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sizeCell_H:CGSize = CGSize.zero
        var sizeCell_V:CGSize = CGSize.zero
        if UIScreen.main.bounds.width >= 768{
            sizeCell_V = CGSize(width: WIPA(w: 166), height: HIPA(h: 57))
            sizeCell_H = CGSize(width: WIPA(w: 230), height: HIPA(h: 307))
        }else{
            sizeCell_V = CGSize(width: WIPH(w: 160), height: HIPH(h: 57))
            sizeCell_H = CGSize(width: WIPH(w: 93), height: HIPH(h: 152))
        }
        if collectionView.tag == CellCollectionCateType.Coll_V.rawValue{
             return sizeCell_V
        }
        return sizeCell_H
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var raDius:CGFloat = 0.0
        var space: CGFloat = 0.0
        if UIScreen.main.bounds.width >= 768{
            raDius = WIPA(w: 6)
            space = WIPA(w: 40)
        }else{
            raDius = WIPH(w: 4)
            space = WIPH(w: 24)
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if collectionView.tag == CellCollectionCateType.Cell_H.rawValue{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellCollectionCate.Cell_H, for: indexPath) as! Horizontal_CollectionView
            let userPhoto = NewArrival_SeeAll_List[indexPath.row]
            let keyCache = userPhoto.id
            let DocumentsURL = FileManager.default
            let Manager = DocumentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
            let filePath = Manager.appendingPathComponent("\(keyCache).jpg")
            if UIImage(contentsOfFile: filePath.path) != nil{
                cell.H_Image.image = UIImage(contentsOfFile: filePath.path)!
            }else{
                if let downloadedIMG = photoCacheHorizal1.object(forKey: keyCache as AnyObject) as? UIImage{
                    cell.H_Image.image = downloadedIMG
                    if let data = UIImageJPEGRepresentation(cell.H_Image.image!, 1.0)
                    {
                        do {
                            try data.write(to: filePath )
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                    }
                }else {
                    cell.layoutIfNeeded()
                    cell.H_Image.image = #imageLiteral(resourceName: "catePN")
                    if !collectionView.isDecelerating {
                        let id = IndexPath(item: indexPath.row, section: 0)
                        let downloadPhoto = DownloadPhotoOperation_H1(indexPath: id, photoURL: userPhoto.link, needPercent: false, delegate: self as DownloadPhotoOperation_H1Delegate)
                        startDownloadImageHorizal1(operation: downloadPhoto, indexPath: id)
                    }
                }
            }
            cell.layer.cornerRadius = raDius
            cell.clipsToBounds = true
            layout.sectionInset = UIEdgeInsetsMake(0, space, 0, 0)
            layout.itemSize = CGSize(width: 113, height: 200)
            layout.minimumLineSpacing = 8
            layout.scrollDirection = .horizontal
            return cell
        }else if collectionView.tag == CellCollectionCateType.Cell_H2.rawValue{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellCollectionCate.Cell_H2, for: indexPath) as! Horizontal_CollectionView
            let userPhoto = Popular_SeeAll_List[indexPath.row]
            let keyCache = userPhoto.id
            let DocumentsURL = FileManager.default
            let Manager = DocumentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
            let filePath = Manager.appendingPathComponent("\(keyCache).jpg")
            if UIImage(contentsOfFile: filePath.path) != nil{
                cell.H_Image.image = UIImage(contentsOfFile: filePath.path)!
            }else{
                if let downloadedIMG = photoCacheHorizal2.object(forKey: keyCache as AnyObject) as? UIImage{
                    cell.H_Image.image = downloadedIMG
                    if let data = UIImageJPEGRepresentation(cell.H_Image.image!, 1.0)
                    {
                        do {
                            try data.write(to: filePath )
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                    }
                }else {
                    cell.layoutIfNeeded()
                    cell.H_Image.image = #imageLiteral(resourceName: "catePN")
                    if !collectionView.isDecelerating {
                        let id = IndexPath(item: indexPath.row, section: 0)
                        let downloadPhoto = DownloadPhotoOperation_H2(indexPath: id, photoURL: userPhoto.link, needPercent: false, delegate: self as DownloadPhotoOperation_H2Delegate)
                        startDownloadImageHorizal2(operation: downloadPhoto, indexPath: id)
                    }
                }
            }
            cell.layer.cornerRadius = raDius
            cell.clipsToBounds = true
            layout.sectionInset = UIEdgeInsetsMake(0, space, 0, 0)
            layout.itemSize = CGSize(width: 113, height: 200)
            layout.minimumLineSpacing = 8
            layout.scrollDirection = .horizontal
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellCollectionCate.Cell_V, for: indexPath) as! Vertical_CollectionView
            cell.Lbl_NameCate.text = lbl[indexPath.row]
            cell.layer.cornerRadius = raDius
            cell.clipsToBounds = true
            layout.sectionInset = UIEdgeInsetsMake(0, space, 0,space)
            layout.itemSize = CGSize(width: 160, height: 57)
            layout.minimumInteritemSpacing = 0
            var minimumLine:CGFloat = 0
            if UIScreen.main.bounds.width >= 768{
                minimumLine = 8
            }else{
                minimumLine = WIPH(w: UIScreen.main.bounds.width - space*2 - cell.bounds.size.width*2)
            }
            layout.minimumLineSpacing = minimumLine
            layout.scrollDirection = .vertical
            let userPhoto = PhotoIcon[indexPath.row]
            let keyCache = userPhoto.id
            let DocumentsURL = FileManager.default
            let Manager = DocumentsURL.urls(for: .documentDirectory, in: .allDomainsMask).first!
            let filePath = Manager.appendingPathComponent("\(keyCache).jpg")
            if UIImage(contentsOfFile: filePath.path) != nil{
                cell.V_Image.image = UIImage(contentsOfFile: filePath.path)!
            }else{
                if let downloadedIMG = photoCacheVertical.object(forKey: keyCache as AnyObject) as? UIImage{
                    cell.V_Image.image = downloadedIMG
                    if let data = UIImageJPEGRepresentation(cell.V_Image.image!, 1.0)
                    {
                        do {
                            try data.write(to: filePath )
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                    }
                }else {
                    cell.layoutIfNeeded()
                    cell.V_Image.image = #imageLiteral(resourceName: "cateNPN")
                    if !collectionView.isDecelerating {
                        let id = IndexPath(item: indexPath.row, section: 0)
                        let downloadPhoto = DownloadPhotoOperation_V(indexPath: id, photoURL: userPhoto.link, needPercent: false, delegate: self as DownloadPhotoOperation_VDelegate)
                        startDownloadImageVertical(operation: downloadPhoto, indexPath: id)
                    }
                }
            }
            return cell
        }
    }
    func reloadVisibleCells_H1() {
        UIView.setAnimationsEnabled(false)
        (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as! Collection_H_TableViewCell).H_Collection.performBatchUpdates({
            let visibleCellIndexPaths = (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as! Collection_H_TableViewCell).H_Collection.indexPathsForVisibleItems
            (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as! Collection_H_TableViewCell).H_Collection.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    func reloadVisibleCells_H2() {
        UIView.setAnimationsEnabled(false)
        (CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as! Collection_H2_TableViewCell).H_Collection.performBatchUpdates({
            let visibleCellIndexPaths = (CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as! Collection_H2_TableViewCell).H_Collection.indexPathsForVisibleItems
            (CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as! Collection_H2_TableViewCell).H_Collection.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    func reloadVisibleCells_V() {
        UIView.setAnimationsEnabled(false)
        (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as! Collection_V_TableViewCell).Collection_V.performBatchUpdates({
            let visibleCellIndexPaths = (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as! Collection_V_TableViewCell).Collection_V.indexPathsForVisibleItems
            (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as! Collection_V_TableViewCell).Collection_V.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as? Collection_H_TableViewCell) != nil{
            if scrollView == (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as! Collection_H_TableViewCell).H_Collection{
                reloadVisibleCells_H1()
            }else if scrollView == (CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as! Collection_H2_TableViewCell).H_Collection{
                reloadVisibleCells_H2()
            }
        }else if (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as? Collection_V_TableViewCell) != nil{
            if scrollView == (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as! Collection_V_TableViewCell).Collection_V{
                reloadVisibleCells_V()
            }
        }
    }
    func startDownloadImageHorizal1(operation:DownloadPhotoOperation_H1, indexPath: IndexPath) {
        if let _ = downloadingTaskHorizal1[indexPath] {
            return
        }
        downloadingTaskHorizal1[indexPath] = operation
        downloadPhotoHorizal1.addOperation(operation)
    }
    func startDownloadImageHorizal2(operation:DownloadPhotoOperation_H2, indexPath: IndexPath) {
        if let _ = downloadingTaskHorizal2[indexPath] {
            return
        }
        downloadingTaskHorizal2[indexPath] = operation
        downloadPhotoHorizal2.addOperation(operation)
    }
    func startDownloadImageVertical(operation:DownloadPhotoOperation_V, indexPath: IndexPath) {
        if let _ = downloadingTaskVertical[indexPath] {
            return
        }
        downloadingTaskVertical[indexPath] = operation
        downloadPhotoVertical.addOperation(operation)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            if (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as? Collection_H_TableViewCell) != nil{
                if scrollView == (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as! Collection_H_TableViewCell).H_Collection{
                    self.disconect_H1()
                }else if scrollView == (CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as! Collection_H2_TableViewCell).H_Collection{
                    self.disconect_H2()
                }
            }else if (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as? Collection_V_TableViewCell) != nil{
                if scrollView == (CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as! Collection_V_TableViewCell).Collection_V{
                    self.disconect_V()
                }
            }
        }
    }
    func disconect_H1(){
        for downloadhorizal1 in downloadingTaskHorizal1{
            print("Vào Trong 1")
            if (downloadhorizal1.value as! DownloadPhotoOperation_H1).downloadtask?.state == .running{
                (downloadhorizal1.value as! DownloadPhotoOperation_H1).downloadtask?.cancel()
                (downloadhorizal1.value as! DownloadPhotoOperation_H1).downloadtask?.suspend()
            }
            print("Ra Trong 1")
            downloadPhotoHorizal1.cancelAllOperations()
            downloadingTaskHorizal1.removeAll()
        }
    }
    func disconect_H2(){
        for downloadhorizal2 in downloadingTaskHorizal2{
            print("Vào Trong 2")
            if (downloadhorizal2.value as! DownloadPhotoOperation_H2).downloadtask?.state == .running{
                (downloadhorizal2.value as! DownloadPhotoOperation_H2).downloadtask?.cancel()
                (downloadhorizal2.value as! DownloadPhotoOperation_H2).downloadtask?.suspend()
            }
            downloadPhotoHorizal2.cancelAllOperations()
            downloadingTaskHorizal2.removeAll()
            print("Ra Trong 2")
        }
    }
    func disconect_V(){
        for downloadvertical in downloadingTaskVertical{
            print("Vào Trong 3")
            if (downloadvertical.value as! DownloadPhotoOperation_V).downloadtask?.state == .running{
                (downloadvertical.value as! DownloadPhotoOperation_V).downloadtask?.cancel()
                (downloadvertical.value as! DownloadPhotoOperation_V).downloadtask?.suspend()
            }
            print("Ra Trong 3")
        }
        downloadPhotoVertical.cancelAllOperations()
        downloadingTaskVertical.removeAll()
    }
    func disconectedAll(){
        print("Vào 1")
        for downloadhorizal1 in downloadingTaskHorizal1{
             print("Vào Trong 1")
            if (downloadhorizal1.value as! DownloadPhotoOperation_H1).downloadtask?.state == .running{
                (downloadhorizal1.value as! DownloadPhotoOperation_H1).downloadtask?.cancel()
            }
            print("Ra Trong 1")
        }
        print("Ra 1")
        print("Vào 2")
        for downloadhorizal2 in downloadingTaskHorizal2{
            print("Vào Trong 2")
            if (downloadhorizal2.value as! DownloadPhotoOperation_H2).downloadtask?.state == .running{
                (downloadhorizal2.value as! DownloadPhotoOperation_H2).downloadtask?.cancel()
            }
            print("Ra Trong 2")
        }
        print("Ra 2")
        print("Vào 3")
        for downloadvertical in downloadingTaskVertical{
            print("Vào Trong 3")
            if (downloadvertical.value as! DownloadPhotoOperation_V).downloadtask?.state == .running{
                (downloadvertical.value as! DownloadPhotoOperation_V).downloadtask?.cancel()
            }
            print("Ra Trong 3")
        }
        print("Ra 3")
        downloadPhotoHorizal1.cancelAllOperations()
        downloadingTaskHorizal1.removeAll()
        downloadPhotoHorizal2.cancelAllOperations()
        downloadingTaskHorizal2.removeAll()
        downloadPhotoVertical.cancelAllOperations()
        downloadingTaskVertical.removeAll()
    }
}
extension CategogiesView: DownloadPhotoOperation_H1Delegate {
    func downloadPhotoDidFail(operation: DownloadPhotoOperation_H1) {
    }
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation_H1, image:UIImage) {
            let userPhotoHorizal1 = NewArrival_SeeAll_List[operation.indexPath.item]
            let keyCacheHorizal1 = userPhotoHorizal1.id
            self.photoCacheHorizal1.setObject(image, forKey: keyCacheHorizal1 as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        if let cateH1 = CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as? Collection_H_TableViewCell{
            cateH1.H_Collection.reloadItems(at: [id])
        }
        downloadingTaskHorizal1.removeValue(forKey: operation.indexPath)
    }
}
extension CategogiesView: DownloadPhotoOperation_H2Delegate {
    func downloadPhotoDidFail(operation: DownloadPhotoOperation_H2) {
    }
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation_H2, image:UIImage) {
        let userPhotoHorizal2 = Popular_SeeAll_List[operation.indexPath.item]
        let keyCacheHorizal2 = userPhotoHorizal2.id
        self.photoCacheHorizal2.setObject(image, forKey: keyCacheHorizal2 as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        if let cateH2 = CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as? Collection_H2_TableViewCell{
            cateH2.H_Collection.reloadItems(at: [id])
        }
        downloadingTaskHorizal2.removeValue(forKey: operation.indexPath)
    }
}
extension CategogiesView: DownloadPhotoOperation_VDelegate {
    func downloadPhotoDidFail(operation: DownloadPhotoOperation_V) {
    }
    func downloadPhotoDidFinish(operation:DownloadPhotoOperation_V, image:UIImage) {
        let userPhotoVertical = PhotoIcon[operation.indexPath.item]
        let keyCacheVertical = userPhotoVertical.id
        self.photoCacheVertical.setObject(image, forKey: keyCacheVertical as AnyObject)
        let id = IndexPath(item: operation.indexPath.row, section: 0)
        if let cateV = CateAll.cellForRow(at: IndexPath(item: 8, section: 0)) as? Collection_V_TableViewCell{
            cateV.Collection_V.reloadItems(at: [id])
        }
        downloadingTaskVertical.removeValue(forKey: operation.indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
    }
}
extension CategogiesView{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dictionary_cate.removeAll()
        live_dictionary_cate.removeAll()
        if collectionView == (CateAll.cellForRow(at: IndexPath(item: 5, section: 0)) as? Collection_H2_TableViewCell)?.H_Collection{
           temp = indexPath
            dictionary_cate = "P"
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Click_Image_Library_ViewController = storyBoard.instantiateViewController(withIdentifier: "ClickImageCateView") as! ClickImageCateView
            self.present(Click_Image_Library_ViewController, animated: true, completion: nil)
            GetDataPhotoSeeAll.sharedInstance.get()
        }else if collectionView == (CateAll.cellForRow(at: IndexPath(item: 2, section: 0)) as? Collection_H_TableViewCell)?.H_Collection{
            temp = indexPath
            dictionary_cate = "N"
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Click_Image_Library_ViewController = storyBoard.instantiateViewController(withIdentifier: "ClickImageCateView") as! ClickImageCateView
            self.present(Click_Image_Library_ViewController, animated: true, completion: nil)
            GetDataPhotoSeeAll.sharedInstance.get()
        }else{
            dictionary_cate = categories[indexPath.row]
            live_dictionary_cate = live_categories[indexPath.row]
            switch indexPath.row{
                case 0:
                    if Astratc != 1{
                        Astratc = 2
                    }
                break
                case 1:
                    if Animal != 1{
                        Animal = 1
                    }
                break
                case 2:
                    if Cities != 1{
                        Cities = 2
                    }
                break
                case 3:
                    if Scienes != 1{
                        Scienes = 2
                    }
                break
                case 4:
                    if Flowers != 1{
                        Flowers = 2
                    }
                break
                case 5:
                    if Sporst != 1{
                        Sporst = 2
                    }
                break
                case 6:
                    if Mountain != 1{
                        Mountain = 2
                    }
                break
                case 7:
                    if UnderWater != 1{
                        UnderWater = 2
                    }
                break
                case 8:
                    if Nature != 1{
                        Nature = 2
                    }
                break
                case 9:
                    if Other != 1{
                        Other = 2
                    }
                break
            default:
                print("Fail")
            }
        }
    }
}
