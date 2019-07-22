import UIKit
import Flutter
import FlutterPluginRegistrant

let kFlutterCountChannel: String = "io.flutter.count"

class ViewController: UIViewController {
    
    private weak var flutterEngine: FlutterEngine?
    private var flutterViewController: FlutterViewController?
    private var flutterChannel: FlutterBasicMessageChannel?
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    var responseLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.text = "[flutter callback]"
        return view
    }()
    
    var actionButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Call Flutter from Native", for: .normal)
        view.tintColor = .white
        view.backgroundColor = .blue
        view.layer.cornerRadius = 25
        return view
    }()
}

// MARK: - Initializating Flutter
private extension ViewController {
    @objc
    func invokeFlutter() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.flutterEngine = appDelegate?.getFlutterEngine()
        self.flutterViewController = FlutterViewController(nibName: nil, bundle: nil)
        guard
            let flutterEngine = self.flutterEngine,
            let flutterVC = self.flutterViewController else {
                print("flutter is not running 💥")
                return
        }
        
        flutterVC.setInitialRoute("/second")
        setupFlutterChannel(on: flutterVC)
        
        flutterEngine.run(withEntrypoint: nil)
        
        present(flutterVC, animated: true)
    }
    
    func setupFlutterChannel(on messenger: FlutterBinaryMessenger) {
        self.flutterChannel = FlutterBasicMessageChannel(name: kFlutterCountChannel, binaryMessenger: messenger, codec: FlutterStringCodec.sharedInstance())
        
        self.flutterChannel?.setMessageHandler({ [weak self] (rawMessage, callback) in
            if let message = rawMessage as? NSString {
                self?.responseLabel.text = "Flutter Message [\(message as String)]"
                self?.deallocFlutter()
            }
            callback(nil)
        })
    }
    
    @objc
    func deallocFlutter() {
        flutterViewController?.dismiss(animated: false, completion: {
            self.flutterViewController = nil
            self.flutterChannel?.setMessageHandler(nil)
            self.flutterChannel = nil
            
            self.flutterEngine?.destroyContext()
            
            UIApplication.shared.appDelegate?.clearFlutterEngine()
            self.dismiss(animated: true)
        })
    }
}

// MARK: - Setup View
private extension ViewController {
    func setupView() {
        title = "my native application"
        view.addSubview(actionButton)
        view.addSubview(responseLabel)
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            responseLabel.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            responseLabel.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor, constant: 50)
        ])
    }
    
    func setupActions() {
        actionButton.addTarget(self, action: #selector(invokeFlutter), for: .touchUpInside)
    }
}
