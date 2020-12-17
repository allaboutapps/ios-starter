import Toolbox
import UIKit

class DebugViewController: UIViewController {
    // MARK: Private Properties
    
    private lazy var pushViewControllerButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Push", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handlePushButton), for: .touchUpInside)
    }
    
    private lazy var popViewControllerButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Pop", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handlePopButton), for: .touchUpInside)
    }
    
    private lazy var presentCoordinatorButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Present coordinator", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handlePresentCoordinatorButton), for: .touchUpInside)
    }
    
    private lazy var dismissCoordinatorButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Dismiss coordinator", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handleDismissCoordinatorButton), for: .touchUpInside)
    }
    
    private lazy var pushCoordinatorButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Push coordinator", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handlePushCoordinatorButton), for: .touchUpInside)
    }
    
    private lazy var logoutButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Logout", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handlePushCoordinatorButton), for: .touchUpInside)
    }
    
    private var viewModel: DebugViewModel!
    
    // MARK: Public Properties
    
    public var onPush: VoidClosure?
    public var onPop: VoidClosure?
    public var onModal: VoidClosure?
    public var onDismiss: VoidClosure?
    public var onPushCoordinator: VoidClosure?
    public var onLogout: VoidClosure?
    
    // MARK: Setup
    
    static func create(with viewModel: DebugViewModel) -> DebugViewController {
        let viewController = DebugViewController()
        viewController.viewModel = viewModel
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
    
    @objc private func handlePushButton() {
        self.onPush?()
    }
    
    @objc private func handlePopButton() {
        self.onPop?()
    }
    
    @objc private func handlePresentCoordinatorButton() {
        self.onModal?()
    }
    
    @objc private func handleDismissCoordinatorButton() {
        self.onDismiss?()
    }
    
    @objc private func handlePushCoordinatorButton() {
        self.onPushCoordinator?()
    }
    
    @objc private func handleLogoutButton() {
        self.onLogout?()
    }
    
    deinit {
        print("deinit view controller: \(self)")
    }
    
    // MARK: Layout
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews(pushViewControllerButton, popViewControllerButton, presentCoordinatorButton, dismissCoordinatorButton, pushCoordinatorButton, logoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pushViewControllerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Style.Padding.double),
            pushViewControllerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Style.Padding.triple * 4),
            
            popViewControllerButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Style.Padding.double),
            popViewControllerButton.centerYAnchor.constraint(equalTo: pushViewControllerButton.centerYAnchor),
            
            presentCoordinatorButton.leftAnchor.constraint(equalTo: pushCoordinatorButton.leftAnchor),
            presentCoordinatorButton.topAnchor.constraint(equalTo: pushViewControllerButton.bottomAnchor, constant: Style.Padding.triple),
            
            dismissCoordinatorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Style.Padding.double),
            dismissCoordinatorButton.centerYAnchor.constraint(equalTo: presentCoordinatorButton.centerYAnchor),
            
            pushCoordinatorButton.leftAnchor.constraint(equalTo: pushViewControllerButton.leftAnchor),
            pushCoordinatorButton.topAnchor.constraint(equalTo: presentCoordinatorButton.bottomAnchor, constant: Style.Padding.double),
            
            logoutButton.topAnchor.constraint(equalTo: pushCoordinatorButton.bottomAnchor, constant: Style.Padding.double),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
