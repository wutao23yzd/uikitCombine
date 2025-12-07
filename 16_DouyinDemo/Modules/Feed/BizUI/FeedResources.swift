import UIKit

public enum FeedResources {
    private static var bundle: Bundle = {
        let bundle = Bundle(for: BundleToken.self)
        if let url = bundle.url(forResource: "AWEFeedBizUIResources", withExtension: "bundle"),
           let resourceBundle = Bundle(url: url) {
            return resourceBundle
        }
        return bundle
    }()
    
    public static var likeIcon: UIImage? {
        UIImage(named: "ic_feed_like", in: bundle, compatibleWith: nil)
    }
}

private final class BundleToken {}

