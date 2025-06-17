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
    var onDone: (() -> Void)?  // Callback for dismissal

    private let tableView = UITableView()
    private let doneButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Configure table view
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)

        // Configure Done button
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        addSubview(doneButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonHeight: CGFloat = 44
        doneButton.frame = CGRect(x: 0, y: bounds.height - buttonHeight, width: bounds.width, height: buttonHeight)
        tableView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - buttonHeight)
    }

    @objc private func doneTapped() {
        onDone?()
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

        if selectedItems.contains(item) {
            selectedItems.remove(item)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedItems.insert(item)
        }

        onSelectionChanged?(selectedItems)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
