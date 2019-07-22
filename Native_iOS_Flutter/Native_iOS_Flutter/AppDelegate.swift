import UIKit
import Flutter
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private weak var flutterEngine: FlutterEngine?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        flutterEngine = getFlutterEngine()
        setupWindow()
        
        return true
    }
    
    func getFlutterEngine() -> FlutterEngine? {
        if let flutterEngine = self.flutterEngine {
            return flutterEngine
        }
        
        return FlutterEngine(name: "io.flutter", project: nil, allowHeadlessExecution: false)
    }
    
    func clearFlutterEngine() {
        flutterEngine?.destroyContext()
        flutterEngine = nil
    }
    
    private func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        let navController = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = navController
        
        self.window?.makeKeyAndVisible()
    }
}

extension UIApplication {
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}
