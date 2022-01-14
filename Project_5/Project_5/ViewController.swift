//
//  ViewController.swift
//  Project_5
//
//  Created by Andria Kilasonia on 13.01.22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var dbContext = DBManager.shared.persistentContainer.viewContext
    
    lazy var contacts = [Contact]()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        return flow
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchContacts()
        dbContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    private func configureCollectionView() {
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            UINib(nibName: "CustomCell", bundle: nil),
            forCellWithReuseIdentifier: "CustomCell"
        )
        
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleDelete)
        )
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleDelete(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            let contact = contacts[indexPath.row]
            
            let alert = UIAlertController(
                title: "Delete Contact?",
                message: "Contact \(contact.name) will be deleted",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { [unowned self] _ in deleteContact(contact) }
            ))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteContact(_ contact: Contact) {
        dbContext.delete(contact)
        
        do {
            try dbContext.save()
            fetchContacts()
        } catch {}
    }
    
    private func fetchContacts() {
        let request = Contact.fetchRequest() as NSFetchRequest<Contact>
        
        do {
            contacts = try dbContext.fetch(request)
            collectionView.reloadData()
        } catch {}
    }
    
    @IBAction func handleAdd() {
        let alert = UIAlertController(
            title: "Add Contact",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField() { textFeild in
            textFeild.placeholder = "Name"
        }
        alert.addTextField() { textFeild in
            textFeild.placeholder = "Phone Number"
            textFeild.keyboardType = .phonePad
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let textFeilds = alert.textFields else { return }
            guard let name = textFeilds[0].text, !name.isEmpty else { return }
            guard let phoneNumber = textFeilds[1].text, phoneNumber != "" else { return }
            
            addContact(name: name, phoneNumber: phoneNumber)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addContact(name: String, phoneNumber: String) {
        let contact = Contact(context: dbContext)
        contact.name = name
        contact.phoneNumber = phoneNumber
        
        do {
            try dbContext.save()
            fetchContacts()
        } catch {}
    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return contacts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomCell",
            for: indexPath
        )
        
        if let customCell = cell as? CustomCell {
            let contact = contacts[indexPath.row]
            customCell.configure(with: CustomCellModel(
                name: contact.name,
                phoneNumber: contact.phoneNumber
            ))
        }
        
        return cell
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let contextWidth = collectionView.frame.width - 2 * Consts.itemInset
        let count = CGFloat(Int((contextWidth + Consts.itemInset) / (Consts.itemMinWidth + Consts.itemInset)))
        
        let width = (contextWidth - (count - 1) * Consts.itemInset) / count
        
        return CGSize(width: width, height: width * Consts.itemHeightOverWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Consts.itemInset,
            left: Consts.itemInset,
            bottom: 0,
            right: Consts.itemInset
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Consts.itemInset
    }
    
}


extension ViewController {
    
    private struct Consts {
        static let itemInset: CGFloat = 20
        static let itemHeightOverWidth: CGFloat = 4 / 3
        static let itemMinWidth: CGFloat = 90
    }
    
}
