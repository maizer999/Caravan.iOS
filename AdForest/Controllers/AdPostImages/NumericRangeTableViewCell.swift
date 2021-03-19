//
//  NumericRangeTableViewCell.swift
//  AdForest
//
//  Created by Furqan Nadeem on 15/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
protocol numberrangeProtocol {
    func numberRange(index:Int,fieldName:String,fieldVal:String,fieldType: String)
}
class NumericRangeTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMinPrice: UITextField!
    
    //MARK:- Properties
//    var delegate: RangeNumberDelegate?
    var delegate: numberrangeProtocol?
    var index = 0
    var minimumValue = ""
    var fieldName = ""
    var fieldType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        txtMinPrice.delegate = self
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 30.0, width: txtMinPrice.frame.size.width + 28, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        txtMinPrice.layer.addSublayer(bottomBorder)

    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        txtMinPrice.text
        self.delegate?.numberRange(index: index, fieldName: fieldName, fieldVal: txtMinPrice.text!, fieldType: fieldType)

    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.numberRange(index: index, fieldName: fieldName, fieldVal: txtMinPrice.text!, fieldType: fieldType)

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.numberRange(index: index, fieldName: fieldName, fieldVal: txtMinPrice.text!, fieldType: fieldType)

    }
    
    
    
}
