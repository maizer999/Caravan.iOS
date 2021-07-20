//
//  MapViewCell.swift
//  caravan
//
//  Created by salman sharif on 19/07/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import MapKit
import TextFieldEffects
import DropDown
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import NVActivityIndicatorView
import JGProgressHUD


class MapViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblUserinfo: UILabel!
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var txtNumber: HoshiTextField!
    @IBOutlet weak var containerViewPopup: UIView! {
        didSet {
            containerViewPopup.addShadowToView()
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var oltPopup: UIButton! {
        didSet {
            oltPopup.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var containerViewAddress: UIView!
    @IBOutlet weak var txtAddress: HoshiTextField!
    @IBOutlet weak var containerViewMap: UIView!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            
        }
    }
    @IBOutlet weak var txtLatitude: HoshiTextField!
    @IBOutlet weak var txtLongitude: HoshiTextField!
    @IBOutlet weak var containerViewFeatureAdd: UIView! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                containerViewFeatureAdd.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblFeatureAdd: UILabel!
    @IBOutlet weak var oltCheck: UIButton!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var oltPostAdd: UIButton! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltPostAdd.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var containerViewBumpUpAds: UIView! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                containerViewBumpUpAds.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgCheckBump: UIImageView!
    @IBOutlet weak var lblBumpText: UILabel!
    
    
    
    @IBOutlet weak var btnTermCondition: UIButton!
    @IBOutlet weak var txtTermCondition: UITextField!
    @IBOutlet weak var imgViewCheckBox: UIImageView!
    @IBOutlet weak var btnCheckBoxTermCond: UIButton!
        let defaults = UserDefaults.standard
    override func awakeFromNib() {
        super.awakeFromNib()
        if defaults.bool(forKey: "isRtl") {
            txtName.textAlignment = .right
            txtNumber.textAlignment = .right
            txtAddress.textAlignment = .right
            txtLatitude.textAlignment = .right
            txtLongitude.textAlignment = .right
            txtTermCondition.textAlignment = .right
            oltPopup.contentHorizontalAlignment = .right
        } else {
            txtName.textAlignment = .left
            txtNumber.textAlignment = .left
            txtAddress.textAlignment = .left
            txtLatitude.textAlignment = .left
            txtLongitude.textAlignment = .left
            txtTermCondition.textAlignment = .left
            oltPopup.contentHorizontalAlignment = .left
        }
        txtLatitude.isUserInteractionEnabled = false
        txtLongitude.isUserInteractionEnabled = false
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
