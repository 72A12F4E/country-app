//
//  CountryDetailsViewController.swift
//  CountryApp
//
//  Created by Blake McAnally on 1/2/20.
//  Copyright © 2020 Blake McAnally. All rights reserved.
//

import UIKit

// TODO: modernize to diffable data sources

class CountryDetailsViewController: UITableViewController {

    enum Section: Int, CaseIterable {
        case main
        case currencies
        case languages
        case translations
        case regionalBlocs
    }
    
    var country: Country? {
        didSet {
            self.title = country?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return "" }
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let country = country else { return 0 }
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .main:
            return 20
        case .languages:
            return country.languages.count
        case .currencies:
            return country.currencies.count
        case .regionalBlocs:
            return country.regionalBlocs.count
        case .translations:
            return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = Section(rawValue: indexPath.section)!
        
        if case .main = section {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = country?.name
            case 1:
                cell.textLabel?.text = "Top Level Domains"
                cell.detailTextLabel?.text = country?.topLevelDomain.reduce("", { result, next in
                    return result + " " + next
                })
            case 2:
                cell.textLabel?.text = "Alpha 2 Code"
                cell.detailTextLabel?.text = country?.alpha2Code
            case 3:
                cell.textLabel?.text = "Alpha 3 Code"
                cell.detailTextLabel?.text = country?.alpha3Code
            case 4:
                cell.textLabel?.text = "Calling Codes"
                cell.detailTextLabel?.text = country?.callingCodes.reduce("", { result, next in
                    return result + " " + next
                })
            case 5:
                cell.textLabel?.text = "Capital"
                cell.detailTextLabel?.text = country?.name
            case 6:
                cell.textLabel?.text = "Alternate Spellings"
                cell.detailTextLabel?.text = country?.name
            case 7:
                cell.textLabel?.text = "Region"
                cell.detailTextLabel?.text = country?.region
            case 8:
                cell.textLabel?.text = "Subregion"
                cell.detailTextLabel?.text = country?.subregion
            case 9:
                cell.textLabel?.text = "Population"
                cell.detailTextLabel?.text = country?.population.description
            case 10:
                cell.textLabel?.text = "Coordinates"
                cell.detailTextLabel?.text = country?.latlng.description
            case 11:
                cell.textLabel?.text = "Demonym"
                cell.detailTextLabel?.text = country?.demonym
            case 12:
                cell.textLabel?.text = "Area"
                cell.detailTextLabel?.text = country?.area?.description
            case 13:
                cell.textLabel?.text = "GINI Index"
                cell.detailTextLabel?.text = country?.gini?.description
            case 14:
                cell.textLabel?.text = "Timezones"
                cell.detailTextLabel?.text = country?.timezones.reduce("", { result, next in
                    return result + " " + next
                })
            case 15:
                cell.textLabel?.text = "Neighboring Countries"
                cell.detailTextLabel?.text = country?.borders.reduce("") { result, next in
                    return result + " " + next
                }
            case 16:
                cell.textLabel?.text = "Native Name"
                cell.detailTextLabel?.text = country?.nativeName
            case 17:
                cell.textLabel?.text = "Numeric Code"
                cell.detailTextLabel?.text = country?.numericCode
            case 18:
                cell.textLabel?.text = "Flag"
                cell.detailTextLabel?.text = country?.flag
            case 19:
                cell.textLabel?.text = "CIOC"
                cell.detailTextLabel?.text = country?.cioc
            default: break;
            }
        } else if case .languages = section {
            let language = country?.languages[indexPath.row]
            cell.textLabel?.text = language?.name
            cell.detailTextLabel?.text = language?.nativeName
        } else if case .currencies = section {
            let currency = country?.currencies[indexPath.row]
            cell.textLabel?.text = currency?.name
            cell.detailTextLabel?.text = currency?.symbol
        } else if case .regionalBlocs = section {
            let regionalBloc = country?.regionalBlocs[indexPath.row]
            cell.textLabel?.text = regionalBloc?.name
            cell.detailTextLabel?.text = ""
        } else if case .translations = section {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "German"
                cell.detailTextLabel?.text = country?.translations.de
            case 1:
                cell.textLabel?.text = "Spanish"
                cell.detailTextLabel?.text = country?.translations.es
            case 2:
                cell.textLabel?.text = "French"
                cell.detailTextLabel?.text = country?.translations.fr
            case 3:
                cell.textLabel?.text = "Japanese"
                cell.detailTextLabel?.text = country?.translations.ja
            case 4:
                cell.textLabel?.text = "Italian"
                cell.detailTextLabel?.text = country?.translations.it
            case 5:
                cell.textLabel?.text = "TODO"
                cell.detailTextLabel?.text = country?.translations.br
            case 6:
                cell.textLabel?.text = "TODO"
                cell.detailTextLabel?.text = country?.translations.pt
            case 7:
                cell.textLabel?.text = "TODO"
                cell.detailTextLabel?.text = country?.translations.nl
            case 8:
                cell.textLabel?.text = "TODO"
                cell.detailTextLabel?.text = country?.translations.hr
            case 9:
                cell.textLabel?.text = "TODO"
                cell.detailTextLabel?.text = country?.translations.fa
            default: break;
            }
        }
        
        return cell
    }
}


extension CountryDetailsViewController.Section {
    var title: String {
        switch self {
        case .main:
            return "General"
        case .currencies:
            return "Currencies"
        case .languages:
            return "Languages"
        case .translations:
            return "Translations"
        case .regionalBlocs:
            return "Regional Blocs"
        }
    }
}
