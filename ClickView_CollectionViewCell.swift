import UIKit
class ClickView_CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img_clickView: UIImageView!
    var downloaded = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = UIScreen.main.bounds
        setupCircleLayers()
        setupPercentageLabel()
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
}
