//
//  SchoolsListViewController.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit

class SchoolsListViewController: UIViewController {

    // MARK: Variables
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = SchoolsListViewModel()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        tableView.keyboardDismissMode = .onDrag
        
        viewModel.fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let dest = segue.destination as? SchoolDetailsViewController,
                let school = sender as? School else {
                return
            }
            
            let viewModel = SchoolDetailsViewModel(withSchool: school)
            dest.viewModel = viewModel
        }
    }

    @objc func doSearch() {
        viewModel.queryString = searchController.searchBar.text ?? ""
        viewModel.fetchData()
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension SchoolsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolCell",
                                                 for: indexPath)
        let school = viewModel.object(forRowAt: indexPath)
        
        cell.textLabel?.text = school.schoolName
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionIndexTitles()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionForSectionIndexTitle(title: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
}

// MARK: UITableViewDelegate
extension SchoolsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = viewModel.object(forRowAt: indexPath)
        performSegue(withIdentifier: "showDetails", sender: school)
    }
}

// MARK: UISearchResultsUpdating
extension SchoolsListViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doSearch), object: nil)
        perform(#selector(doSearch), with: nil, afterDelay: 0.5)
    }
}

// MARK: UISearchResultsUpdating
extension SchoolsListViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if viewModel.searchCancelled {
            searchBar.text = viewModel.queryString
        } else {
            viewModel.queryString = searchBar.text ?? ""
        }
    }
}
