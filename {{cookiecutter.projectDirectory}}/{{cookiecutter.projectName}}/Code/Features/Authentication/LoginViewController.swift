import UIKit
import {{cookiecutter.projectName}}Kit
import Toolbox

class LoginViewController: UIViewController {
    
    // MARK: Private Properties
    
    private lazy var loginButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Login", for: .normal)
        $0.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    // MARK: Public Properties
    
    public var onLogin: VoidClosure?
    
    // MARK: Setup
    
    static func create() -> LoginViewController {
        let viewController = LoginViewController()
        return viewController
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupConstraints()
    }

    // MARK: Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions

    @objc private func handleLoginButtonTapped() {
        CredentialsController.shared.currentCredentials = Credentials(accessToken: "testToken", refreshToken: nil, expiresIn: nil)
        self.onLogin?()
    }
    
    deinit {
        print("deinit view controller: \(self)")
    }
    
    // MARK: Layout
    
    private func setupUI() {
        view.backgroundColor = .white
        self.title = "Login"
        
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

