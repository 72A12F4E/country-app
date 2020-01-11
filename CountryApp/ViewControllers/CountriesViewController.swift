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
    
    lazy var dataSource = UITableViewDiffableDataSource<Section, Country>(tableView: tableView) { (tableView, indexPath, country) -> UITableViewCell? in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.nativeName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .secondarySystemBackground
        dataSource.defaultRowAnimation = .fade
        
        CountryAPI.fetchCountries()
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink { countries in
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

