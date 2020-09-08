import UIKit
import Toolkit

class {{cookiecutter.projectName}}ViewController: UIViewController {

    // MARK: Private Properties

    private lazy var nextButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Next", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    }
    
    private lazy var debugCoordinatorButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Debug Coordinator", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handleDebugCoordinatorButton), for: .touchUpInside)
    }
    
    private lazy var tabBarCoordinatorButton = UIButton().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("TabBar Coordinator", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(handleTabBarCoordinatorButton), for: .touchUpInside)
    }

    private var viewModel: {{cookiecutter.projectName}}ViewModel!

    // MARK: Public Properties

    public var onMore: VoidClosure?
    public var onNext: VoidClosure?
    public var onDebug: VoidClosure?
    public var onTabBar: VoidClosure?
    
    // MARK: Setup
    
    static func createWith(viewModel: {{cookiecutter.projectName}}ViewModel) -> {{cookiecutter.projectName}}ViewController {
        let viewController = {{cookiecutter.projectName}}ViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }

    // MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: Actions
    
   @objc private func handleMoreButton() {
        self.onMore?()
    }
    
    @objc private func handleNextButton() {
        self.onNext?()
    }
    
    @objc private func handleDebugCoordinatorButton() {
        self.onDebug?()
    }
    
    @objc private func handleTabBarCoordinatorButton() {
        self.onTabBar?()
    }

    deinit {
        print("deinit view controller: \(self)")
    }

     // MARK: Layout
    
    private func setupNavigationBar() {
        let moreButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(self.handleMoreButton))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    private func setupUI() {
        self.title = self.viewModel.title
        view.backgroundColor = .white
        
        view.addSubview(nextButton)
        view.addSubview(debugCoordinatorButton)
        view.addSubview(tabBarCoordinatorButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Style.Padding.triple * 4),
            
            debugCoordinatorButton.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            debugCoordinatorButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: Style.Padding.triple),
            
            tabBarCoordinatorButton.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor),
            tabBarCoordinatorButton.topAnchor.constraint(equalTo: debugCoordinatorButton.bottomAnchor, constant: Style.Padding.triple)
        ])
    }
}
