//
//  NomineesViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Crashlytics
import Mixpanel


class NomineesViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,NomineesDetailDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var addAnotherNomineeOutlet: UIButton!
   

    @IBOutlet weak var tableView: UITableView!
    var valid_pan = true
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    var reslationshipArr = ["Select","Husband","Wife","Father","Mother","Son","Daughter","Siblings"]
    let memberDropDown = DropDown()
    var uploadedCount = 0
    let relationDropDown = DropDown()
    var datePicker = UIDatePicker()
    var nomineesDetail = [String]()
    var selectedIndex = -1
    var noIndex = -1
    var selectedMemberIndex =  -1
    var nomineeIndex = -1
    var nomineeIndex1 = -1
    var nomineeDetailArr = [nomineeDetailsObj]()
    var memberListArr = [memberListObj]()
    var UserObjects = [UserObj]()
    var isTermsAccepted = false
    var noButton = ""
    var tags : Int!
    var flag1 : String!
    var member_first_name : String!
    var fatca_detail_flag = false
    var member_list_isEmpty =  false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        //nominee1(row: 0)
        setWhiteNavigationBar()
        getUserData()
        getUserFatcaDetails()
        addBackbutton()
        getNomineeDetails()
        getmemberlistParent()
        nomineesDetail.append("hello")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        if upload_flag && tabBarController?.viewControllers?.count ?? 0 > 3{
//            let indexToRemove = 3
//            if var tabs = self.tabBarController?.viewControllers {
//                tabs.remove(at: indexToRemove)
//                self.tabBarController?.viewControllers = tabs
//            } else {
//                print("There is something wrong with tabbar controller")
//            }
//        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nomineeDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nominee", for: indexPath) as? NomineesDetailTableViewCell
        var diffInDays  = 0
        cell?.gpantf.tag = indexPath.row
        cell?.gpantf.delegate = self
        
        cell?.fnametf.tag = indexPath.row
        cell?.fnametf.delegate = self
        
        cell?.mnametf.tag = indexPath.row
        cell?.mnametf.delegate = self
        cell?.addAsMemberOutlet.tag = indexPath.row
        cell?.lnametf.tag = indexPath.row
        cell?.lnametf.delegate = self
        cell?.relationshipBtnOutlet.tag = indexPath.row
        cell?.dobtf.tag = indexPath.row
        cell?.yesBtnOutlet.tag = indexPath.row
        cell?.noBtnOutlet.tag = indexPath.row
        cell?.removeNomineeOutlet.tag = indexPath.row
        cell?.remove_btn_200.tag =  indexPath.row
        cell?.selectMemberListButton.tag = indexPath.row
        cell?.fnametf.text  = nomineeDetailArr[indexPath.row].nominee_first_name
        cell?.lnametf.text = nomineeDetailArr[indexPath.row].nominee_last_name
        cell?.mnametf.text = nomineeDetailArr[indexPath.row].nominee_middle_name
        cell?.dobtf.delegate = self
        if nomineeDetailArr[indexPath.row].nominee_dob == "0000-00-00" || nomineeDetailArr[indexPath.row].nominee_dob == "" {
            cell?.dobtf.text = ""
        }
        else{
            cell?.dobtf.text = nomineeDetailArr[indexPath.row].nominee_dob
        }
        if nomineeDetailArr[indexPath.row].nominee_relation == "Select"{
             cell?.relationshiptf.text = "Select"
        }
        else{
             cell?.relationshiptf.text = nomineeDetailArr[indexPath.row].nominee_relation?.capitalizingFirstLetter()
            nomineeDetailArr[indexPath.row].nominee_relation = cell?.relationshiptf.text
        }
        if nomineeDetailArr[indexPath.row].nominee_dob != "0000-00-00" && nomineeDetailArr[indexPath.row].nominee_dob != ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            let dateB = dateFormatter.date(from: nomineeDetailArr[indexPath.row].nominee_dob!)
            diffInDays = Calendar.current.dateComponents([.year], from: Date(), to: dateB!).year!
        }
        if diffInDays > -18 && cell?.dobtf.text != "" {
            cell?.gpantf.isEnabled = true
            let attr = [ NSAttributedStringKey.foregroundColor : UIColor.red ]
            let myNewLabelText = NSMutableAttributedString(string: "*", attributes: attr)
            let spouseNames = NSMutableAttributedString(string: "Guardian PAN ")
            spouseNames.append(myNewLabelText)
            cell?.gPanLabel.attributedText = spouseNames
        }
        else{
             cell?.gpantf.isEnabled = false
            cell?.gPanLabel.text = "Guardian PAN"
        }
        cell?.gpantf.text = nomineeDetailArr[indexPath.row].nominee_guardian_pan

        
        //START HANDLE VIEW STATE BY USING FLAG STATE
        let isViewExpanded = nomineeDetailArr[indexPath.row].is_exapanded
        cell?.fnameLabel.isHidden = !isViewExpanded
        cell?.mnameLabel.isHidden = !isViewExpanded
        cell?.lnameLabel.isHidden = !isViewExpanded
        cell?.fnametf.isHidden = !isViewExpanded
        cell?.mnametf.isHidden = !isViewExpanded
        cell?.lnametf.isHidden = !isViewExpanded
        cell?.dobLabel.isHidden = !isViewExpanded
        cell?.gpanLabel.isHidden = !isViewExpanded
        cell?.relationshiptf.isHidden = !isViewExpanded
        cell?.relationShipButtonImage.isHidden = !isViewExpanded
        cell?.relationshipLabel.isHidden = !isViewExpanded
        cell?.dobtf.isHidden = !isViewExpanded
        cell?.gpantf.isHidden = !isViewExpanded
        cell?.relationshipBtnOutlet.isHidden = !isViewExpanded
        cell?.removeNomineeOutlet.isHidden = !isViewExpanded
        cell?.lineRemoveView.isHidden = !isViewExpanded
       //cell?.selectmemberView.visiblity(gone: isViewExpanded,dimension: isViewExpanded ? 40 : 0)
        cell?.yesBtnOutlet.setImage(isViewExpanded ? UIImage(named: "uncheck") : UIImage(named: "check"), for: .normal)
        cell?.noBtnOutlet.setImage(isViewExpanded ? UIImage(named: "check") : UIImage(named: "uncheck"), for: .normal)
        
        
        //END HANDLE VIEW STATE BY USING FLAG STATE
        if isViewExpanded && cell?.dobtf.text != "" && nomineeDetailArr[indexPath.row].nominee_id != ""{
            cell?.addAsMemberOutlet.isHidden = true
            cell?.remove_btn_200.isHidden = true
            cell?.selectmemberView.visiblity(gone: isViewExpanded,dimension: isViewExpanded ? 40 : 0)
            cell?.yes_No_view.visiblity(gone: isViewExpanded)
        }
        else if nomineeDetailArr[indexPath.row].is_expandedInt == 1{
            
            cell?.fnametf.text  = nomineeDetailArr[indexPath.row].nominee_first_name!
            cell?.memberSelect.text = nomineeDetailArr[indexPath.row].nominee_first_name!
            cell?.fnameLabel.isHidden = false
            cell?.mnameLabel.isHidden = false
            cell?.lnameLabel.isHidden = false
            cell?.fnametf.isHidden = false
            cell?.mnametf.isHidden = false
            cell?.lnametf.isHidden = false
            cell?.dobLabel.isHidden = false
            cell?.gpanLabel.isHidden = false
            cell?.relationshiptf.isHidden = false
            cell?.relationShipButtonImage.isHidden = false
            cell?.relationshipLabel.isHidden = false
            cell?.dobtf.isHidden = false
            cell?.gpantf.isHidden = false
            cell?.addAsMemberOutlet.isHidden = false
            cell?.relationshipBtnOutlet.isHidden = false
            cell?.removeNomineeOutlet.isHidden = false
            cell?.lineRemoveView.isHidden = false
            if cell?.noBtnOutlet.currentImage == #imageLiteral(resourceName: "check"){
                cell?.remove_btn_200.isHidden = true
                cell?.selectmemberView.visiblity(gone: true,dimension: 40)
                cell?.fnametf.text = ""
                cell?.mnametf.text = ""
                cell?.lnametf.text = ""
                cell?.dobtf.text = ""
                cell?.relationshiptf.text = "Select"
                cell?.gpantf.text = ""
            } else{
                 cell?.addAsMemberOutlet.isHidden = true
                 cell?.selectmemberView.visiblity(gone: false,dimension: 40)
            }
            cell?.yes_No_view.visiblity(gone: false,dimension: 72)
            
            
            //tableView.reloadData()
        }
        else{
            
            cell?.yes_No_view.visiblity(gone: false,dimension: 72)
            if cell?.noBtnOutlet.currentImage == #imageLiteral(resourceName: "check"){
                cell?.remove_btn_200.isHidden = true
                cell?.addAsMemberOutlet.isHidden = !isViewExpanded
                cell?.selectmemberView.visiblity(gone: true,dimension: 40)
              
            }
            else{
               
                cell?.addAsMemberOutlet.isHidden = true
                //member logic for list
                print("member list",memberListArr.count)
                if memberListArr.count < 1 {
                    cell?.remove_btn_200.isHidden = false
                    cell?.selectmemberView.visiblity(gone: true,dimension: 40)
                    cell?.dontHaveMembers.isHidden = true
                    cell?.yes_No_view.visiblity(gone: true)
                    cell?.fnameLabel.isHidden = false
                    cell?.fnametf.isHidden = false
                    cell?.mnameLabel.isHidden = false
                    cell?.mnametf.isHidden = false
                    cell?.lnameLabel.isHidden = false
                    cell?.lnametf.isHidden = false
                    cell?.dobLabel.isHidden = false
                    cell?.dobtf.isHidden = false
                    cell?.gpanLabel.isHidden = false
                    cell?.gpantf.isHidden = false
                    cell?.relationshiptf.isHidden = false
                    cell?.relationShipButtonImage.isHidden = false
                    cell?.relationshipLabel.isHidden = false
                    cell?.relationshipBtnOutlet.isHidden = false
                    cell?.removeNomineeOutlet.isHidden = true
                    cell?.addAsMemberOutlet.isHidden = true
                } else {
                    cell?.remove_btn_200.isHidden = false
                    cell?.selectmemberView.visiblity(gone: false,dimension: 40)
                    cell?.dontHaveMembers.isHidden = true
                }
                
            }
            
            
        }
        if nomineeDetailArr[indexPath.row].txn_exst != "N"{
            cell?.deleteLabel.text = "You can not delete this nominee as you have selected this nominee in your investment!"
            cell?.deleteLabel.isHidden = false
            cell?.removeNomineeOutlet.isEnabled = false
            cell?.removeNomineeOutlet.alpha = 0.5
        }else if nomineeDetailArr[indexPath.row].default_nominee == "Y"{
            cell?.deleteLabel.isHidden = false
            cell?.deleteLabel.text = "You can not delete this nominee as you have selected this nominee as default nominee!"
            cell?.removeNomineeOutlet.isEnabled = false
            cell?.removeNomineeOutlet.alpha = 0.5
        }else if member_list_isEmpty {
             cell?.removeNomineeOutlet.isHidden = true
            cell?.remove_btn_200.isHidden = true
        } else{
            cell?.deleteLabel.isHidden = true
            cell?.removeNomineeOutlet.isHidden = false
            cell?.removeNomineeOutlet.isEnabled = true
            cell?.removeNomineeOutlet.alpha = 1
            cell?.remove_btn_200.isHidden = true
            if nomineeDetailArr[indexPath.row].is_expandedInt == 2 || nomineeDetailArr[indexPath.row].is_expandedInt == 1{
                cell?.dontHaveMembers.isHidden = true
                cell?.remove_btn_200.isHidden = true
            }
        }
        
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        print(p_userid,"parent user id")
        print(flag,"flag")
        if p_userid  == flag || flag == "0" {
            if isViewExpanded && cell?.dobtf.text != "" && nomineeDetailArr[indexPath.row].nominee_id != ""{
                cell?.addAsMemberOutlet.isHidden = true
            }else if  nomineeDetailArr[indexPath.row].nominee_id != "" {
                cell?.addAsMemberOutlet.isHidden = true
            }else if member_list_isEmpty {
                 cell?.addAsMemberOutlet.isHidden = true
            } else{
                cell?.addAsMemberOutlet.isHidden = false
            }
            
        } else {
            cell?.addAsMemberOutlet.isHidden = true
        }
        
        
        cell?.delegate = self
        return cell!
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.nomineeDetailArr.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(indexPath.row)
        if(self.nomineeDetailArr[indexPath.row].is_exapanded && self.nomineeDetailArr[indexPath.row].nominee_dob != "0000-00-00" && nomineeDetailArr[indexPath.row].nominee_id != ""){
            return 370
        }
        else if(self.nomineeDetailArr[indexPath.row].is_exapanded && self.nomineeDetailArr[indexPath.row].nominee_dob != "0000-00-00" && nomineeDetailArr[indexPath.row].nominee_id == ""){
            return 470
        }
        else if self.nomineeDetailArr[indexPath.row].is_exapanded && self.nomineeDetailArr[indexPath.row].nominee_dob == "0000-00-00"{
             return 470
        }
        else if (self.nomineeDetailArr[indexPath.row].is_expandedInt == 1){
            return 470
        } else if member_list_isEmpty {
            return 370
        }
        else{
            return 200
        }
        
    }
    
    
    @IBAction func addNomineeBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Add Another Nominee Button Clicked")
        self.nomineeDetailArr.append(nomineeDetailsObj.getNomineeDetails(nominee_id: "", nominee_member_id: "1", nominee_first_name: "", nominee_middle_name: "", nominee_last_name: "", nominee_dob: "0000-00-00", nominee_gender: "", nominee_email: "", nominee_mobile: "", nominee_relation: "Select", nominee_guardian_pan: "", txn_exst: "N", full_name: "", default_nominee: "N"))
        if(self.nomineeDetailArr.count > 4){
            addAnotherNomineeOutlet.isHidden = true
        }
        let index = IndexPath(row: nomineeDetailArr.count - 1, section: 0)
        let cell = tableView.cellForRow(at: index) as? NomineesDetailTableViewCell
        cell?.memberSelect.isHidden = false
        cell?.selectmemberView.visiblity(gone: false,dimension: 40)
        self.nomineeDetailArr[nomineeDetailArr.count - 1].is_exapanded = false
        scrollToBottom()
        tableView.reloadData()
      }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = IndexPath(row: textField.tag, section: 0)
        print(index)
        let cell = tableView.cellForRow(at: index) as? NomineesDetailTableViewCell
        if textField == cell?.gpantf{
            let boolean = validatePancard(cell!.gpantf.text!)
            nomineeDetailArr[textField.tag].nominee_guardian_pan = cell?.gpantf.text
            if boolean != true {
                //presentWindow?.makeToast(message: "Please Enter Valid PAN No")
                valid_pan = false
            } else{
                valid_pan = true
            }
        }
        else if textField == cell?.fnametf{
            nomineeDetailArr[textField.tag].nominee_first_name = cell?.fnametf.text
        }
        else if textField == cell?.mnametf{
            nomineeDetailArr[textField.tag].nominee_middle_name = cell?.mnametf.text
        }
        else if textField == cell?.lnametf{
            nomineeDetailArr[textField.tag].nominee_last_name = cell?.lnametf.text
        }
        else if textField == cell?.relationshiptf{
            nomineeDetailArr[textField.tag].nominee_relation = cell?.relationshiptf.text
            
        }
        
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Save Button Clicked")
        resignFirstResponder()
        var diffInDays  = 0
        
        var nominee_details_flag=true
        
        for i in 0..<nomineeDetailArr.count{
            
            let dob = nomineeDetailArr[i].nominee_dob
            //relationship_status =  nomineeDetailArr[i].nominee_relation!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            if dob != "0000-00-00" {
                if dob != ""{
                    let dateB = dateFormatter.date(from: dob!)
                    diffInDays = Calendar.current.dateComponents([.year], from: Date(), to: dateB!).year!
                }
            }
            if nomineeDetailArr[i].nominee_first_name == "" && nomineeDetailArr[i].nominee_last_name == "" && nomineeDetailArr[i].nominee_dob == "0000-00-00" && nomineeDetailArr[i].nominee_relation == "Select" && nomineeDetailArr[i].nominee_guardian_pan == ""{
                
                nominee_details_flag=true
                break
            }
//            else if nomineeDetailArr[i].nominee_member_id  == "1" && nomineeDetailArr[i].is_exapanded != true && !member_list_isEmpty{
//                nominee_details_flag=false
//                presentWindow.makeToast(message: "Please Select Member")
//                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Select Member")
//                break
//            }
            else if nomineeDetailArr[i].nominee_first_name == ""{
                nominee_details_flag=false
                presentWindow.makeToast(message: "Please Enter Nominee First Name")
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Enter Nominee First Name")
                break
            }
            else if nomineeDetailArr[i].nominee_last_name == ""{
                nominee_details_flag=false
                presentWindow.makeToast(message: "Please Enter Nominee Last Name")
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Enter Nominee Last Name")
                break
            }
            else if nomineeDetailArr[i].nominee_dob == "0000-00-00"{
                nominee_details_flag = false
                presentWindow.makeToast(message: "Please Select DOB")
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Select DOB")
                break
            }
            else if nomineeDetailArr[i].nominee_dob == ""{
                nominee_details_flag = false
                presentWindow.makeToast(message: "Please Select DOB")
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Select DOB")
                break
            }
            else if nomineeDetailArr[i].nominee_relation == "Select"{
                nominee_details_flag = false
                presentWindow.makeToast(message: "Please Select Relation")
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Select Relation")
                break
            }
            else if nomineeDetailArr[i].nominee_guardian_pan == "" && diffInDays > -18{
                nominee_details_flag = false
                
                presentWindow.makeToast(message: "Please Enter Nominee Guardian PAN")
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Enter Nominee Guardian PAN")
                break
            }
            else if !valid_pan && diffInDays > -18 {
                nominee_details_flag = false
                Mixpanel.mainInstance().track(event: "Nominees Screen :- Please Enter Valid PAN No")
                presentWindow.makeToast(message: "Please Enter Valid PAN No")
                break
            }
                
            else{
                print("hello")
                // userExistingBank["bank\(i)"]!["verified"]="true"
            }
            
        }
        if nominee_details_flag == true{
            for i in 0..<nomineeDetailArr.count{
            if nomineeDetailArr[i].nominee_first_name == "" && nomineeDetailArr[i].nominee_last_name == "" && nomineeDetailArr[i].nominee_dob == "0000-00-00" && nomineeDetailArr[i].nominee_relation == "Select" && nomineeDetailArr[i].nominee_guardian_pan == ""{
                if self.tabBarController?.viewControllers?.count ?? 0 > 3 {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                    print("success@@@")
                } else {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
            }else {
                    print("JKKKK")
                    print(nomineeDetailArr[i].isTermsAccepted )
                    var userid = UserDefaults.standard.value(forKey: "userid") as! String
                    if flag != "0"{
                        userid = flag
                    } else{
                        userid = UserDefaults.standard.value(forKey: "userid") as! String
                    }
                    if nomineeDetailArr[i].isTermsAccepted {
                        addmember(id: userid, name: nomineeDetailArr[i].nominee_first_name!, middle_name: nomineeDetailArr[i].nominee_middle_name!, last_name: nomineeDetailArr[i].nominee_last_name!, mobile: "", landline: "", email: "\(UserObjects[0].email)", dob: nomineeDetailArr[i].nominee_dob!, building_name: "\(UserObjects[0].building_name)", city: "\(UserObjects[0].city)", state: "\(UserObjects[0].state)", country: "\(UserObjects[0].country)", address: "\(UserObjects[0].address)", pincode: "\(UserObjects[0].pincode)", i: i)
                    
                    } else{
                        AddNomineeDetails(id: userid, nomineeid: nomineeDetailArr[i].nominee_id!, nominee_member_id: "", nominee_first_name: nomineeDetailArr[i].nominee_first_name!, nominee_middle_name: nomineeDetailArr[i].nominee_middle_name!, nominee_last_name: nomineeDetailArr[i].nominee_last_name!, nominee_dob: nomineeDetailArr[i].nominee_dob!, nominee_relation: nomineeDetailArr[i].nominee_relation!, nominee_guardian_pan: nomineeDetailArr[i].nominee_guardian_pan!)
                    }
                }
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        print(index,"row index value")
        let cell = tableView.cellForRow(at: index) as? NomineesDetailTableViewCell
        if textField == cell!.dobtf{
            tags = textField.tag
            self.pickUpDate(cell!.dobtf)
        }
        // print("oooooooo")
    }
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        
        // Mixpanel.mainInstance().track(event: "Premium Calculator :-Picking Date")
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        //  let calcAge = calendar.dateComponents(.year,from:birthdayDate!, to: now, options: [])
        // let age = calcAge.year
        //  let age = calcAge.year
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MydetailsViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MydetailsViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        print("hiiii")
    }
    //else if textField == mnam\
    
    
    @objc func doneClick() {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Date Picker Done Button Clicked")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let index = IndexPath(row: tags, section: 0)
        var diffInDays  = 0
        let cell = tableView.cellForRow(at: index) as? NomineesDetailTableViewCell
        cell?.dobtf.text = dateFormatter1.string(from: datePicker.date)
        nomineeDetailArr[tags].nominee_dob = cell?.dobtf.text
        if nomineeDetailArr[tags].nominee_dob != "0000-00-00"{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            let dateB = dateFormatter.date(from: nomineeDetailArr[tags].nominee_dob!)
            diffInDays = Calendar.current.dateComponents([.year], from: Date(), to: dateB!).year!
        }
        if diffInDays > -18{
            cell?.gpantf.isEnabled = true
            let attr = [ NSAttributedStringKey.foregroundColor : UIColor.red ]
            let myNewLabelText = NSMutableAttributedString(string: "*", attributes: attr)
            let spouseNames = NSMutableAttributedString(string: "Guardian PAN ")
            spouseNames.append(myNewLabelText)
            cell?.gPanLabel.attributedText = spouseNames
        }
        else{
            cell?.gpantf.isEnabled = false
            cell?.gPanLabel.text = "Guardian PAN"
            cell?.gpantf.text = ""
        }
        cell?.dobtf.resignFirstResponder()
    }
    @objc func cancelClick() {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Date Picker Cancel Button Clicked")
        let index = IndexPath(row: tags, section: 0)
        print(index,"cancel index value")
        let cell = tableView.cellForRow(at: index) as? NomineesDetailTableViewCell
        nomineeDetailArr[tags].nominee_dob = "0000-00-00"
        //cell?.dobtf.text = ""
        cell?.dobtf.resignFirstResponder()
    }
    func nominee(row:Int){
        print("Inside nomneed")
        if(nomineeIndex == row) {
            print("\(nomineeIndex)index")
            nomineeIndex = -1
        } else {
            nomineeIndex = row
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    func nominee1(row:Int){
        print("Inside nomneed1")
        if(nomineeIndex1 == row) {
            print("\(nomineeIndex1)index")
            nomineeIndex1 = -1
        } else {
            nomineeIndex1 = row
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    func relationshipDropDown(row: Int, sender: UIButton) {
        self.relationDropDown.anchorView = sender
        let nominieeArr = self.reslationshipArr.map {$0}
        //nominieeArr.insert("Select", at: 0)
        self.relationDropDown.dataSource = nominieeArr
        self.relationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! NomineesDetailTableViewCell
                cell.relationshiptf.text = item
                self.nomineeDetailArr[row].nominee_relation = "Select"
                print("")
            } else {
                print(sender.tag)
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! NomineesDetailTableViewCell
                cell.relationshiptf.text = item
                self.nomineeDetailArr[row].nominee_relation = cell.relationshiptf.text
                
            }
        }
        self.relationDropDown.show()
    }
    
    
    func addAsMember(row: Int,sender : UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "square") {
            self.isTermsAccepted = true
            nomineeDetailArr[row].isTermsAccepted = true
            sender.setImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
        } else {
            self.isTermsAccepted = false
            nomineeDetailArr[row].isTermsAccepted = false
            sender.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        }
    }
    func selectedMember(row: Int ,sender : UIButton) {
        
        self.memberDropDown.anchorView = sender
        var nominieeArr = self.memberListArr.map { $0.fullName}
        nominieeArr.insert("Select Member", at: 0)
        self.memberDropDown.dataSource = nominieeArr
        self.memberDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! NomineesDetailTableViewCell
                cell.memberSelect.text = item
                self.nomineeDetailArr[row].nominee_member_id = "1"
                self.nomineeDetailArr[row].is_exapanded = false
                print("")
            } else {
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! NomineesDetailTableViewCell
                    self.scrollToBottom()
                    cell.memberSelect.text = item
                    
                    cell.fnameLabel.isHidden = true
                    cell.mnameLabel.isHidden = true
                    cell.lnameLabel.isHidden = false
                    cell.fnametf.isHidden = false
                    cell.mnametf.isHidden = false
                    cell.lnametf.isHidden = false
                    cell.dobLabel.isHidden = false
                    cell.gpanLabel.isHidden = false
                    cell.relationshiptf.isHidden = false
                    cell.relationShipButtonImage.isHidden = false
                    cell.relationshipLabel.isHidden = false
                    cell.dobtf.isHidden = false
                    cell.gpantf.isHidden = false
                    cell.addAsMemberOutlet.isHidden = false
                    cell.relationshipBtnOutlet.isHidden = false
                    cell.removeNomineeOutlet.isHidden = false
                    cell.lineRemoveView.isHidden = false
                    cell.fnametf.text = self.memberListArr[row].name
                    cell.mnametf.text = self.memberListArr[row].mname
                    cell.lnametf.text = self.memberListArr[row].lname
                    cell.dobtf.text = self.memberListArr[row].dob
                    self.nomineeDetailArr[row].is_expandedInt = 1
                    self.member_first_name = cell.memberSelect.text
                    
                    self.nomineeDetailArr[row].nominee_first_name = self.memberListArr[index-1].name
                    self.nomineeDetailArr[row].nominee_last_name = self.memberListArr[index-1].lname
                    self.nomineeDetailArr[row].nominee_middle_name = self.memberListArr[index-1].mname
                    self.nomineeDetailArr[row].nominee_dob = self.memberListArr[index-1].dob
                    self.nomineeDetailArr[row].nominee_member_id = self.memberListArr[index-1].m_id
                    self.tableView.reloadData()
                }
            }
        
        self.memberDropDown.show()
        
        
      //  cell?.memberSelect.text=
        
    }
    func expandYesView(row: Int) {
        self.nomineeDetailArr[row].is_exapanded = false
        self.nomineeDetailArr[row].is_expandedInt = 0
        self.tableView.reloadData()
    }
    func dontHaveMember(row: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "AddMemberViewController") as! AddMemberViewController
        destVC.id = "1"
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func deleteNominee(row: Int) {
        let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this nominee? ", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            Mixpanel.mainInstance().track(event: "Nominees Screen :- Confirm Alert No Button Clicked")
            print("Handle no logic here")
        }))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Yes Logic here")
            Mixpanel.mainInstance().track(event: "Nominees Screen :- Confirm Alert Yes Button Clicked")
            self.deleteNominee(id: self.nomineeDetailArr[row].nominee_id!,tableRowIndex: row)
        }))
        
        refreshAlert.view.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        present(refreshAlert, animated: true, completion: nil)
    }
    func removeNominee(row: Int) {
        let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this nominee? ", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle no logic here")
            Mixpanel.mainInstance().track(event: "Nominees Screen :- Confirm Alert No Button Clicked")
        }))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Yes Logic here")
            Mixpanel.mainInstance().track(event: "Nominees Screen :- Confirm Alert Yes Button Clicked")
            
            self.nomineeDetailArr.remove(at: row)
            if(self.nomineeDetailArr.count <= 4){
                self.addAnotherNomineeOutlet.isHidden = false
            }
            self.tableView.reloadData()
           // self.deleteNominee(id: self.nomineeDetailArr[row].nominee_id!,tableRowIndex: row)
        }))
        
        refreshAlert.view.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        present(refreshAlert, animated: true, completion: nil)
    }
    func expandNoView(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! NomineesDetailTableViewCell
        nomineeDetailArr[row].nominee_first_name = ""
        nomineeDetailArr[row].nominee_middle_name = ""
        nomineeDetailArr[row].nominee_last_name = ""
        nomineeDetailArr[row].nominee_dob = "0000-00-00"
        nomineeDetailArr[row].nominee_relation = "Select"
        nomineeDetailArr[row].nominee_guardian_pan = ""
        self.nomineeDetailArr[row].is_exapanded = true
        self.nomineeDetailArr[row].is_expandedInt = 2
        cell.memberSelect.text = "Select Member"
        scrollToBottom()
        
        self.tableView.reloadData()
    }
    
    func getNomineeDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        
        let url = "\(Constants.BASE_URL)\(Constants.API.getNomineeDetails)\(covertToBase64(text: userid as! String))/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                //print(response.result.value)
                if let data = data as? [AnyObject]{
                    if data.isEmpty != true{
                        for type in data{
                            if let nominee_id = type.value(forKey: "nominee_id") as? String,
                                let nominee_member_id = type.value(forKey: "nominee_member_id") as? String,
                                let nominee_first_name = type.value(forKey: "nominee_first_name") as? String,
                                let nominee_middle_name = type.value(forKey: "nominee_middle_name") as? String,
                                let nominee_last_name = type.value(forKey: "nominee_last_name") as? String,
                                let nominee_dob = type.value(forKey: "nominee_dob") as? String,
                                let nominee_gender = type.value(forKey: "nominee_gender") as? String,
                                let nominee_email = type.value(forKey: "nominee_email") as? String,
                                let nominee_mobile = type.value(forKey: "nominee_mobile") as? String,
                                let nominee_relation = type.value(forKey: "nominee_relation") as? String,
                                let nominee_guardian_pan = type.value(forKey: "nominee_guardian_pan") as? String,
                                let txn_exst = type.value(forKey: "txn_exst") as? String{
                                print(nominee_id)
                                let default_nominee = type.value(forKey: "default_nominee") as? String ?? ""
                                self.nomineeDetailArr.append(nomineeDetailsObj.getNomineeDetails(nominee_id: nominee_id, nominee_member_id: nominee_member_id, nominee_first_name: nominee_first_name, nominee_middle_name: nominee_middle_name, nominee_last_name: nominee_last_name, nominee_dob: nominee_dob, nominee_gender: nominee_gender, nominee_email: nominee_email, nominee_mobile: nominee_mobile, nominee_relation: nominee_relation, nominee_guardian_pan: nominee_guardian_pan, txn_exst: txn_exst, full_name: "", default_nominee: default_nominee))
                                if(self.nomineeDetailArr.count > 4){
                                    self.addAnotherNomineeOutlet.isHidden = true
                                }
                            }
                        }
                    }
                    else{
                        
                        self.nomineeDetailArr.append(nomineeDetailsObj.getNomineeDetails(nominee_id: "", nominee_member_id: "1", nominee_first_name: "", nominee_middle_name: "", nominee_last_name: "", nominee_dob: "0000-00-00", nominee_gender: "", nominee_email: "", nominee_mobile: "", nominee_relation: "Select", nominee_guardian_pan: "", txn_exst: "N", full_name: "", default_nominee: "N"))
                        self.nomineeDetailArr[self.nomineeDetailArr.count - 1].is_exapanded = false
                    }
                } else {
                    self.presentWindow.hideToastActivity()
                }
                self.tableView.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func deleteNominee(id:String,tableRowIndex: Int ){
        // "http://www.erokda.in/adminpanel/users/user_ws.php/deletenominee"
        if id != ""{
            let url = "\(Constants.BASE_URL)\(Constants.API.deleteNominee)"
            if Connectivity.isConnectedToInternet{
                let parameters = [
                    "nid": "\(id.covertToBase64())",
                    "enc_resp" :"3"
                ]
                
                print(parameters)
                // let url = "\(Constants.BASE_URL)\(Constants.API.addDoc)"
                presentWindow.makeToastActivity(message: "Deleting..")
                Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseString { response in
                        let enc_response = response.result.value
                        let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                        let enc = enc1?.base64Decoded()
                        print(enc ?? "response of delete")
                        self.presentWindow.hideToastActivity()
                        if enc == "\"true\"" {
                        //if enc! == "true"{
                            print("success@@@")
                            //Delete data from table view only when it is being updated on server
                            self.nomineeDetailArr.remove(at: tableRowIndex)
                            if(self.nomineeDetailArr.count <= 4){
                                self.addAnotherNomineeOutlet.isHidden = false
                            }
                            self.tableView!.reloadData()
                        }
                        else {
                            self.presentWindow.makeToast(message: "Something Went Wrong!!")
                        }
                }
            }
                
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        } else {
            self.nomineeDetailArr.remove(at: tableRowIndex)
            if(self.nomineeDetailArr.count <= 4){
                self.addAnotherNomineeOutlet.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
    func getmemberlistParent(){
        let userid = UserDefaults.standard.value(forKey: "userid")
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
        var url1 = ""
        let userdefaults = UserDefaults.standard
        if let savedValue = userdefaults.string(forKey: "parent_user_id"){
            url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(p_userid!)"
        } else {
            url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(userid!)"
        }
        print(url1)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url1).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    print(data)
                    if !data.isEmpty {
                    for type in data{
                        
                        if let name = type.value(forKey: "name") as? String,
                            let mname = type.value(forKey: "middle_name") as? String,
                            let lname = type.value(forKey: "last_name") as? String,
                            let pan = type.value(forKey: "pan") as? String,
                            let m_id = type.value(forKey: "id") as? String,
                            let dob = type.value(forKey: "dob") as? String {
                            let fullName = name + " " + mname + " "  + lname
                            let userid = UserDefaults.standard.value(forKey: "userid") as? String
                            
                            if  userid! != m_id {
                                self.member_list_isEmpty = false
                                print("m_id" ,m_id,"userid:-",userid!,"Name:-",name)
                               self.memberListArr.append(memberListObj.getMemberList(name: name, m_id: m_id, mname: mname, pan: pan, lname: lname, full_name: fullName, dob: dob))
                            }else {
                                self.member_list_isEmpty = true
                            }
                        }
                    }
                       self.tableView.reloadData()
                    } else{
                        
                        self.member_list_isEmpty = true
                        self.tableView.reloadData()
                        print("member list is empty")
                    }
                } else {
                    self.presentWindow.hideToastActivity()
                }
               
                
            }
         }else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func AddNomineeDetails(id:String,nomineeid:String,nominee_member_id:String,nominee_first_name:String,nominee_middle_name:String,nominee_last_name:String,nominee_dob:String,nominee_relation:String,nominee_guardian_pan:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.AddNomineeDetails)"
        print(url)
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id": "\(id.covertToBase64())",
                "nomineeid" : "\(nomineeid.covertToBase64())",
                "nominee_member_id":"\(nominee_member_id.covertToBase64())",
                "nominee_first_name":"\(nominee_first_name.covertToBase64())",
                "nominee_middle_name":"\(nominee_middle_name.covertToBase64())",
                "nominee_last_name":"\(nominee_last_name.covertToBase64())",
                "nominee_dob":"\(nominee_dob.covertToBase64())",
                "nominee_relation":"\(nominee_relation.lowecasedFirstLetter().covertToBase64())",
                "nominee_guardian_pan":"\(nominee_guardian_pan.covertToBase64())",
                "enc_resp":"3"
              ]
            print(parameters)
            presentWindow.makeToastActivity(message: "Adding..")
            Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    if enc == "\"true\"" {
                        if self.uploadedCount == self.nomineeDetailArr.count - 1 {
                            if self.fatca_detail_flag {
                                self.bseRegisteredFlag(userid: id)
                            } else {
                                self.presentWindow.hideToastActivity()
                                self.presentWindow.makeToast(message: "Nominee Saved Successfully")
                                if self.tabBarController?.viewControllers?.count ?? 0 > 3 {
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                    print("success@@@")
                                }else {
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                }
                            }
                        }
                        //self.presentWindow.hideToastActivity()
                        self.uploadedCount += 1
                    } else {
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
                   
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func addmember(id:String,name:String,middle_name:String,last_name:String,mobile:String,landline:String,email:String,dob:String,building_name:String,city :String,state:String, country:String, address:String, pincode:String,i:Int){
        let url = "\(Constants.BASE_URL)\(Constants.API.nomineeAddmember)"
        print(url)
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id": "\(id.covertToBase64())",
                "name" : "\(name.covertToBase64())",
                "middle_name":"\(middle_name.covertToBase64())",
                "last_name":"\(last_name.covertToBase64())",
                "mobile":"\(mobile.covertToBase64())",
                "landline":"\(landline.covertToBase64())",
                "email":"\(email.covertToBase64())",
                "dob":"\(dob.covertToBase64())",
                "building_name":"\(building_name.covertToBase64())",
                "city":"\(city.covertToBase64())",
                "state":"\(state.covertToBase64())",
                "country":"\(country.covertToBase64())",
                "address":"\(address.covertToBase64())",
                "pincode":"\(pincode.covertToBase64())",
                "enc_resp":"3"
            ]
            print(parameters)
            presentWindow.makeToastActivity(message: "Adding..")
            Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    self.presentWindow.hideToastActivity()
                    let member_id = enc 
                    print(member_id ?? "member id")
                    //if member_id != ""
                    if member_id != nil{
                     self.AddNomineeDetails(id: id, nomineeid: self.nomineeDetailArr[i].nominee_id!, nominee_member_id: "\(member_id!)", nominee_first_name: self.nomineeDetailArr[i].nominee_first_name!, nominee_middle_name: self.nomineeDetailArr[i].nominee_middle_name!, nominee_last_name: self.nomineeDetailArr[i].nominee_last_name!, nominee_dob: self.nomineeDetailArr[i].nominee_dob!, nominee_relation: self.nomineeDetailArr[i].nominee_relation!, nominee_guardian_pan: self.nomineeDetailArr[i].nominee_guardian_pan!)
                    } else{
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
                    
                    
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_PAN_DB)\(userid!)"
        presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                self.presentWindow.hideToastActivity()
                if let data = response.result.value as? [[String: AnyObject]] {
                    for object in data {
                        let id = object["id"] as? String ?? ""
                        let pan = object["pan"] as? String ?? ""
                        let dob = object["dob"] as? String ?? ""
                        let mobile = object["mobile"] as? String ?? ""
                        let landline = object["landline"] as? String ?? ""
                        let name = object["name"] as? String ?? ""
                        let middle_name = object["middle_name"] as? String ?? ""
                        let last_name = object["last_name"] as? String ?? ""
                        let flat_no = object["flat_no"] as? String ?? ""
                        let building_name = object["building_name"] as? String ?? ""
                        let road_street = object["road_street"] as? String ?? ""
                        let address = object["address"] as? String ?? ""
                        let city = object["city"] as? String ?? ""
                        let state = object["state"] as? String ?? ""
                        let country = object["country"] as? String ?? ""
                        let pincode  = object["pincode"] as? String ?? ""
                        let email = object["email"] as? String ?? ""
                       // getCountries(code:country, state: state,city: city)
                        let UserObjs = UserObj(id: id, pan: pan, dob: dob, mobile: mobile, landline: landline, name: name, middle_name: middle_name, last_name: last_name, flat_no: flat_no, building_name: building_name, road_street: road_street, address: address, city: city, state: state, country: country, pincode: pincode, email:email)
                        self.UserObjects.append(UserObjs)
                        
                        
                    }
                } else {
                    self.presentWindow.hideToastActivity()
                }
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    
    func validatePancard(_ candidate: String) -> Bool {
        let panCardRegex = "[A-Z]{3}[PHABTCF][A-Z]{1}[0-9]{4}[A-Z]{1}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", panCardRegex)
        return emailTest.evaluate(with: candidate)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let index = IndexPath(row: textField.tag, section: 0)
        print(index)
        let cell = tableView.cellForRow(at: index) as? NomineesDetailTableViewCell
        if textField == cell?.gpantf{
            textField.maxLength = 10
            let lowercaseCharRange: NSRange = (string as NSString).rangeOfCharacter(from: CharacterSet.lowercaseLetters)
            
            if lowercaseCharRange.location != NSNotFound {
                textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.uppercased())
                return false
            }
            
        }else if textField == cell?.fnametf || textField == cell?.lnametf {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }
    func getUserFatcaDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getFatcaDetails)\(covertToBase64(text: userid as! String))/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            //cityArr.removeAll()
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                if let data = data as? [AnyObject]{
                    if !data.isEmpty{
                        for type in data{
                            if let fatca_id = type.value(forKey: "fatca_id") as? String,
                                let fatca_networth = type.value(forKey: "fatca_networth") as? String, let fatca_networth_date = type.value(forKey: "fatca_networth_date") as? String , let fatca_politically_exposed = type.value(forKey: "fatca_politically_exposed") as? String,let fatca_nationality = type.value(forKey: "fatca_nationality") as? String,let fatca_other_nationality = type.value(forKey: "fatca_other_nationality") as? String,let fatca_tax_resident = type.value(forKey: "fatca_tax_resident") as? String ,let fatca_resident_country = type.value(forKey: "fatca_resident_country") as? String,let fatca_tax_player_id = type.value(forKey: "fatca_tax_player_id") as? String,let fatca_id_type = type.value(forKey: "fatca_id_type") as? String,let fatca_resident_country_1 = type.value(forKey: "fatca_resident_country_1") as? String, let fatca_tax_player_id_1 = type.value(forKey: "fatca_tax_player_id_1") as? String,let fatca_id_type_1 = type.value(forKey: "fatca_id_type_1") as? String,let fatca_resident_country_2 = type.value(forKey: "fatca_resident_country_2") as? String,let fatca_tax_player_id_2 = type.value(forKey: "fatca_tax_player_id_2") as? String,let fatca_id_type_2 = type.value(forKey: "fatca_id_type_2") as? String{
                                
                                self.fatca_detail_flag = true
                                
                                //  natinalitytf.text = ""
                                
                                
                            }
                        }
                    }
                    else{
                        self.fatca_detail_flag = false
                        print("fatca detail is empty")
                    }
                    // print(self.countriesArr)
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/clientregistration/userid
        let url = "\(Constants.BASE_URL)\(Constants.API.clientregistration)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if let response_status = data?["response"] {
                    if data?["status"] != nil && data?["status"] as? String  == "Error" {
                        self.presentWindow.hideToastActivity()
                        let bse_err_msg =  data?["bse_err_msg"] as? String ?? "FAIL"
                        let alert = UIAlertController(title: "Alert", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.setValue(bse_err_msg.htmlToAttributedString, forKey: "attributedMessage")
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                            print("Ok button clicked")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else  {
                        //fatca called after success ucc else no required.
                        self.fatcaUploadBse(userid: userid)
                    }
                }
            }
        } else {
            
        }
    }
    func fatcaUploadBse(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.FATCAUpload)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if data?["bse_err_status"] != nil && data?["bse_err_status"] as? String  == "FAIL" {
                    self.presentWindow.hideToastActivity()
                    let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //redirect to upload detail
                    self.presentWindow.hideToastActivity()
                    if self.tabBarController?.viewControllers?.count ?? 0 > 3 {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
            }
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func bseRegisteredFlag(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.isBSERegistered)\(userid)"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:String]
                if let bse_reg_status = data?["bse_reg"] {
                    print(bse_reg_status)
                    if bse_reg_status == "Y" {
                        self.clientregistrationBse(userid: userid)
                    } else {
                        self.presentWindow.hideToastActivity()
                        if self.tabBarController?.viewControllers?.count ?? 0 > 3 {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }else {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func lowecasedFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func lowecasedFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
