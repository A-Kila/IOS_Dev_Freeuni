//
//  ViewController.swift
//  Project_4
//
//  Created by Andria Kilasonia on 28.12.21.
//

import UIKit

extension Array {
    
    func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = self.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            
            if isOrderedBefore(self[mid], elem) {
                low = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                high = mid - 1
            } else {
                return mid
            }
        }
        
        return low
    }
    
}

class MainTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoritesButton: UIBarButtonItem!
    
    var tableData = [Character : [CustomCellModel]]()
    var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        registerCells()
        addPremadeContacts()
    }
    
    private func registerCells() {
        tableView.register(
            UINib(nibName: "CustomCell", bundle: nil),
            forCellReuseIdentifier: "CustomCell"
        )
        tableView.register(
            UINib(nibName: "BasicHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "BasicHeader"
        )
    }
    
    private func addPremadeContacts() {
        addContact(model: CustomCellModel(
            firstName: "LoL",
            lastName: "ALeL",
            phoneNumber: "696969",
            delegate: self
        ))
        addContact(model: CustomCellModel(
            firstName: "LuL",
            lastName: "ALaL",
            phoneNumber: "420420",
            delegate: self
        ))
        addContact(model: CustomCellModel(
            firstName: "LoLoL",
            lastName: "LeLa",
            phoneNumber: "121212",
            isFavorite: true,
            delegate: self
        ))
    }
    
    private func addContact(model: CustomCellModel) {
        let key = getKey(withModel: model)
        
        var section: Int? = nil
        if tableData[key] == nil {
            tableData.updateValue([CustomCellModel](), forKey: key)
            section = getSectionIndex(withKey: key)
            tableView.insertSections(IndexSet(integer: section!), with: .automatic)
        }
            
        let index = tableData[key]!.insertionIndexOf(model) { a, b in
            let aValue = a.lastName != "" ? a.lastName! : a.firstName
            let bValue = b.lastName != "" ? b.lastName! : b.firstName
            
            return aValue.uppercased() < bValue.uppercased()
        }
        
        tableData[key]!.insert(model, at: index)
        if section == nil {
            section = getSectionIndex(withKey: key)
        }
        let indexPath = IndexPath(row: index, section: section!)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func getKey(withModel model: CustomCellModel) -> Character {
        let char = model.lastName != "" ? model.lastName! : model.firstName
        
        return char.uppercased().first!
    }
    
    private func getKey(firstName: String, lastName: String?) -> Character {
        let model = CustomCellModel(firstName: firstName, lastName: lastName, phoneNumber: "")
        
        return getKey(withModel: model)
    }
    
    private func getSectionIndex(withKey key: Character) -> Int? {
        return tableData.sorted(by: { a, b in a.key < b.key })
            .firstIndex(where: { section in section.key == key })
    }
    
    @IBAction func handleAdd() {
        let alert = UIAlertController(
            title: "New Contact",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField() { textFeild in
            textFeild.placeholder = "First Name"
        }
        alert.addTextField() { textFeild in
            textFeild.placeholder = "Last Name"
        }
        alert.addTextField() { textFeild in
            textFeild.placeholder = "Phone Number"
            textFeild.keyboardType = .phonePad
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let textFeilds = alert.textFields else { return }
            guard textFeilds[0].text != "" else { return }
            guard textFeilds[2].text != "" else { return }

            self.addContact(model: CustomCellModel(
                firstName: textFeilds[0].text!,
                lastName: textFeilds[1].text,
                phoneNumber: textFeilds[2].text!,
                delegate: self
            ))
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showFavorites() {
        isFavorite.toggle()
        
        let imageString = "star\(isFavorite ? ".fill" : "")"
        favoritesButton.image = UIImage(systemName: imageString)
        
        tableView.reloadData()
    }

}

extension MainTableViewController: CustomCellDelegate {
    
    func toggleFavorite(_ firstName: String, _ lastName: String?) {
        let sectionKey = getKey(firstName: firstName, lastName: lastName)
        
        var index: Int? = nil
        for (i, cell) in tableData[sectionKey]!.enumerated() {
            if cell.firstName == firstName && cell.lastName == lastName {
                index = i
            }
        }
        
        guard let index = index else { return }
        tableData[sectionKey]![index].isFavorite.toggle()
    }
    
}

extension MainTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    private var favoriteData: [Character : [CustomCellModel]] {
        return tableData.filter() { _, value in
            return getFavoritesInRow(value).count > 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let data = isFavorite ? favoriteData : tableData
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCells = getSectionCells(sectionID: section)
        
        return sectionCells.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
       
        let sectionCells = getSectionCells(sectionID: indexPath.section)
        let cellModel = sectionCells[indexPath.row]
        
        if let customCell = cell as? CustomCell {
            customCell.configure(with: cellModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BasicHeader")
        
        let key = getKey(withSection: section)
        let model = BasicHeaderModel(title: key.description)

        if let basicHeader = header as? BasicHeader {
            basicHeader.configure(model: model)
        }

        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if isFavorite { return nil }
            
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
                self.deleteCell(at: indexPath)
            })
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    private func getFavoritesInRow(_ section: [CustomCellModel]) -> [CustomCellModel] {
        return section.filter() { model in
            return model.isFavorite
        }
    }
    
    private func getKey(withSection section: Int) -> Character {
        let data = isFavorite ? favoriteData : tableData
        
        let sectionData = data.sorted() { a, b in
            return a.key < b.key
        }[section]
        
        return sectionData.key
    }
    
    private func getSectionCells(sectionID section: Int) -> [CustomCellModel] {
        let data = isFavorite ? favoriteData : tableData
        
        let sectionData = data.sorted(by: { a, b in a.key < b.key })[section]
    
        return isFavorite ? getFavoritesInRow(sectionData.value) : sectionData.value
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        let sectionCells = getSectionCells(sectionID: indexPath.section)
        
        let key = getKey(withSection: indexPath.section)
        if sectionCells.count == 1 {
            tableData.removeValue(forKey: key)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableData[key]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
