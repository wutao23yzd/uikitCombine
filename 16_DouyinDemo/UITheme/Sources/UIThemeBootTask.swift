import UIKit
import AWELaunchKit

/// 负责保证在启动时统一配置一些额外样式（如果需要）
/// 目前主要工作交给 AWENavigationController，但预留扩展点
public final class UIThemeBootTask: BootTask {
    
    public override func execute(completion: @escaping () -> Void) {
        // 如果有需要对全局 UIAppearance 做更多配置，可以写在这里
        // 比如全局 UIBarButtonItem、UITableView、UITabBar 等
        
        completion()
    }
}

/// 宿主 / Shell AppDelegate 里调用这个函数，注册 UI 主题相关 BootTask
public func registerUIThemeBootTasks() {
    LaunchKit.register(task: UIThemeBootTask(phase: .preInfra, priority: 200))
}

