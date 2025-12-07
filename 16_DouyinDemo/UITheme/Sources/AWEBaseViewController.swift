import UIKit
import AWEUIResources

open class AWEBaseViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AWEColor.viewBackground
        configureNavigationBar()
    }
    
    open func configureNavigationBar() {
        if let nav = navigationController,
           nav.viewControllers.first !== self {
            let backItem = UIBarButtonItem(
                image: AWEUIResources.navBackIcon,
                style: .plain,
                target: self,
                action: #selector(onBack)
            )
            navigationItem.leftBarButtonItem = backItem
        }
    }
    
    @objc open func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

