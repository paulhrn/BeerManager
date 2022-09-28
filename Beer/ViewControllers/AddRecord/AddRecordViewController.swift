//
//  AddRecordVC.swift
//  UI
//
//  Created by p h on 06.09.2022.
//

import Foundation
import RealmSwift

class AddRecordViewController: UIViewController {
    
    typealias VoidHandler = () -> Void
    var didAdd: (() -> Void)?
    private var realm: Realm?
    
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var saveLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
        setupUI()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        guard let brand = brandTF.text,
              let country = countryTF.text,
              let price = Float(priceTF.text ?? "0"),
              let amount = Int(amountTF.text ?? "0") else { return }
        
        let beer = Beer()
        beer.brand = brand
        beer.country = country
        beer.price = price
        beer.amount = amount
        
        do {
            try realm?.write({
                realm?.add(beer)
            })
            dismiss(animated: true) { [weak self] in
                self?.didAdd?()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupUI() {
        let saveString = NSAttributedString(string: L10n.saveButton)
        brandTF.placeholder = L10n.brandPlaceholder
        countryTF.placeholder = L10n.countryPlaceholder
        priceTF.placeholder = L10n.pricePlaceholder
        amountTF.placeholder = L10n.amountPlaceholder
        saveLabel.setAttributedTitle(saveString, for: .normal)
    }
}
