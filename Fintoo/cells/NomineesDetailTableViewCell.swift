//
//  NomineesDetailTableViewCell.swift
//  Fintoo
//
//  Created by iosdevelopermme on 08/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel

var relationship_status = "Select"

protocol NomineesDetailDelegate: class {
    func expandYesView(row: Int)
    func expandNoView(row: Int)
    func selectedMember(row : Int,sender : UIButton)
    func deleteNominee(row: Int)
    func removeNominee(row:Int)
    func relationshipDropDown(row: Int,sender:UIButton)
    func addAsMember(row: Int,sender : UIButton)
    func dontHaveMember(row:Int)
}
class NomineesDetailTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var remove_btn_200: UIButton!
    @IBOutlet weak var yes_No_view: UIView!
    @IBOutlet weak var selectmemberView: UIView!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var lineRemoveView: UIView!
    
    @IBOutlet weak var relationShipButtonImage: UIImageView!
    
    var memberListArr = [memberListObj]()
    var reslationshipArr = ["Select","Husband","Wife","Father","Mother","Son","Daughter","Siblings"]
    @IBOutlet weak var fnameLabel: UILabel!
    
    @IBOutlet weak var mnameLabel: UILabel!
    @IBOutlet weak var relationshiptf: UITextField!
    
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var gpanLabel: UILabel!
    
    @IBOutlet weak var selectMemberTableView: UITableView!
    
    @IBOutlet weak var relationshipTableview: UITableView!
    
    @IBOutlet weak var lnameLabel: UILabel!
    
    @IBOutlet weak var relationshipBtnOutlet: UIButton!
    
    @IBOutlet weak var addAsMemberOutlet: UIButton!
    
    @IBOutlet weak var removeNomineeOutlet: UIButton!
    
    @IBOutlet weak var fnametf: UITextField!
    
    @IBOutlet weak var mnametf: UITextField!
    
    @IBOutlet weak var lnametf: UITextField!
    
    @IBOutlet weak var dobtf: UITextField!
    
    @IBOutlet weak var selectMemberListButton: UIButton!
    
    @IBOutlet weak var gpantf: UITextField!
    
    @IBOutlet weak var memberSelect: UITextField!
    @IBOutlet weak var yesBtnOutlet: UIButton!
    @IBOutlet weak var noBtnOutlet: UIButton!
    
    @IBOutlet weak var gPanLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //getmemberlistParent()
        selectMemberTableView.delegate = self
        relationshipTableview.delegate = self
        relationshipTableview.dataSource =  self
        selectMemberTableView.dataSource = self
        // Initialization code
    }
    weak var delegate: NomineesDetailDelegate?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func yesBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Yes Button Clicked")
        print(sender.tag)
        delegate?.expandYesView(row: sender.tag)
    }
    @IBAction func noBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- No Button Clicked")
        delegate?.expandNoView(row: sender.tag)
    }
    
    @IBAction func addAsMember(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Add As Member Button Clicked")
        delegate?.addAsMember(row: sender.tag,sender : sender)
        
    }
    @IBAction func removeNominee(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Remove Nominee Button Clicked")
        delegate?.deleteNominee(row : sender.tag)
    }
    
    @IBAction func remove_btn_200(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Remove Nominee Button Clicked")
        delegate?.removeNominee(row : sender.tag)
    }
    
    @IBAction func selectMemberListBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Select Member Dropdown Button Clicked")
        delegate?.selectedMember(row: selectMemberListButton.tag, sender:sender)
        //selectMemberTableView.isHidden = !selectMemberTableView.isHidden
        relationshipTableview.isHidden = true
        fnameLabel.isHidden = true
        mnameLabel.isHidden = true
        lnameLabel.isHidden = true
        fnametf.isHidden = true
        mnametf.isHidden = true
        lnametf.isHidden = true
        dobLabel.isHidden = true
        gpanLabel.isHidden = true
        relationshiptf.isHidden = true
        relationshipLabel.isHidden = true
        dobtf.isHidden = true
        gpantf.isHidden = true
        addAsMemberOutlet.isHidden = true
        relationshipBtnOutlet.isHidden = true
        removeNomineeOutlet.isHidden = true
        lineRemoveView.isHidden = true
    }
    @IBAction func relationshipBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Nominees Screen :- Relationship Dropdown Button Clicked")
        delegate?.relationshipDropDown(row: relationshipBtnOutlet.tag, sender: sender)
//        selectMemberTableView.isHidden = true
//        relationshipTableview.isHidden = !relationshipTableview.isHidden
        
    }
    @IBOutlet weak var dontHaveMembers: UIButton!
    @IBAction func dontHaveMember(_ sender: UIButton) {
        delegate?.dontHaveMember(row: sender.tag)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectMemberTableView{
             return memberListArr.count
        }
        else{
             return reslationshipArr.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  selectMemberTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "memberlist", for: indexPath)
            // tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: indexPath)
            print(memberListArr[indexPath.row].name)
            cell.textLabel?.text = memberListArr[indexPath.row].name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "relationship", for: indexPath)
            cell.textLabel?.text = reslationshipArr[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectMemberTableView{
            let cell = selectMemberTableView.cellForRow(at: indexPath)
            memberSelect.text = cell?.textLabel?.text
            fnametf.text = memberListArr[indexPath.row].name
            mnametf.text = memberListArr[indexPath.row].mname
            lnametf.text =  memberListArr[indexPath.row].lname
            gpantf.text = memberListArr[indexPath.row].pan
            dobtf.text = memberListArr[indexPath.row].dob
            relationshiptf.text = memberListArr[indexPath.row].relation
            self.selectMemberTableView.isHidden = true
            
          
        }
        else{
            let cell = relationshipTableview.cellForRow(at: indexPath)
            relationshiptf.text = cell?.textLabel?.text
            relationship_status = relationshiptf.text!
            self.relationshipTableview.isHidden = true
        }
    }
    
}
