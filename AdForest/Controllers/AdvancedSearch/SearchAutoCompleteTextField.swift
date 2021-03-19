//
//  SearchAutoCompleteTextField.swift
//  AdForest
//
//  Created by Apple on 9/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import MapKit


protocol SearchAutoDelegate {
    func searchAutoValue(searchAuto: String, fieldType: String, indexPath: Int,fieldTypeName:String,lat: Double, long: Double,NearByLong: String,nearByLat:String)
}

class SearchAutoCompleteTextField: UITableViewCell, UITextFieldDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate,CLLocationManagerDelegate,latLongitudePro {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var txtAutoComplete: UITextField! {
        didSet {
            txtAutoComplete.delegate = self
        }
    }
    
    //MARK:- Properties
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var fieldName = ""
    var delegate : SearchAutoDelegate?
    var index = 0
    var fieldTypeNam = "ad_location"
    var nearBYLat = "nearby_latitude"
    var nearByLong = "nearby_longitude"
//    var latitude = ""
//    var longitude = ""
    
    var latitude : Double!
    var longitude : Double!
    var fullAddress = ""
    let locationManager = CLLocationManager()
    var placesSearchType = UserDefaults.standard.bool(forKey: "placesSearchType")

    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        if UserDefaults.standard.bool(forKey: "isRtl") {
           txtAutoComplete.textAlignment = .right
        } else {
            txtAutoComplete.textAlignment = .left
        }
        //self.currentUserlocationManager()
        
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    //MARK:- Text Field Delegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if placesSearchType == true {
            loadPlacesorMapbox()
        }
        else{
            let searchVC = GMSAutocompleteViewController()
            searchVC.delegate = self
            self.window?.rootViewController?.present(searchVC, animated: true, completion: nil)
        }
    }
    
    // Google Places Delegate Methods
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place Name : \(place.name)")
       
        print("Place Address : \(place.formattedAddress ?? "null")")
        txtAutoComplete.text = place.formattedAddress
        self.delegate?.searchAutoValue(searchAuto:txtAutoComplete.text! , fieldType: "glocation_textfield", indexPath: index,fieldTypeName:fieldTypeNam,lat:  place.coordinate.latitude,long: place.coordinate.longitude,NearByLong: self.nearByLong,nearByLat: self.nearBYLat)
        self.appDel.dissmissController()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.appDel.dissmissController()
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.appDel.dissmissController()
    }

    func currentUserlocationManager(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.latitude =  locationManager.location?.coordinate.latitude
            self.longitude =  locationManager.location?.coordinate.longitude
            if (self.latitude != nil) && self.longitude != nil{
              getAddressFromLatLon(pdblLatitude: String(self.latitude), withLongitude: String(self.longitude))
            }
        }
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                    self.fullAddress = addressString
                    self.txtAutoComplete.text = addressString
                    self.delegate?.searchAutoValue(searchAuto:addressString , fieldType: "glocation_textfield", indexPath: self.index,fieldTypeName:self.fieldTypeNam,lat: center.latitude,long: center.longitude,NearByLong:self.nearByLong,nearByLat: self.nearBYLat)
                    
                }
        })
        
    }
    func loadPlacesorMapbox(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mapBoxPlaceVc = storyboard.instantiateViewController(withIdentifier: MapBoxPlacesViewController.className) as! MapBoxPlacesViewController
        mapBoxPlaceVc.delegate = self
        mapBoxPlaceVc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController!.present(mapBoxPlaceVc, animated: true, completion: nil)
 }
    func latLong(lat: String, long: String,place:String) {
        print(place)
        self.txtAutoComplete.text = place
        self.delegate?.searchAutoValue(searchAuto:place , fieldType: "glocation_textfield", indexPath: self.index,fieldTypeName:self.fieldTypeNam,lat:Double(lat)!,long: Double(long)!,NearByLong:self.nearByLong,nearByLat: self.nearBYLat)
    }


}
