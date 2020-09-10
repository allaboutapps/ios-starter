import UIKit
import {{cookiecutter.projectName}}Kit
import Toolbox

class MoreViewController: UIViewController {
    // MARK: Private Properties
    
    private lazy var logoutButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Logout", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handleLogoutButton), for: .touchUpInside)
    }
    
    // MARK: Setup
    
    static func create() -> MoreViewController {
        return MoreViewController()
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
    
    @objc private func handleLogoutButton() {
        CredentialsController.shared.currentCredentials = nil
    }
    
    deinit {
        print("deinit view controller: \(self)")
    }
    
    // MARK: Layout
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "More"
        
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}