//
//  SchoolDetailsViewController.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import FontAwesome_swift

class SchoolDetailsViewController: UIViewController {
    var viewModel: SchoolDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: UITableViewDataSource
extension SchoolDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.section {
        case SchoolDetailsViewModel.Sections.school.rawValue:
            switch indexPath.row {
            case SchoolDetailsViewModel.SchoolDetails.name.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "DynamicHeightCell",
                                                     for: indexPath)
                if let label = cell?.viewWithTag(100) as? UILabel {
                    label.text = viewModel.name()
                    label.font = UIFont.boldSystemFont(ofSize: 20)
                }
            case SchoolDetailsViewModel.SchoolDetails.address.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell",
                                                     for: indexPath)
                if let iconImage = cell?.viewWithTag(100) as? UIImageView,
                    let textLabel = cell?.viewWithTag(200) as? UILabel{
                    
                    iconImage.image = UIImage.fontAwesomeIcon(name: .mapMarkerAlt,
                                                              style: .solid,
                                                              textColor: UIColor.gray,
                                                              size: CGSize(width: 20, height: 20))
                    textLabel.text = viewModel.address()
                }
            case SchoolDetailsViewModel.SchoolDetails.phone.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell",
                                                     for: indexPath)
                if let iconImage = cell?.viewWithTag(100) as? UIImageView,
                    let textLabel = cell?.viewWithTag(200) as? UILabel{
                    
                    iconImage.image = UIImage.fontAwesomeIcon(name: .phone,
                                                              style: .solid,
                                                              textColor: UIColor.gray,
                                                              size: CGSize(width: 20, height: 20))
                    textLabel.text = viewModel.phone()
                }
            case SchoolDetailsViewModel.SchoolDetails.website.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell",
                                                     for: indexPath)
                if let iconImage = cell?.viewWithTag(100) as? UIImageView,
                    let textLabel = cell?.viewWithTag(200) as? UILabel{
                    
                    iconImage.image = UIImage.fontAwesomeIcon(name: .globe,
                                                              style: .solid,
                                                              textColor: UIColor.gray,
                                                              size: CGSize(width: 20, height: 20))
                    textLabel.text = viewModel.website()
                }
            default:
                ()
            }
        case SchoolDetailsViewModel.Sections.satResults.rawValue:
            switch indexPath.row {
            case SchoolDetailsViewModel.SATDetails.takers.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailCell",
                                                     for: indexPath)
                cell?.textLabel?.text = SchoolDetailsViewModel.SATDetails.takers.description
                cell?.detailTextLabel?.text = viewModel.numberOfSATTakers()
            case SchoolDetailsViewModel.SATDetails.mathematics.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailCell",
                                                     for: indexPath)
                cell?.textLabel?.text = SchoolDetailsViewModel.SATDetails.mathematics.description
                cell?.detailTextLabel?.text = viewModel.mathScore()
            case SchoolDetailsViewModel.SATDetails.reading.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailCell",
                                                     for: indexPath)
                cell?.textLabel?.text = SchoolDetailsViewModel.SATDetails.reading.description
                cell?.detailTextLabel?.text = viewModel.readingScore()
            case SchoolDetailsViewModel.SATDetails.writing.rawValue:
                cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailCell",
                                                     for: indexPath)
                cell?.textLabel?.text = SchoolDetailsViewModel.SATDetails.writing.description
                cell?.detailTextLabel?.text = viewModel.writingScore()
            default:
                ()
            }

        default:
            ()
        }
        
        return cell!
    }
}

// MARK: UITableViewDelegate
extension SchoolDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
