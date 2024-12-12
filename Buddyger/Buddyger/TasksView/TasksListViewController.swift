//
//  ViewController.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 30.11.24.
//

import UIKit
import Combine

class TasksListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tasksTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var viewModel: TasksListViewModelProtocol?
    private var refreshControl: UIRefreshControl?
    private var cancellables: [AnyCancellable] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupRefreshControl()
        setUpSearchBar()
        setUpTableView()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    private func setUpSearchBar() {
        searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpTableView() {
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskListConstants.taskCellIdentifier)
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.rowHeight = UITableView.automaticDimension
        tasksTableView.estimatedRowHeight = TaskListConstants.estimatedRowHeight
        tasksTableView.refreshControl = refreshControl
    }

    private func bindViewModel() {
        viewModel?.presentedTasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tasksTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    // MARK: - Action Methods
    @objc private func refreshData() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.viewModel?.authenticateAndFetchTasks()
                self.tasksTableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension TasksListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.presentedTasks.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tasksTableView.dequeueReusableCell(withIdentifier: TaskListConstants.taskCellIdentifier, for: indexPath) as? TaskTableViewCell,
              let task = viewModel?.presentedTasks.value[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: TaskCellModel(
            task: task.task ?? TaskListConstants.noTaskPlaceholder,
            title: task.title ?? TaskListConstants.noTitlePlaceholder,
            description: task.description ?? TaskListConstants.noDescriptionPlaceholder,
            colorCode: UIColor(hex: task.colorCode ?? "")
        ))
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension TasksListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchTasks(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel?.searchTasks(query: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
