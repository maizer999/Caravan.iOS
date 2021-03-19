//
//  CheckBoxCell.swift
//  AdForest
//
//  Created by apple on 5/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
protocol checkBoxProtocol {
    func checkBoxesChecked (checkBoxID: String, fieldType: String, indexPath: Int,isSelected: Bool,fieldNam:String)
}
class CheckBoxCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
        }
    }
    
    //MARK:- Properties
    var dataArray = [AdPostValue]()
    var checkBoxID = ""
    var checkBoxDict = [String: String]()
    var fieldName = ""
    var fieldType = ""
    var delegate : checkBoxProtocol!
    var selectedArray = [AdPostValue]()
    var valueArray = [String]()
    var dict = [String: String]()
    var localVariable = ""
    var indexPath = 0
    var isClicked = false
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.valueArray.removeAll()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell: CehckCell = tableView.dequeueReusableCell(withIdentifier: "CehckCell", for: indexPath) as! CehckCell
//        let objData = dataArray[indexPath.row]
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .checkmark
//
//        if objData.isChecked == true{
//        //            cell.oltFullButton.setTitle(objData.name, for: .normal)
//                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
//            }
//
//        }
//    }
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
           var buffer = [T]()
           var added = Set<T>()
           for elem in source {
               if !added.contains(elem) {
                   buffer.append(elem)
                   added.insert(elem)
               }
           }
           return buffer
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CehckCell = tableView.dequeueReusableCell(withIdentifier: "CehckCell", for: indexPath) as! CehckCell
        
        
       
            
        
        
        let objData = dataArray[indexPath.row]

        if isClicked == false{
            if objData.isChecked == true{
                cell.tintColor = .systemGreen
                print(objData.id)
                self.valueArray.append(objData.id)
                self.dict[self.fieldName] = objData.id
                cell.backgroundColor = UIColor.groupTableViewBackground
                cell.accessoryType = .checkmark
            }
        }
        
        

        if let title = objData.name {
            cell.lblName.text = title
        }
//        if isClicked == false{
//        for item in self.valueArray {
//            self.localVariable += item + ","
//        }
//        self.delegate?.checkBoxesChecked(checkBoxID: self.localVariable, fieldType: "checkbox", indexPath: indexPath.row, isSelected: false, fieldNam: self.fieldName)
//    }
        cell.btnFull = { () in
            
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
                print(self.valueArray)
                let uni = self.uniq(source: self.valueArray)
                print(uni)
                self.valueArray = uni
            
                self.valueArray.remove(object: objData.id)
                for item in self.valueArray {
                    self.localVariable += item + ","
                }
                cell.backgroundColor = UIColor.white
                // if self.valueArray.contains(objData.id) {
                // }
                // else {
                // }
                self.isClicked = true
                self.delegate?.checkBoxesChecked(checkBoxID: self.localVariable, fieldType: "checkbox", indexPath: indexPath.row, isSelected: false, fieldNam: self.fieldName)

                print(self.valueArray)
            }
            else {
                
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark


                if self.valueArray.contains(objData.id) {
                }
                else {
                    cell.backgroundColor = UIColor.groupTableViewBackground
                    self.valueArray.append(objData.id)
                    
                    self.dict[self.fieldName] = objData.id
                }
                
                let uni = self.uniq(source: self.valueArray)
                print(uni)
                self.valueArray = uni
                for item in self.valueArray {
                    self.localVariable += item + ","
                }
                print(self.localVariable)
                
                
                self.isClicked = true
                //self.dataArray[indexPath.row].isChecked = true
                self.delegate?.checkBoxesChecked(checkBoxID: self.localVariable, fieldType: "checkbox", indexPath: indexPath.row, isSelected: true, fieldNam: self.fieldName)

                print(self.valueArray)
            }
        }

//            let objData = dataArray[indexPath.row]
//
//            if let title = objData.name {
//                cell.lblName.text = title
//            }
//
//
//            cell.btnFull = { () in
//
//                if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
//                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
//                        if self.valueArray.contains(objData.id) {
//                    }
//                    else {
//                    }
//                }
//                else {
//                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
//                        if self.valueArray.contains(objData.id) {
//                    }
//                    else {
//                        self.valueArray.append(objData.id)
//                        self.dict[self.fieldName] = objData.id
//                    }
//                }
//            }

        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

class CehckCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var oltFullButton: UIButton!
   
    //MARK:- Properties
    
    var btnCheck: (()->())?
    var btnFull: (()->())?
    
    //MARK:- View life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    //MARK:- IBActions
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFull?()
    }
}

protocol checkValuess {
func check(value: [AdPostValue])
}
