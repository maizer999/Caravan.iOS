//
//  TextFieldCell.swift
//  AdForest
//
//  Created by apple on 5/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol AddDataDelegate {
    func addToFieldsArray(obj: AdPostField, index: Int, isFrom: String, title: String)
}

protocol textValDelegate {
    func textVal(value: String,indexPath: Int, fieldType:String, section: Int,fieldNam:String)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var txtType: UITextField!{
        didSet{
            txtType.delegate = self
        }
    }
    
    //MARK:- Properties
    //var delegate: AddDataDelegate?
    var fieldName = ""
    var objSaved = AdPostField()
    var selectedIndex = 0
    //var delegate : textFieldValueDelegate?
    var inde = 0
    var section = 0
    var delegate : textValDelegate?
    var fieldType = "textfield"
    var s = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        objSaved.fieldVal = txtType.text
        if txtType.text == "" || txtType.text == nil {
            s.isHidden = false
        }else{
            s.isHidden = true
        }
       // self.delegate?.addToFieldsArray(obj: objSaved, index: selectedIndex, isFrom: "textfield", title: "")
    }
    
    @IBAction func txtEditingStart(_ sender: UITextField) {
//        s.isHidden = true
        if fieldName == "ad_bidding_time" && fieldType == "textfield"{
            sender.isEnabled = false
            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: Date(), doneBlock: {
                picker, value, index in
                print("value = \(value!)")
                print("index = \(index!)")
                print("picker = \(picker!)")
                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let selectedDate = dateFormatter.string(from: value as! Date)
                self.txtType.text = selectedDate
                self.delegate?.textVal(value:selectedDate , indexPath: self.inde ,fieldType: "textfield",section:self.section,fieldNam: self.fieldName)
                 sender.isEnabled = true
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
            datePicker?.show()
            sender.isEnabled = true
//            let timePicker: UIPickerView = UIPickerView()
//            //assign delegate and datasoursce to its view controller
//            timePicker.delegate = self
//            timePicker.dataSource = self
//
//            // setting properties of the pickerView
//            timePicker.frame = CGRect(x: 0, y: 50, width: self.contentView.frame.width, height: 200)
//            timePicker.backgroundColor = .white
//            // add pickerView to the view
//            self.contentView.addSubview(timePicker)
        }else{
             sender.isEnabled = true
        }
       

        
        
    }
    
    @IBAction func txtEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            s.isHidden = true
            delegate?.textVal(value: text, indexPath: inde,fieldType: "textfield",section:section,fieldNam: fieldName)
        }
    }
    
    
}
//extension TextFieldCell: UIPickerViewDelegate, UIPickerViewDataSource{
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 60
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return String(format: "%02d", row)
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 0{
//            let minute = row
//            print("minute: \(minute)")
//        }else{
//            let second = row
//            print("second: \(second)")
//        }
//    }
//}
