//
//  BreweriesViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 12/20/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit
import MapKit

class BreweriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var initialLocation = CLLocation(latitude: 35.611582, longitude: 139.626778)
    let regionRadius: CLLocationDistance = 500
    
    fileprivate var annotationsArray: Array<Annotation> = Array<Annotation>()
    
    fileprivate class Annotation: NSObject, MKAnnotation {
        
        fileprivate var title: String?
        fileprivate var coordinate: CLLocationCoordinate2D
        
        
        init(title:String?, coordinate: CLLocationCoordinate2D)
        {
            self.title = title
            self.coordinate = coordinate
            
            
            super.init()
        }
        
    }
    
    fileprivate var locationsArray: Array<LocationObject> = [LocationObject(locationName: "iBeer", cityLocation: "Futakotamagawa, Tokyo", location: CLLocation(latitude: 35.6114574, longitude: 139.63097870000001), locationDescription: "Nested in the hills of Otkai mountains. this brewery...", stars: "★★★★", locationType: "Stand Up Bar"), LocationObject(locationName: "Futakotamagawa, Tokyo", cityLocation: "FutakoTamagawa", location: CLLocation(latitude: 35.611582, longitude: 139.626778), locationDescription: "", stars: "★★★★", locationType: "Train Station"), LocationObject(locationName: "Nigaata Prefecture", cityLocation: "Fujimoto Saka Gura", location: CLLocation(latitude: 34.5703443, longitude: 135.598957), locationDescription: "Nested in the hills of Otkai mountains, this brewery...", stars: "★★★★", locationType: ""), LocationObject(locationName: "Nigaata Prefecture", cityLocation: "Fujimoto Saka Gura", location: CLLocation(latitude: 34.5703443, longitude: 135.598957), locationDescription: "Nested in the hills of Otkai mountains, this brewery...", stars: "★★★★", locationType: ""), LocationObject(locationName: "Nigaata Prefecture", cityLocation: "Fujimoto Saka Gura", location: CLLocation(latitude: 34.5703443, longitude: 135.598957), locationDescription: "Nested in the hills of Otkai mountains, this brewery...", stars: "★★★★", locationType: "")]
    
    fileprivate var filteredLocationsArray: Array<LocationObject>? = [LocationObject(locationName: "iBeer", cityLocation: "Futakotamagawa, Tokyo", location: CLLocation(latitude: 35.6114574, longitude: 139.63097870000001), locationDescription: "Nested in the hills of Otkai mountains. this brewery...", stars: "★★★★", locationType: "Stand Up Bar"), LocationObject(locationName: "Futakotamagawa, Tokyo", cityLocation: "FutakoTamagawa", location: CLLocation(latitude: 35.611582, longitude: 139.626778), locationDescription: "", stars: "★★★★", locationType: "Train Station"), LocationObject(locationName: "Nigaata Prefecture", cityLocation: "Fujimoto Saka Gura", location: CLLocation(latitude: 34.5703443, longitude: 135.598957), locationDescription: "Nested in the hills of Otkai mountains, this brewery...", stars: "★★★★", locationType: ""), LocationObject(locationName: "Nigaata Prefecture", cityLocation: "Fujimoto Saka Gura", location: CLLocation(latitude: 34.5703443, longitude: 135.598957), locationDescription: "Nested in the hills of Otkai mountains, this brewery...", stars: "★★★★", locationType: ""), LocationObject(locationName: "Nigaata Prefecture", cityLocation: "Fujimoto Saka Gura", location: CLLocation(latitude: 34.5703443, longitude: 135.598957), locationDescription: "Nested in the hills of Otkai mountains, this brewery...", stars: "★★★★", locationType: "")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            self.manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            present(alertController, animated: true, completion: nil)
        default:
            getLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationsTableView.register(UINib(nibName: "BarsMapTableViewCell", bundle: nil), forCellReuseIdentifier: "BarsMapTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - MAP VIEW
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            //annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "bottle_in_circle_icon")
        }
        
        return annotationView
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

        return 100
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

            return 1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BarsMapTableViewCell", for: indexPath)as? BarsMapTableViewCell
        {
            let currentSpot = self.locationsArray[indexPath.row]
            
            cell.barNameLabel.text = currentSpot.locationType
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""
        {
            self.filterContentFor(searchText: searchText)
        }
        else
        {
            self.filteredLocationsArray = self.locationsArray
        }
        
        self.locationsTableView.reloadData()
    }
    
    
    func filterContentFor(searchText: String)
    {
        if self.locationsArray.count <= 0
        {
            self.filteredLocationsArray = nil
            return
        }
        
        self.filteredLocationsArray = self.locationsArray.filter({(location: LocationObject) -> Bool in
            
            return location.name.lowercased().range(of: searchText.lowercased()) != nil
        
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager.stopUpdatingLocation()
        if let location = manager.location
        {
            print(location.coordinate)
            self.initialLocation = location
            self.resetMap()
            
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func resetMap()
    {
        self.geoCoder.reverseGeocodeLocation(self.initialLocation, completionHandler: {(placemarks, error) -> Void in
            
            if let placemark = placemarks?.first
            {
                
                
                print(placemark.addressDictionary?["Thoroughfare"])
                print(placemark.name)
                print(placemark.administrativeArea)
                print(placemark.subAdministrativeArea)
                print(placemark.subLocality)
                print(placemark.addressDictionary?["City"])
                
                self.mapView.removeAnnotations(self.annotationsArray)
                
                self.locationsArray[0] = LocationObject(locationName: "My Location", cityLocation: "\(placemark.subAdministrativeArea), \(placemark.administrativeArea)" , location: self.initialLocation, locationDescription: "Nested in the hills of Otkai mountains. this brewery...", stars: "★★★★", locationType: "ME")
                
                self.annotationsArray = []
                
                self.centerMapOnLocation(location: self.initialLocation)
                
                for annotation in self.locationsArray
                {
                    let thisAnnotation = Annotation(title: annotation.name, coordinate: annotation.coordinate)
                    self.annotationsArray.append(thisAnnotation)
                    
                }
                
                self.mapView.addAnnotations(self.annotationsArray)
            }
            
        })
        
    }
    
    func getLocation()
    {
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.startUpdatingLocation()
    }

}
