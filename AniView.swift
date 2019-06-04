import UIKit
private class _AniPassthroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if subview.point(inside: convert(point, to: subview), with: event) { return true }
        }
        return false
    }
}
@IBDesignable
class AniView : UIView, CAAnimationDelegate {
    var animationCompletions = Dictionary<CAAnimation, (Bool) -> Void>()
    var viewsByName: [String : UIView]!
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 1125, height: 2001))
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupHierarchy()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let scalingView = self.viewsByName["__scaling__"] {
            var xScale = self.bounds.size.width / scalingView.bounds.size.width
            var yScale = self.bounds.size.height / scalingView.bounds.size.height
            switch contentMode {
            case .scaleToFill:
                break
            case .scaleAspectFill:
                let scale = max(xScale, yScale)
                xScale = scale
                yScale = scale
            default:
                let scale = min(xScale, yScale)
                xScale = scale
                yScale = scale
            }
            scalingView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
            scalingView.center = CGPoint(x:self.bounds.midX, y:self.bounds.midY)
        }
    }
    func setupHierarchy() {
        var viewsByName: [String : UIView] = [:]
        let bundle = Bundle(for:type(of: self))
        let __scaling__ = UIView()
        __scaling__.bounds = CGRect(x:0, y:0, width:1125, height:2001)
        __scaling__.center = CGPoint(x:562.5, y:1000.5)
        __scaling__.clipsToBounds = true
        self.addSubview(__scaling__)
        viewsByName["__scaling__"] = __scaling__
        let background__root = _AniPassthroughView()
        let background__xScale = _AniPassthroughView()
        let background__yScale = _AniPassthroughView()
        let background = UIImageView()
        let imgBackground = UIImage(named:"Background.png", in: bundle, compatibleWith: nil)
        if imgBackground == nil {
            print("** Warning: Could not create image from 'Background.png'")
        }
        background.image = imgBackground
        background.contentMode = .center
        background.bounds = CGRect(x:0, y:0, width:1125.0, height:2001.0)
        background__root.layer.position = CGPoint(x:562.500, y:1000.500)
        background__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        background__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        background__root.transform = CGAffineTransform(rotationAngle: 0.000)
        background__root.addSubview(background__xScale)
        background__xScale.addSubview(background__yScale)
        background__yScale.addSubview(background)
        __scaling__.addSubview(background__root)
        viewsByName["Background__root"] = background__root
        viewsByName["Background__xScale"] = background__xScale
        viewsByName["Background__yScale"] = background__yScale
        viewsByName["Background"] = background
        let picture__root = _AniPassthroughView()
        let picture__xScale = _AniPassthroughView()
        let picture__yScale = _AniPassthroughView()
        let picture = UIImageView()
        let imgPicture = UIImage(named:"picture.png", in: bundle, compatibleWith: nil)
        if imgPicture == nil {
            print("** Warning: Could not create image from 'picture.png'")
        }
        picture.image = imgPicture
        picture.contentMode = .center
        picture.layer.anchorPoint = CGPoint(x:0.987, y:0.993)
        picture.bounds = CGRect(x:0, y:0, width:192.0, height:159.0)
        picture__root.layer.position = CGPoint(x:655.974, y:1017.005)
        picture__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        picture__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        picture__root.transform = CGAffineTransform(rotationAngle: 0.000)
        picture__root.addSubview(picture__xScale)
        picture__xScale.addSubview(picture__yScale)
        picture__yScale.addSubview(picture)
        __scaling__.addSubview(picture__root)
        viewsByName["picture__root"] = picture__root
        viewsByName["picture__xScale"] = picture__xScale
        viewsByName["picture__yScale"] = picture__yScale
        viewsByName["picture"] = picture
        let sadow__root = _AniPassthroughView()
        let sadow__xScale = _AniPassthroughView()
        let sadow__yScale = _AniPassthroughView()
        let sadow = UIImageView()
        let imgSadow = UIImage(named:"sadow.png", in: bundle, compatibleWith: nil)
        if imgSadow == nil {
            print("** Warning: Could not create image from 'sadow.png'")
        }
        sadow.image = imgSadow
        sadow.contentMode = .center
        sadow.bounds = CGRect(x:0, y:0, width:276.0, height:51.0)
        sadow__root.layer.position = CGPoint(x:562.500, y:1123.375)
        sadow__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        sadow__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        sadow__root.transform = CGAffineTransform(rotationAngle: 0.000)
        sadow__root.addSubview(sadow__xScale)
        sadow__xScale.addSubview(sadow__yScale)
        sadow__yScale.addSubview(sadow)
        __scaling__.addSubview(sadow__root)
        viewsByName["sadow__root"] = sadow__root
        viewsByName["sadow__xScale"] = sadow__xScale
        viewsByName["sadow__yScale"] = sadow__yScale
        viewsByName["sadow"] = sadow
        let printer__root = _AniPassthroughView()
        let printer__xScale = _AniPassthroughView()
        let printer__yScale = _AniPassthroughView()
        let printer = UIImageView()
        let imgPrinter = UIImage(named:"printer.png", in: bundle, compatibleWith: nil)
        if imgPrinter == nil {
            print("** Warning: Could not create image from 'printer.png'")
        }
        printer.image = imgPrinter
        printer.contentMode = .center
        printer.bounds = CGRect(x:0, y:0, width:309.0, height:126.0)
        printer__root.layer.position = CGPoint(x:562.500, y:937.500)
        printer__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        printer__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        printer__root.transform = CGAffineTransform(rotationAngle: 0.000)
        printer__root.addSubview(printer__xScale)
        printer__xScale.addSubview(printer__yScale)
        printer__yScale.addSubview(printer)
        __scaling__.addSubview(printer__root)
        viewsByName["printer__root"] = printer__root
        viewsByName["printer__xScale"] = printer__xScale
        viewsByName["printer__yScale"] = printer__yScale
        viewsByName["printer"] = printer
        let paper__root = _AniPassthroughView()
        let paper__xScale = _AniPassthroughView()
        let paper__yScale = _AniPassthroughView()
        let paper = UIImageView()
        let imgPaper = UIImage(named:"paper.png", in: bundle, compatibleWith: nil)
        if imgPaper == nil {
            print("** Warning: Could not create image from 'paper.png'")
        }
        paper.image = imgPaper
        paper.contentMode = .center
        paper.bounds = CGRect(x:0, y:0, width:192.0, height:63.0)
        paper__root.layer.position = CGPoint(x:562.500, y:1000.500)
        paper__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        paper__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        paper__root.transform = CGAffineTransform(rotationAngle: 0.000)
        paper__root.addSubview(paper__xScale)
        paper__xScale.addSubview(paper__yScale)
        paper__yScale.addSubview(paper)
        __scaling__.addSubview(paper__root)
        viewsByName["paper__root"] = paper__root
        viewsByName["paper__xScale"] = paper__xScale
        viewsByName["paper__yScale"] = paper__yScale
        viewsByName["paper"] = paper
        let lightOn__root = _AniPassthroughView()
        let lightOn__xScale = _AniPassthroughView()
        let lightOn__yScale = _AniPassthroughView()
        let lightOn = UIImageView()
        let imgLightOn = UIImage(named:"light-on.png", in: bundle, compatibleWith: nil)
        if imgLightOn == nil {
            print("** Warning: Could not create image from 'light-on.png'")
        }
        lightOn.image = imgLightOn
        lightOn.contentMode = .center
        lightOn.bounds = CGRect(x:0, y:0, width:21.0, height:21.0)
        lightOn__root.layer.position = CGPoint(x:437.221, y:905.846)
        lightOn__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        lightOn__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        lightOn__root.transform = CGAffineTransform(rotationAngle: 0.000)
        lightOn__root.addSubview(lightOn__xScale)
        lightOn__xScale.addSubview(lightOn__yScale)
        lightOn__yScale.addSubview(lightOn)
        __scaling__.addSubview(lightOn__root)
        viewsByName["light-on__root"] = lightOn__root
        viewsByName["light-on__xScale"] = lightOn__xScale
        viewsByName["light-on__yScale"] = lightOn__yScale
        viewsByName["light-on"] = lightOn
        let lightOff__root = _AniPassthroughView()
        let lightOff__xScale = _AniPassthroughView()
        let lightOff__yScale = _AniPassthroughView()
        let lightOff = UIImageView()
        let imgLightOff = UIImage(named:"light-off.png", in: bundle, compatibleWith: nil)
        if imgLightOff == nil {
            print("** Warning: Could not create image from 'light-off.png'")
        }
        lightOff.image = imgLightOff
        lightOff.contentMode = .center
        lightOff.bounds = CGRect(x:0, y:0, width:21.0, height:21.0)
        lightOff__root.layer.position = CGPoint(x:437.221, y:905.846)
        lightOff__xScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        lightOff__yScale.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        lightOff__root.transform = CGAffineTransform(rotationAngle: 0.000)
        lightOff__root.addSubview(lightOff__xScale)
        lightOff__xScale.addSubview(lightOff__yScale)
        lightOff__yScale.addSubview(lightOff)
        __scaling__.addSubview(lightOff__root)
        viewsByName["light-off__root"] = lightOff__root
        viewsByName["light-off__xScale"] = lightOff__xScale
        viewsByName["light-off__yScale"] = lightOff__yScale
        viewsByName["light-off"] = lightOff
        self.viewsByName = viewsByName
    }
    func addUntitledAnimation() {
        addUntitledAnimation(beginTime: 0, fillMode: kCAFillModeBoth, removedOnCompletion: false, completion: nil)
    }
    func addUntitledAnimation(completion: ((Bool) -> Void)?) {
        addUntitledAnimation(beginTime: 0, fillMode: kCAFillModeBoth, removedOnCompletion: false, completion: completion)
    }
    func addUntitledAnimation(removedOnCompletion: Bool) {
        addUntitledAnimation(beginTime: 0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion, completion: nil)
    }
    func addUntitledAnimation(removedOnCompletion: Bool, completion: ((Bool) -> Void)?) {
        addUntitledAnimation(beginTime: 0, fillMode: removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth, removedOnCompletion: removedOnCompletion, completion: completion)
    }
    func addUntitledAnimation(beginTime: CFTimeInterval, fillMode: String, removedOnCompletion: Bool, completion: ((Bool) -> Void)?) {
        let linearTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let easeInOutTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let easeOutTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        if let complete = completion {
            let representativeAnimation = CABasicAnimation(keyPath: "not.a.real.key")
            representativeAnimation.duration = 7.000
            representativeAnimation.delegate = self
            self.layer.add(representativeAnimation, forKey: "UntitledAnimation")
            self.animationCompletions[layer.animation(forKey: "UntitledAnimation")!] = complete
        }
        let pictureRotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        pictureRotationAnimation.duration = 7.000
        pictureRotationAnimation.values = [0.000, 0.000, 0.000, 0.273, 0.273, 0.000, 0.000] as [Float]
        pictureRotationAnimation.keyTimes = [0.000, 0.429, 0.482, 0.571, 0.607, 0.714, 1.000] as [NSNumber]
        pictureRotationAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming, easeInOutTiming, easeInOutTiming, linearTiming]
        pictureRotationAnimation.repeatCount = HUGE
        pictureRotationAnimation.beginTime = beginTime
        pictureRotationAnimation.fillMode = fillMode
        pictureRotationAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["picture__root"]?.layer.add(pictureRotationAnimation, forKey:"Untitled Animation_Rotation")
        let pictureOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        pictureOpacityAnimation.duration = 7.000
        pictureOpacityAnimation.values = [1.000, 1.000, 0.000] as [Float]
        pictureOpacityAnimation.keyTimes = [0.000, 0.750, 1.000] as [NSNumber]
        pictureOpacityAnimation.timingFunctions = [easeInOutTiming, easeInOutTiming]
        pictureOpacityAnimation.repeatCount = HUGE
        pictureOpacityAnimation.beginTime = beginTime
        pictureOpacityAnimation.fillMode = fillMode
        pictureOpacityAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["picture__root"]?.layer.add(pictureOpacityAnimation, forKey:"Untitled Animation_Opacity")
        let pictureTranslationXAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        pictureTranslationXAnimation.duration = 7.000
        pictureTranslationXAnimation.values = [0.000, 0.000, 0.000, -0.984, -0.984, -0.984] as [Float]
        pictureTranslationXAnimation.keyTimes = [0.000, 0.571, 0.607, 0.750, 0.786, 1.000] as [NSNumber]
        pictureTranslationXAnimation.timingFunctions = [linearTiming, easeOutTiming, easeInOutTiming, easeInOutTiming, easeInOutTiming]
        pictureTranslationXAnimation.repeatCount = HUGE
        pictureTranslationXAnimation.beginTime = beginTime
        pictureTranslationXAnimation.fillMode = fillMode
        pictureTranslationXAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["picture__root"]?.layer.add(pictureTranslationXAnimation, forKey:"Untitled Animation_TranslationX")
        let pictureTranslationYAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        pictureTranslationYAnimation.duration = 7.000
        pictureTranslationYAnimation.values = [0.000, -10.000, -10.000, -30.000, -60.000, -60.000, -120.000, -120.000, -120.000, -149.594, -149.594, -1065.766] as [Float]
        pictureTranslationYAnimation.keyTimes = [0.000, 0.071, 0.143, 0.214, 0.232, 0.286, 0.429, 0.571, 0.607, 0.750, 0.786, 1.000] as [NSNumber]
        pictureTranslationYAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming, linearTiming, easeOutTiming, linearTiming, linearTiming, easeOutTiming, easeInOutTiming, easeInOutTiming, easeInOutTiming]
        pictureTranslationYAnimation.repeatCount = HUGE
        pictureTranslationYAnimation.beginTime = beginTime
        pictureTranslationYAnimation.fillMode = fillMode
        pictureTranslationYAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["picture__root"]?.layer.add(pictureTranslationYAnimation, forKey:"Untitled Animation_TranslationY")
        let paperScaleYAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        paperScaleYAnimation.duration = 7.000
        paperScaleYAnimation.values = [1.000, 0.892, 0.892, 0.636, 0.288, 0.288, 0.005, 0.005] as [Float]
        paperScaleYAnimation.keyTimes = [0.000, 0.071, 0.143, 0.214, 0.232, 0.286, 0.429, 1.000] as [NSNumber]
        paperScaleYAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming, linearTiming, easeOutTiming, linearTiming, linearTiming]
        paperScaleYAnimation.repeatCount = HUGE
        paperScaleYAnimation.beginTime = beginTime
        paperScaleYAnimation.fillMode = fillMode
        paperScaleYAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["paper__yScale"]?.layer.add(paperScaleYAnimation, forKey:"Untitled Animation_ScaleY")
        let paperTranslationYAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        paperTranslationYAnimation.duration = 7.000
        paperTranslationYAnimation.values = [0.000, -3.410, -3.410, -11.457, -22.441, -22.441, -31.357, -31.357] as [Float]
        paperTranslationYAnimation.keyTimes = [0.000, 0.071, 0.143, 0.214, 0.232, 0.286, 0.429, 1.000] as [NSNumber]
        paperTranslationYAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming, linearTiming, easeOutTiming, linearTiming, linearTiming]
        paperTranslationYAnimation.repeatCount = HUGE
        paperTranslationYAnimation.beginTime = beginTime
        paperTranslationYAnimation.fillMode = fillMode
        paperTranslationYAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["paper__root"]?.layer.add(paperTranslationYAnimation, forKey:"Untitled Animation_TranslationY")
        let lightOffOpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        lightOffOpacityAnimation.duration = 7.000
        lightOffOpacityAnimation.values = [1.000, 0.000, 1.000, 0.000, 0.000, 1.000, 0.000, 1.000, 0.000, 1.000, 0.000] as [Float]
        lightOffOpacityAnimation.keyTimes = [0.000, 0.071, 0.143, 0.214, 0.321, 0.429, 0.536, 0.643, 0.750, 0.857, 1.000] as [NSNumber]
        lightOffOpacityAnimation.timingFunctions = [linearTiming, linearTiming, linearTiming, linearTiming, linearTiming, linearTiming, linearTiming, linearTiming, linearTiming, linearTiming]
        lightOffOpacityAnimation.repeatCount = HUGE
        lightOffOpacityAnimation.beginTime = beginTime
        lightOffOpacityAnimation.fillMode = fillMode
        lightOffOpacityAnimation.isRemovedOnCompletion = removedOnCompletion
        self.viewsByName["light-off__root"]?.layer.add(lightOffOpacityAnimation, forKey:"Untitled Animation_Opacity")
    }
    func removeUntitledAnimation() {
        self.layer.removeAnimation(forKey: "UntitledAnimation")
        self.viewsByName["picture__root"]?.layer.removeAnimation(forKey: "Untitled Animation_Rotation")
        self.viewsByName["picture__root"]?.layer.removeAnimation(forKey: "Untitled Animation_Opacity")
        self.viewsByName["picture__root"]?.layer.removeAnimation(forKey: "Untitled Animation_TranslationX")
        self.viewsByName["picture__root"]?.layer.removeAnimation(forKey: "Untitled Animation_TranslationY")
        self.viewsByName["paper__yScale"]?.layer.removeAnimation(forKey: "Untitled Animation_ScaleY")
        self.viewsByName["paper__root"]?.layer.removeAnimation(forKey: "Untitled Animation_TranslationY")
        self.viewsByName["light-off__root"]?.layer.removeAnimation(forKey: "Untitled Animation_Opacity")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let completion = self.animationCompletions[anim] {
            self.animationCompletions.removeValue(forKey: anim)
            completion(flag)
        }
    }
    func removeAllAnimations() {
        for subview in viewsByName.values {
            subview.layer.removeAllAnimations()
        }
        self.layer.removeAnimation(forKey: "UntitledAnimation")
    }
}
