import Assets
import Networking
import Toolbox
import UIKit

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
        $0.setTitle(Strings.authLoginButton, for: .normal)
        $0.addTarget(self, action: #selector(handleLoginButtonTapped), for: .touchUpInside)
        $0.setTitleColor(.systemRed, for: .normal)
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
        title = Strings.authLoginTitle
        
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        loginButton.withConstraints {
            $0.alignCenter()
        }
    }
    
    // MARK: Actions

    @objc private func handleLoginButtonTapped() {
        CredentialsController.shared.currentCredentials = Credentials(accessToken: "testToken", refreshToken: nil, expiresIn: nil)
        onLogin()
    }
}
