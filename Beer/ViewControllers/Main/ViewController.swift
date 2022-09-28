//
//  ViewController.swift
//  UI copy
//
//  Created by p h on 18.05.22.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private var realm: Realm?
    var beerList: Results<Beer>? = try? Realm().objects(Beer.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addRecord: UIButton!
    @IBOutlet weak var calculations: UILabel!
    @IBOutlet weak var currentIncomeLabel: UIButton!
    @IBOutlet weak var newDayLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        realm = try? Realm()
        setupUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func currentincome(_ sender: Any) {
        guard let beerList = beerList else { return }
        let income = beerList.map{ Float($0.sold) * $0.price }.reduce(0, { $0 + $1 })
        calculations.text = "\(L10n.currentIncomeLabel) \(round(income * 100) / 100)\(L10n.currency)"
    }
    
    @IBAction func startnewday(_ sender: Any) {
        do {
            try realm?.write({
                beerList?.forEach{ $0.sold = 0 }
            })
        } catch {
            print(error.localizedDescription)
        }
        calculations.text = L10n.newDayLabel
    }
    
    @IBAction func didTapPlus(_ sender: UIButton) {
        let vc = AddRecordViewController.initial()
        vc.didAdd = { [weak self] in
            guard let self = self,
                  let beerList = self.beerList else { return }
            self.tableView.insertRows(at: [.init(row: beerList.count - 1, section: 0)], with: .automatic)
        }
        present(vc, animated: true)
    }
    
    private func setupUI() {
        let newDayString = NSAttributedString(string: L10n.newDayButton)
        let currentIncomeString = NSAttributedString(string: L10n.currentIncomeButton)
        searchBar.placeholder = L10n.searchBarPlaceholder
        calculations.text = L10n.tapToSell
        newDayLabel.setAttributedTitle(newDayString, for: .normal)
        currentIncomeLabel.setAttributedTitle(currentIncomeString, for: .normal)
    }
    
    private func search(_ searchString: String) {
        let predicate = NSPredicate(format: "brand BEGINSWITH [c]%@", searchString)
        do {
            if searchString.isEmpty {
                beerList = try Realm().objects(Beer.self)
            } else {
                beerList = try Realm().objects(Beer.self).filter(predicate).sorted(by: \.brand, ascending:  true)
            }
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchString = searchBar.text else { return }
        search(searchString)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        guard let item = beerList?[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = "\(item.brand), \(item.country) – \(item.price)\(L10n.currency)"
        cell.detailTextLabel?.text = "\(L10n.beerLeft): \(item.amount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if beerList?.count == 0 {
            calculations.text = "Tap \"+\" to add beer"
        }
        return beerList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = beerList?[indexPath.row] else { return }
        do {
            if item.amount >= 1 {
                try realm?.write({
                    item.amount -= 1
                    item.sold += 1
                })
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = beerList?[indexPath.row] else { return }
            do {
                try realm?.write({
                    realm?.delete(item)
                })
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension UIViewController {
    static func initial() -> Self {
        let className = String(describing: self)
        
        let name = className.replacingOccurrences(of: "ViewController", with: "").replacingOccurrences(of: "Controller", with: "")
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return instanceInitial(from: storyboard)
    }
    
    //MARK: - Private
    private class func instanceInitial<T: UIViewController>(from storyboard: UIStoryboard) -> T {
        return storyboard.instantiateInitialViewController() as! T
    }
}

