//
//  ViewController.swift
//  CountryApp
//
//  Created by Blake McAnally on 1/2/20.
//  Copyright © 2020 Blake McAnally. All rights reserved.
//

import UIKit
import Combine

final class CountriesViewController: UITableViewController {

    enum Section: CaseIterable {
        case main
    }
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, Country>(tableView: tableView) { (tableView, indexPath, country) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.nativeName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private var countries: [Country] = []
    @Published private var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        
        tableView.backgroundColor = .secondarySystemBackground
        dataSource.defaultRowAnimation = .fade
        
        CountryAPI.fetchCountries()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.countries, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest($countries, $searchText)
            .map { countries, searchText -> [Country] in
                guard searchText != "" else { return countries }
                return countries.filter { country in
                    country.name.contains(searchText)
                }
            }.sink { countries in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
                snapshot.appendSections([.main])
                snapshot.appendItems(countries, toSection: .main)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let country = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: "CountryDetailsViewController") as? CountryDetailsViewController else { return }
        detailsViewController.country = country
        
        self.show(detailsViewController, sender: nil)
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}
