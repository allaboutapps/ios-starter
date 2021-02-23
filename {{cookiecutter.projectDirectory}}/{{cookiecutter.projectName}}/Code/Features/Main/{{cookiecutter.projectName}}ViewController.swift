import UIKit
import Toolbox

class {{cookiecutter.projectName}}ViewController: UIViewController {
    
    // MARK: Interface
    
    var onNext: (() -> Void)!
    var onLogout: (() -> Void)!
    var onPopover: (() -> Void)?
    
    static func create(with viewModel: {{cookiecutter.projectName}}ViewModel) -> {{cookiecutter.projectName}}ViewController {
        let viewController = {{cookiecutter.projectName}}ViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: Views
    
    private lazy var nextButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Next", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    }

    // MARK: Private
    
    private var viewModel: {{cookiecutter.projectName}}ViewModel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: Setup
    
    private func setupViews() {
        title = viewModel.title
        view.backgroundColor = .white
        
        view.addSubview(nextButton)
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogoutButton))
        navigationItem.setRightBarButton(logoutButton, animated: false)
        
        if onPopover != nil {
            let popoverButton = UIBarButtonItem(title: "SwiftUI Example", style: .plain, target: self, action: #selector(handlePopoverButton))
            navigationItem.setLeftBarButton(popoverButton, animated: false)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Actions

    @objc private func handleNextButton() {
        self.onNext()
    }
    
    @objc private func handleLogoutButton() {
        self.onLogout()
    }
    
    @objc private func handlePopoverButton() {
        self.onPopover?()
    }
    
    // MARK: - Deinit
    
    deinit {
        print("deinit view controller: \(self)")
    }
}
