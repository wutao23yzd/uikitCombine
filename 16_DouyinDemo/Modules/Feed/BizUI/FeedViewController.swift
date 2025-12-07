import UIKit
import AWELaunchKit
import AWEUIResources
import AWEUITheme

public final class FeedViewController: AWEBaseViewController {
    
    private let tableView = UITableView()
    private let feedService: FeedServiceProtocol
    private var items: [String] = []
    
    public init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
        super.init(nibName: nil, bundle: nil)
        self.title = "Feed"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupSearchButton()
        loadData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchButton() {
        let searchButton = UIBarButtonItem(title: "Search",
                                           style: .plain,
                                           target: self,
                                           action: #selector(onSearch))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func loadData() {
        items = feedService.loadFeedItems()
        tableView.reloadData()
    }
    
    @objc private func onSearch() {
        // 方式 1：通过 Router 打开 Search
        if let nav = navigationController {
            Router.shared.open("douyin://search", from: nav)
            return
        }
        
        // 方式 2：通过 Service 层转一手，用 SearchEntryProtocol
        if let searchEntry = feedService.searchEntry(),
           let nav = navigationController {
            let vc = searchEntry.makeSearchViewController()
            nav.pushViewController(vc, animated: true)
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
            ?? UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = items[indexPath.row]
        
        if let like = FeedResources.likeIcon {
            cell.accessoryView = UIImageView(image: like)
        }
        
        return cell
    }
}
