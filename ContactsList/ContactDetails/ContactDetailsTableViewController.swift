//
//  ContactDetailsTableViewController.swift
//  ContactsList
//
//  Created by Ramirez, Edgar on 5/9/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import UIKit

struct CellContent {
    let phoneNumberType: String?
    let title: String
    let subtitle: String
}

class ContactDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var completionHandler:((_ newIsFavorite: Bool) -> ())?
    var contact: Contact?
    lazy var cellContentArray: [CellContent]? = []
    lazy var imagesCache: [String: UIImage]? = [:]
    let networkingAPI = NetworkingAPI();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contact, let isFavorite = contact.isFavorite {
            toggleFavoriteButtonImage(isFavorite)
            cellContentArray = createCellsContent(contact)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 250.0 : 100.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (cellContentArray!.count + 1) // Trade-off: Extra row because of header at row 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? DetailsHeaderTableViewCell
            
            cell?.nameLabel.text = contact?.name ?? "N/A"
            cell?.companyLabel.text = contact?.companyName ?? "N/A"
            
            if let url = contact?.largeImageURL {
                if imagesCache![url] == nil {
                    networkingAPI.getDataFromURL(endpoint: url) { [weak self] (data, response, error) in
                        guard let strongSelf = self else { return }
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            
                            strongSelf.imagesCache![url] = image
                            cell?.largeImageView.image = image
                        }
                    }
                } else {
                    cell?.largeImageView.image = imagesCache![url]
                }
            } else {
                cell?.largeImageView.image = UIImage(named: "User — Large")
            }
            
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! DetailsTableViewCell
            
            let cellContent = cellContentArray![indexPath.row - 1]
            
            cell.titleLabel.text = cellContent.title
            cell.contentLabel.text = cellContent.subtitle
            if let phoneNumberType = cellContent.phoneNumberType {
                cell.phoneTypeLabel.text = phoneNumberType
            } else {
                cell.phoneTypeLabel.isHidden = true
            }
            
            return cell
        }
    }
    
    @IBAction func onButtonTap() {
        if let contact = contact {
            let newIsFavorite = !(contact.isFavorite ?? false)
            
            toggleFavoriteButtonImage(newIsFavorite)
            self.completionHandler?(newIsFavorite)
        }
    }
    
    // Private functions
    private func toggleFavoriteButtonImage(_ isFavorite: Bool) {
        rightBarButton.image = UIImage(named: (isFavorite ? "Favorite Star (True)" : "Favorite Star (False)"))
    }
    
    // Public
    public func createCellsContent(_ contact: Contact?) -> [CellContent] {
        guard let contact = contact else { return [] }
        let contactMirror = Mirror(reflecting: contact)
        var cellsContent: [CellContent] = []
        
        for (name, value) in contactMirror.children {
            guard let name = name else { return [] }
            
            if let value = value as? String, value.count > 0 {
                switch name {
                case "birthdate":
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.date(from: value)!
                    
                    dateFormatter.dateStyle = .medium
                    
                    cellsContent.append(CellContent(phoneNumberType: nil, title: "\(name):".uppercased(), subtitle: dateFormatter.string(from: formattedDate)))
                case "id", "isFavorite", "smallImageURL", "largeImageURL", "name", "companyName":
                    break
                case "emailAddress":
                    cellsContent.append(CellContent(phoneNumberType: nil, title: "EMAIL:", subtitle: value))
                default:
                    break
                }
            } else if let value = value as? [String: String] {
                switch name {
                case "phone":
                    for (phoneType, phoneNumber) in value {
                        if phoneNumber.count > 0 {
                            cellsContent.append(CellContent(phoneNumberType: phoneType.capitalized, title: "\(name):".uppercased(), subtitle: phoneNumber))
                        }
                    }
                case "address":
                    let fullAddress = "\(value["street"] ?? "")\n\(value["city"] ?? ""), \(value["state"] ?? "") \(value["zipCode"] ?? ""), \(value["country"] ?? "")"
                    
                    cellsContent.append(CellContent(phoneNumberType: nil, title: "\(name):".uppercased(), subtitle: fullAddress))
                default:
                    break
                }
            }
        }
        return cellsContent
    }

}
