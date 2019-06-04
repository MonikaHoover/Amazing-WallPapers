import UIKit
import Photos
import PhotosUI
import MobileCoreServices
import NVActivityIndicatorView
@available(iOS 9.1, *)
class Click_LivePhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Click_live: PHLivePhotoView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var Live_Photo: UIImageView!
    var filePath:String = ""
    @IBOutlet weak var loadingMainView: UIView!
    @IBOutlet weak var imageLoading: UIImageView!
    @IBOutlet weak var animationLoading: NVActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = UIScreen.main.bounds
        setupCircleLayers()
        setupPercentageLabel()
        self.animationLoading.type = .lineScale
        self.animationLoading.startAnimating()
        self.animationLoading.color = .outlineStrokeColor
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var trackLayer:CAShapeLayer!
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont(name: "SFProDisplay-Bold", size: 20)
        label.textColor = .white
        label.tag = 10
        return label
    }()
    func setupPercentageLabel() {
        self.contentView.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        percentageLabel.center = self.contentView.center
    }
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = self.contentView.center
        return layer
    }
    func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        pulsatingLayer.name = "pulsatingLayer"
        self.contentView.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        trackLayer.name = "trackLayer"
        self.contentView.layer.addSublayer(trackLayer)
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.name = "shapeLayer"
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        shapeLayer.isHidden = true
        pulsatingLayer.isHidden = true
        trackLayer.isHidden = true
        self.contentView.layer.addSublayer(shapeLayer)
    }
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    func loadVideoLivePhoTo(linkDataMOV:String,linkDataIMG:String){
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        Click_live.livePhoto = nil
        PHLivePhoto.request(withResourceFileURLs: [ urls[0].appendingPathComponent(linkDataMOV), urls[0].appendingPathComponent(linkDataIMG)],
                            placeholderImage: nil,
                            targetSize: self.view.bounds.size,
                            contentMode: PHImageContentMode.aspectFit,
                            resultHandler: { (livePhoto, info) -> Void in
                                self.Click_live.livePhoto = livePhoto
        })
    }
    func loadVideoWithVideoURL(_ videoURL: URL,imagedTemp:String,index:Int) {
        Click_live.livePhoto = nil
        let documentsURL = FileManager.default
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = NSValue(time: CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, asset.duration.timescale))
        generator.generateCGImagesAsynchronously(forTimes: [time]) { [weak self] _, image, _, _, _ in
            if let image = image, let data = UIImagePNGRepresentation(UIImage(cgImage: image)) {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let imageURL = urls[0].appendingPathComponent("\(imagedTemp).jpg")
                try? data.write(to: imageURL, options: [.atomic])
                let image = imageURL.path
                let mov = videoURL.path
                let assetIdentifier = UUID().uuidString
                let movOut = urls[0].appendingPathComponent("\(imagedTemp)IMG.MOV")
                let imaOut = urls[0].appendingPathComponent("\(imagedTemp)IMG.JPG")
                JPEG(path: image).write(imaOut, assetIdentifier: assetIdentifier)
                QuickTimeMov(path: mov).write(movOut,
                                              assetIdentifier: assetIdentifier)
                _ = DispatchQueue.main.sync {
                    LivePhoToCoreData.share.saveData(id: imagedTemp, linkDataMOV: "\(imagedTemp)IMG.MOV", linkDataIMG: "\(imagedTemp)IMG.JPG")
                    let livePT:PHLivePhotoView = PHLivePhotoView()
                    PHLivePhoto.request(withResourceFileURLs: [ urls[0].appendingPathComponent("\(imagedTemp)IMG.MOV"), urls[0].appendingPathComponent("\(imagedTemp)IMG.JPG")],
                                        placeholderImage: nil,
                                        targetSize: UIScreen.main.bounds.size,
                                        contentMode: PHImageContentMode.aspectFit,
                                        resultHandler: { (livePhoto, info) -> Void in
                                            self?.Click_live.livePhoto = livePhoto
                                            livePT.livePhoto = livePhoto
                                            livePhotoTemp[imagedTemp] = livePT
                                            let inFor = ["index": index] as [String : Any]
                                            self?.filePath = imagedTemp
                                            NotificationCenter.default.post(name: .CSeeallinitLive, object: nil, userInfo: inFor)
                    })
                }
            }
        }
    }
    func exportLivePhoto () {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: urls[0].appendingPathComponent("\(self.filePath)IMG.MOV").path), options: options)
            creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: urls[0].appendingPathComponent("\(self.filePath)IMG.JPG").path), options: options)
        }, completionHandler: { (success, error) -> Void in
            if !success {
                DTLog((error?.localizedDescription)!)
            }else{
                NotificationCenter.default.post(name: .CSaveSCClick, object: nil)
            }
        })
    }
}
