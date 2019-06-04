import UIKit
class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    private func config(){
        tabBar.tintColor = UIColor.white   
        tabBar.layer.borderWidth = 0
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage(named: "background")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1{
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
            bounceAnimation.duration = 1.2
            bounceAnimation.calculationMode = kCAAnimationCubic
            (tabBar.subviews[1].subviews[0] as! UIImageView).layer.add(bounceAnimation, forKey: "bounceAnimation")
        }
            else  if item.tag == 2{
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
            bounceAnimation.duration = 1.2
            bounceAnimation.calculationMode = kCAAnimationCubic
            (tabBar.subviews[2].subviews[0] as! UIImageView).layer.add(bounceAnimation, forKey: "bounceAnimation")
        }else{
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
            bounceAnimation.duration = 1.2
            bounceAnimation.calculationMode = kCAAnimationCubic
            (tabBar.subviews[3].subviews[0] as! UIImageView).layer.add(bounceAnimation, forKey: "bounceAnimation")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
