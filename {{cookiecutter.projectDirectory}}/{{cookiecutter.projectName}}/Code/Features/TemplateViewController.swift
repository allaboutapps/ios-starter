import Foundation
import UIKit
import Toolbox

class TemplateViewController: UIViewController {
    
    // MARK: Interface
    
    var onSubmit: ((String) -> Void)! // ! for required closures, ? only if optional
    var onCancel: (() -> Void)!
    
    static func create(title: String, viewModel: TemplateViewModel) -> TemplateViewController {
        let viewController = TemplateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    // MARK: Views
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    
    private lazy var headerView = UIView().with {
        $0.backgroundColor = .red
    }

    // MARK: Private
    
    private var viewModel: TemplateViewModel!
    
    // computed properties etc.
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: Setup
    
    private func setupViews() {
        view.addSubview(headerView)
    }

    private func setupConstraints() {
        headerView.pin(to: view)
    }

    // MARK: Actions

    // @objc handler etc.

    // MARK: Deinit
    
    deinit {
        log.debug("deinit view controller: \(self)")
    }
}

// MARK: - UIScrollViewDelegate

extension TemplateViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
