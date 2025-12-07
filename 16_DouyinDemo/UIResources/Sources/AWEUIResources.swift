import UIKit

public enum AWEUIResources {
    private static var bundle: Bundle = {
        let bundle = Bundle(for: BundleToken.self)
        if let url = bundle.url(forResource: "AWEUIResources", withExtension: "bundle"),
           let resourceBundle = Bundle(url: url) {
            return resourceBundle
        }
        return bundle
    }()
    
    // 全局通用“返回”图标
    public static var navBackIcon: UIImage? {
        UIImage(named: "ic_nav_back", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }
    
    public static var placeholderAvatar: UIImage? {
        UIImage(named: "ic_avatar_placeholder", in: bundle, compatibleWith: nil)
    }
}

private final class BundleToken {}
