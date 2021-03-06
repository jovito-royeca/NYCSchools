//
//  SchoolsMapViewController.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 02/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import FontAwesome_swift
import MapKit
import MBProgressHUD
import PromiseKit

class SchoolsMapViewController: UIViewController {

    // MARK: Variables
    let viewModel = SchoolsMapViewModel()
    
    /*
     * Name of school if we are selecting from School Details.
     * This lone school will be displayed
     */
    var schoolName = ""

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        viewModel.queryString = schoolName
        
        viewModel.fetchData()
        addPinsToMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.isEmpty() {
            fetchData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetails" {
            guard let dest = segue.destination as? SchoolDetailsViewController,
                let school = sender as? School else {
                    return
            }
            
            let viewModel = SchoolDetailsViewModel(withSchool: school)
            dest.viewModel = viewModel
        }
    }

    // MARK: Custom methods
    func addPinsToMap() {
        if let schools = viewModel.allObjects() {
            for school in schools {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: school.latitude, longitude: school.longitude)
                annotation.title = school.schoolName
                mapView.addAnnotation(annotation)
            }
            
            // center map to Central Park, NY
            var center = CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285)
            var region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            // if we have a schoolName location, center to it
            if schoolName.count > 0 {
                if let school = viewModel.allObjects()?.first {
                    center = CLLocationCoordinate2D(latitude: school.latitude, longitude: school.longitude)
                    region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
                }
            }
            mapView.setRegion(region, animated: true)
        }
    }

    /*
     * Fetch data from web API
     */
    func fetchData() {
        let webService = WebServiceAPI()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        firstly {
            when(fulfilled: webService.fetchSchools(), webService.fetchSATResults())
        }.done { schools, satResults in
            self.saveData(schools: schools, satResults: satResults)
        }.catch { error in
            print("\(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    /*
     * Save JSON to Core Data
     */
    func saveData(schools: [[String: Any]], satResults: [[String: Any]]) {
        firstly {
            CoreDataAPI.sharedInstance.saveSchools(json: schools)
        }.done {
            CoreDataAPI.sharedInstance.saveSATResults(json: satResults)
            self.viewModel.fetchData()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.addPinsToMap()
        }.catch { error in
            print("\(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

// MARK: MKMapViewDelegate
extension SchoolsMapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "school")
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.image = UIImage.fontAwesomeIcon(name: .school,
                                                       style: .solid,
                                                       textColor: UIColor.red,
                                                       size: CGSize(width: 20, height: 20))
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation,
            let name = annotation.title as? String,
            let school = viewModel.object(forName: name,
                                          latitude: annotation.coordinate.latitude,
                                          lontitude: annotation.coordinate.longitude) else {
            return
        }

        // show school in map
        performSegue(withIdentifier: "showDetails", sender: school)
    }
}
