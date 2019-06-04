import UIKit
class Collection_H2_TableViewCell: UITableViewCell {
    @IBOutlet weak var H_Collection: UICollectionView!
    @objc func reload_Horizal_Popular_SeeAll(){
        H_Collection.reloadData()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reload_Horizal_Popular_SeeAll), name: .Popular_SeeAll, object: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
