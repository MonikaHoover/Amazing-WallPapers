import UIKit
class Click_Image_Library_ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var Collection_library: UICollectionView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if TakePhotoCoreData.share.getID() != "-1"{
            return TakePhotoCoreData.share.getAllData().count
        }
        return 0
    }
    @IBOutlet weak var btnSave: UIButton!
    @IBAction func abtnSave(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum((Collection_library.visibleCells.first as! Click_Library_CollectionViewCell).img_Library.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The screenshot has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Library", for: indexPath) as! Click_Library_CollectionViewCell
        let documentsPhoto = FileManager.default
        let manager = documentsPhoto.urls(for: .documentDirectory, in: .userDomainMask).first!
        let id = TakePhotoCoreData.share.getAllData()[indexPath.row].id
        let filePath = manager.appendingPathComponent("yourPhoto\(id!).jpg").path
        if UIImage(contentsOfFile: filePath) != nil{
            cell.img_Library.image = UIImage(contentsOfFile: filePath)!
        }
        cell.frame.origin.y = self.Collection_library.bounds.origin.y
        return cell
    }
    @IBAction func abtn_ClickLibrary_cancle(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Collection_library.bounds.size.width, height: Collection_library.bounds.size.height)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLibrary), name: .Library, object: nil)
    }
    @objc func reloadLibrary(){
        Collection_library.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
}
