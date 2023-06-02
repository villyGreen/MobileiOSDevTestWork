import UIKit

final class ViewController: UIViewController {
    
    private let server = Server()
    private var model: [Deal] = []
    
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let sortTypeView = SortTypeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Deals"
        createSortTypeView()
        tableView.register(UINib(nibName: DealCell.reuseIidentifier, bundle: nil), forCellReuseIdentifier: DealCell.reuseIidentifier)
        tableView.register(UINib(nibName: HeaderCell.reuseIidentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIidentifier)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        server.subscribeToDeals { [weak self] deals in
            guard let self = self else { return }
            var sortedDeals = deals
            sortedDeals.sortedBy(self.sortTypeView.currentSortType,
                                 sortSide: self.sortTypeView.currentSortSide)
            self.model.append(contentsOf: sortedDeals)
            self.tableView.reloadData()
        }
    }
    
    @objc
    private func refresh() {
        model.sortedBy(sortTypeView.currentSortType,
                       sortSide: sortTypeView.currentSortSide)
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIidentifier, for: indexPath) as! DealCell
        cell.configure(with: model[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCell.reuseIidentifier) as! HeaderCell
        return cell
    }
}

// MARK: SortTypeView
extension ViewController {
    private func createSortTypeView() {
        sortTypeView.delegate = self
        sortTypeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortTypeView)
        let constant = 16.0
        NSLayoutConstraint.activate([
            sortTypeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant),
            sortTypeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            sortTypeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            sortTypeView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -constant)
        ])
    }
}

extension ViewController: SortTypeViewDelegate {
    func sortTypeViewWillSelectNewSort(_ sortTypeView: SortTypeView,
                                       sortType: SortType,
                                       sortSide: SortSide) {
        model.sortedBy(sortType, sortSide: sortSide)
        tableView.reloadData()
    }
}
