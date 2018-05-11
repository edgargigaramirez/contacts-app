//
//  MainViewController.swift
//  ContactsList
//
//  Created by Ramirez, Edgar on 5/9/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let FAVS_SECTION = "favs"
    let UNFAVS_SECTION = "unfavs"
    let CELL_ID = "regularCellId"
    
    let networkingAPI = NetworkingAPI();

    var tableContacts: [String: [Contact]] = [:]
    lazy var imagesCache: [String: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactsAPI = ContactsAPI()
        contactsAPI.getContacts { [weak self] (contacts, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.domain, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
                
                return
            }
            if let freshContacts = contacts {
                let (favoriteContacts, unfavoriteContacts) = strongSelf.splitByFavorites(freshContacts)
                
                strongSelf.tableContacts[strongSelf.FAVS_SECTION] = strongSelf.sortContactsAlphabetically(favoriteContacts)
                strongSelf.tableContacts[strongSelf.UNFAVS_SECTION] = strongSelf.sortContactsAlphabetically(unfavoriteContacts)
                
                DispatchQueue.main.async {[weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableContacts.keys.count > 0 {
            let favs = tableContacts[FAVS_SECTION]!
            let unfavs = tableContacts[UNFAVS_SECTION]!
            let (favoriteContacts, unfavoriteContacts) = splitByFavorites(favs + unfavs)
            
            tableContacts[FAVS_SECTION] = sortContactsAlphabetically(favoriteContacts)
            tableContacts[UNFAVS_SECTION] = sortContactsAlphabetically(unfavoriteContacts)
            
            tableView.reloadData()
        }
    }

    // UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableContacts[(section == 0) ? FAVS_SECTION : UNFAVS_SECTION]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return (section == 0) ? "Favorite Contacts" : "Other Contacts"
    }
    
    // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? ContactTableViewCell
        let contact = self.tableContacts[(indexPath.section == 0) ? FAVS_SECTION : UNFAVS_SECTION]![indexPath.row]
        
        cell?.nameLabel.text = contact.name
        cell?.companyLabel.text = contact.companyName
        cell?.favoriteLabel.isHidden = !(contact.isFavorite ?? false)
        
        // FIXME: Cache UIImage
        if let url = contact.smallImageURL {
            if imagesCache[url] == nil {
                networkingAPI.getDataFromURL(endpoint: url) { [weak self] (data, response, error) in
                    guard let strongSelf = self else { return }
                    if let error = error {
                        print(error)
                        cell?.smallImageView.image = UIImage(named: "User Icon Small")
                    }
                    guard let data = data, error == nil else { return }
                    print("Downloading... \(url)")
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        
                        strongSelf.imagesCache[url] = image
                        cell?.smallImageView.image = image
                    }
                }
            } else {
                print("Caching...")
                cell?.smallImageView.image = imagesCache[url]
            }
        } else {
            cell?.smallImageView.image = UIImage(named: "User Icon Small")
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? ContactDetailsTableViewController else { return }
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        guard let contact = self.tableContacts[(indexPath.section == 0) ? FAVS_SECTION : UNFAVS_SECTION]?[indexPath.row] else { return }
        
        nextVC.contact = contact
        nextVC.completionHandler = { (newIsFavorite) in
            contact.isFavorite = newIsFavorite
        }
    }
    
    // Public
    public func sortContactsAlphabetically(_ contacts: [Contact]?) -> [Contact] {
        guard let contacts = contacts else { return [] }
        
        return contacts.sorted(by: { $0.name! < $1.name! })
    }
    
    public func splitByFavorites(_ contacts: [Contact]?) -> ([Contact], [Contact]) {
        guard let contacts = contacts else { return ([], []) }
        let favoriteContacts = contacts.filter { $0.isFavorite ?? false }
        let unfavoriteContacts = contacts.filter { !($0.isFavorite ?? false) }
        
        return (favoriteContacts, unfavoriteContacts)
    }

}

