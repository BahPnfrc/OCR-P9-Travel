import UIKit

class MainTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UITabBar.appearance().backgroundColor = Painting.defViewColor
        UITabBar.appearance().layer.cornerRadius = Painting.defRadius
    }

}
