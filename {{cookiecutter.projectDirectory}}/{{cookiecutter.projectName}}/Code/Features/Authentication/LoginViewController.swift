import UIKit
import {{cookiecutter.projectName}}Kit
import Toolbox

class LoginViewController: UIViewController {
    
    // MARK: Interface
    
    var onLogin: (() -> Void)!
    
    static func create() -> LoginViewController {
        let viewController = LoginViewController()
        return viewController
    }
    
    // MARK: Views
    
    private lazy var loginButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Login", for: .normal)
        $0.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        $0.setTitleColor(.systemBlue, for: .normal)
    }

    // MARK: Private
    
    // viewModel, computed properties etc.
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: Setup
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Login"
        
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: Actions

    @objc private func handleLoginButtonTapped() {
        CredentialsController.shared.currentCredentials = Credentials(accessToken: "testToken", refreshToken: nil, expiresIn: nil)
        onLogin()
    }
    
    // MARK: - Deinit
    
    deinit {
        print("deinit view controller: \(self)")
    }
}
