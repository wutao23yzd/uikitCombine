import UIKit

public protocol FeedEntryProtocol: AnyObject {
    func makeRootViewController() -> UIViewController
}

