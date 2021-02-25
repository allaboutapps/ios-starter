import {{cookiecutter.projectName}}Kit
import Combine
import Fetch
import UIKit
import Logbook

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogging()
        Logbook.info(Environment.current.appInfo)

        Appearance.setup()
        API.setup()
        
        CredentialsController.shared.resetOnNewInstallations()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        AppCoordinator.shared.start(window: window!)
        
        return true
    }
    
    func applicationWillResignActive(_: UIApplication) {}
    
    func applicationDidEnterBackground(_: UIApplication) {}
    
    func applicationWillEnterForeground(_: UIApplication) {}
    
    func applicationDidBecomeActive(_: UIApplication) {}
    
    func applicationWillTerminate(_: UIApplication) {}
}
