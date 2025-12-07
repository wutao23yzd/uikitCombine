import UIKit

public enum SearchResources {
    private static var bundle: Bundle = {
        let bundle = Bundle(for: BundleToken.self)
        if let url = bundle.url(forResource: "AWESearchBizUIResources", withExtension: "bundle"),
           let resourceBundle = Bundle(url: url) {
            return resourceBundle
        }
        return bundle
    }()
    
    public static var searchTabIcon: UIImage? {
        UIImage(named: "ic_search_tab", in: bundle, compatibleWith: nil)
    }
}

private final class BundleToken {}
