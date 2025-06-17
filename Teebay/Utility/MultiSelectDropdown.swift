//
//  MultiSelectDropdown.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 17/6/25.
//

import UIKit

class MultiSelectDropdown: UIView, UITableViewDelegate, UITableViewDataSource {

    var items: [String] = []
    var selectedItems: Set<String> = []

    var onSelectionChanged: ((Set<String>) -> Void)?

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = self.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(tableView)
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        cell.accessoryType = selectedItems.contains(item) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selectedItems.insert(item)
        onSelectionChanged?(selectedItems)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selectedItems.remove(item)
        onSelectionChanged?(selectedItems)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
