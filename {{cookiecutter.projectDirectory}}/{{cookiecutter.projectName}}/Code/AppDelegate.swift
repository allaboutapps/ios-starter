import UIKit
import Fetch
import {{cookiecutter.projectName}}Kit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Appearance.setup()
        API.setup()
        
        CredentialsController.shared.resetOnNewInstallations()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        AppCoordinator.shared.start(window: window!)
        
        testRequest()
        
        return true
    }
    
    func testRequest() {
        API.Examples.get().fetch().startWithResult { (result) in
            switch result {
            case .success(let response):
                print(response.model)
            case.failure:
                print("failure")
            }
        }
    }

    func applicationWillResignActive(_: UIApplication) {
    }

    func applicationDidEnterBackground(_: UIApplication) {
    }

    func applicationWillEnterForeground(_: UIApplication) {
    }

    func applicationDidBecomeActive(_: UIApplication) {
    }

    func applicationWillTerminate(_: UIApplication) {
    }
}
