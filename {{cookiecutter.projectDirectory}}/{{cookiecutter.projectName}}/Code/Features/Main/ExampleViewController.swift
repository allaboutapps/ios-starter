import UIKit
import Toolbox

class ExampleViewController: UIViewController {
    
    // MARK: Interface
    
    var onNext: (() -> Void)!
    var onLogout: (() -> Void)!
    var onPopover: (() -> Void)?
    
    static func create(with viewModel: ExampleViewModel) -> ExampleViewController {
        let viewController = ExampleViewController()
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
    
    private var viewModel: ExampleViewModel!
    
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
        onNext()
    }
    
    @objc private func handleLogoutButton() {
        onLogout()
    }
    
    @objc private func handlePopoverButton() {
        onPopover?()
    }
    
    // MARK: Deinit
    
    deinit {
        log.debug("deinit view controller: \(self)")
    }
}
