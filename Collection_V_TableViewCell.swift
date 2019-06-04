import UIKit
class Collection_V_TableViewCell: UITableViewCell {
    @IBOutlet weak var Collection_V: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .CategoriesDownload, object: nil)
    }
    @objc func reload(){
        Collection_V.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func reloadVisibleCells() {
        UIView.setAnimationsEnabled(false)
        self.Collection_V.performBatchUpdates({
            let visibleCellIndexPaths = self.Collection_V.indexPathsForVisibleItems
            self.Collection_V.reloadItems(at: visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.bounds.size.height
        if offsetY >= scrollView.contentSize.height {
        }
        reloadVisibleCells()
    }
}
