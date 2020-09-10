import {{cookiecutter.projectName}}Kit
import Combine
import Fetch
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var cancellable = Set<AnyCancellable>()
    
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
        API.Examples.get()
            .requestModel()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                print(response)
            })
            .store(in: &cancellable)
    }
    
    func applicationWillResignActive(_: UIApplication) {}
    
    func applicationDidEnterBackground(_: UIApplication) {}
    
    func applicationWillEnterForeground(_: UIApplication) {}
    
    func applicationDidBecomeActive(_: UIApplication) {}
    
    func applicationWillTerminate(_: UIApplication) {}
}
