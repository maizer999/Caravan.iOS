//
//  MarvelAdDetailProfileCell.swift
//  AdForest
//
//  Created by Charlie on 30/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos
class MarvelAdDetailProfileCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.round()
        }
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var lblLastLoginTime: UILabel!
    @IBOutlet weak var btnBlockUser: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
            btnBlockUser.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)

            }
        }
    }
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var oltCoverButton: UIButton!
    //MARK:- Properties
    var btnCoverAction : (()->())?
    var btnBlock: (()->())?
    var btnUserProfileAction: (()->())?
    let defaults = UserDefaults.standard
    
    //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Custom
    func setupView() {
        if defaults.bool(forKey: "isRtl") {
            lblLastLoginTime.textAlignment = .right
            lblName.textAlignment = .left
        }
    }
    
    
    //MARK:- IBActions
    @IBAction func coverButtonAction(_ sender: Any) {
        self.btnCoverAction?()
    }
    @IBAction func actionDelete(_ sender: UIButton) {
        self.btnBlock?()
    }
    @IBAction func actionUserRating(_ sender: Any) {
        self.btnUserProfileAction?()
    }
    

}
