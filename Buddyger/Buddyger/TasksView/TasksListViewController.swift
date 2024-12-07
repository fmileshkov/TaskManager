//
//  ViewController.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 30.11.24.
//

import UIKit
import Combine

class TasksListViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: TasksListViewModel?
    private var refreshControl: UIRefreshControl?
    private var cancellables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupRefreshControl()
        setUpSearchBar()
        setUpTableView()
        viewModel?.fetchTasks()
        bindViewModel()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpTableView() {
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.rowHeight = UITableView.automaticDimension
        tasksTableView.estimatedRowHeight = 44
        tasksTableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel?.$presentedTasks
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.tasksTableView.reloadData()
                }
                .store(in: &cancellables)
        TaskManager.shared.$searchTextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] query in
                self?.viewModel?.searchTasks(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.viewModel?.fetchTasks()
                self.tasksTableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
}

extension TasksListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.presentedTasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tasksTableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell,
              let task = viewModel?.presentedTasks[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(task: task.task ?? "no task",
                       title: task.title ?? "no title",
                       description: task.description ?? "no description",
                       colorCode: UIColor(hex: task.colorCode ?? ""))
        
        return cell
    }
    
}

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
