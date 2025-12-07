import UIKit
import AWEUIResources
import AWEUITheme

public final class SearchViewController: AWEBaseViewController {
    
    private let service: SearchServiceProtocol
    private let textField = UITextField()
    private let button = UIButton(type: .system)
    private let textView = UITextView()
    private let iconView = UIImageView()
    
    public init(service: SearchServiceProtocol) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
        self.title = "Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "输入关键词，例如: douyin"
        
        button.setTitle("搜索", for: .normal)
        button.addTarget(self, action: #selector(onSearch), for: .touchUpInside)
        
        textView.isEditable = false
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        
        // Search 私有 Icon（例如搜索 tab 的小图标）
        iconView.contentMode = .scaleAspectFit
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.image = SearchResources.searchTabIcon
        
        let stack = UIStackView(arrangedSubviews: [iconView, textField, button, textView])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc private func onSearch() {
        let keyword = textField.text ?? ""
        guard !keyword.isEmpty else { return }
        
        textView.text = "搜索中..."
        SearchLogger.log("search keyword: \(keyword)")
        
        service.search(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let models):
                self?.textView.text = models.map { $0.title }.joined(separator: "\n")
            case .failure(let error):
                self?.textView.text = "Error: \(error)"
            }
        }
    }
}
