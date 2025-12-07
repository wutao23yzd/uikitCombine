import UIKit

public final class AWENavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultStyle()
    }
    
    private func applyDefaultStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AWEColor.navBackground
        appearance.titleTextAttributes = [
            .foregroundColor: AWEColor.navTitle,
            .font: AWEFont.navTitle
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = AWEColor.navTint
    }
    

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}

