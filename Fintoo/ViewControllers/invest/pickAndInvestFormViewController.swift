//
//  pickAndInvestFormViewController.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 04/06/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import DropDown
import Alamofire

class pickAndInvestFormViewController: BaseViewController, FlexibleSteppedProgressBarDelegate ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var questionLabelHeader: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var riskProfileView: UIView!
    @IBOutlet weak var riskTf: UITextField!
    @IBOutlet weak var investTf: UITextField!
    @IBOutlet weak var secondQuestionView: UIView!
    @IBOutlet weak var forthQuestionView: UIView!
    @IBOutlet weak var thirdQuestionView: UIView!
    @IBOutlet weak var tfYear: UITextField!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var answerTableView: UITableView!
    
    @IBOutlet weak var previousQuestionButtonOutlet: UIButton!
    @IBOutlet weak var nextQuestionButtonOutlet: UIButton!
    var question_arr = [String]()
    var answer_arr  = [String]()
    var answer_pts = [String]()
    var usr_answer_pts = [String]()
    var titles = ""
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 45.0 / 255.0, green: 180.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var bgcolor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    let dropDownYear = DropDown()
    let dropDownRisk = DropDown()
    var mode = 3
    var id_package = "0"
    var risk_mode = ""
    var count = 0
    var display_answer_arr = [Dictionary<String,String>]()
    var display_answer_arr_1 = [String: Int]()
    var display_answer_pts = [String]()
    var display_answer_selected_id = 0
    var selected_answer_index = [Int?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titles
        addBackbutton()
        // Do any additional setup after loading the view.
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        investTf.delegate = self
        answerTableView.delegate = self
        answerTableView.dataSource = self
        // Customise the progress bar here
        progressBar.numberOfPoints = 4
        progressBar.lineHeight = 3
        progressBar.radius = 23
        progressBar.progressRadius = 25
        progressBar.progressLineHeight = 3
        progressBar.delegate = self
        
        progressBar.useLastState = true
        progressBar.stepTextColor = textColorHere
        
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedBackgoundColor = progressColor
        progressBar.selectedOuterCircleStrokeColor = backgroundColor
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.currentIndex = 0
        getQuestions()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let headerView = answerTableView.tableHeaderView {
            
            //let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                answerTableView.tableHeaderView = headerView
            }
        }
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.progressBar  {
            if position == FlexibleSteppedProgressBarTextLocation.top {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                default: return ""
                    
                }
            } else if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                default: return ""
                    
                }
                
            } else if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return "1"
                case 1: return "2"
                case 2: return "3"
                case 3: return "4"
                default: return ""
                    
                }
            }
        }
        
        return ""
    }
    @IBOutlet weak var previouseBtnOutlet: UIButton!
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if progressBar.currentIndex == 0 {
            if !tfYear.text!.isEmpty {
                progressBar.currentIndex = 1
                progressBar.completedTillIndex = 1
                previouseBtnOutlet.isHidden = false
                forthQuestionView.isHidden = false
            }else {
                presentWindow.makeToast(message: "Please Select year")
            }
        }else if progressBar.currentIndex == 1 {
            print(tfYear.text ?? "","tf text")
            
            progressBar.currentIndex = 2
            progressBar.completedTillIndex = 2
            previouseBtnOutlet.isHidden = false
            secondQuestionView.isHidden = false
            forthQuestionView.isHidden = true
             
            
        }else if progressBar.currentIndex == 2 {
            let amount_sip_both = Int(tfYear.text!)! * 12000
            let amount_lumpsum = 5000
            investTf.resignFirstResponder()
            if !investTf.text!.isEmpty {
                if mode == 2 || mode == 3 {
                    
                    if Int(investTf.text!)! >= amount_sip_both {
                        progressBar.currentIndex = 3
                        progressBar.completedTillIndex = 3
                        previouseBtnOutlet.isHidden = false
                        thirdQuestionView.isHidden = false
                        //nextBtnOutlet.isHidden = true
                        nextBtnOutlet.setTitle("Submit", for: .normal)
                    }else {
                        presentWindow.makeToast(message: "Please enter amount atleast \(amount_sip_both)")
                    }
                } else if mode == 1 {
                    if Int(investTf.text!)! >= amount_lumpsum {
                        progressBar.currentIndex = 3
                        progressBar.completedTillIndex = 3
                        previouseBtnOutlet.isHidden = false
                        thirdQuestionView.isHidden = false
                        //nextBtnOutlet.isHidden = true
                        nextBtnOutlet.setTitle("Submit", for: .normal)
                    } else {
                        presentWindow.makeToast(message: "Please enter amount atleast 5000")
                    }
                }
            } else {
                presentWindow.makeToast(message: "Please enter amount")
            }
           
        } else if progressBar.currentIndex == 3 {
            if riskTf.text == "Select"{
                presentWindow.makeToast(message: "Please select the Afforded risk")
            } else {
                add_pick_investment()
            }
        }
        
    }
    @IBAction func previouseButtom(_ sender: Any) {
        if progressBar.currentIndex == 2 {
            previouseBtnOutlet.isHidden = false
            forthQuestionView.isHidden = false
            progressBar.currentIndex = 1
            progressBar.completedTillIndex = 1
            secondQuestionView.isHidden = true
        } else if progressBar.currentIndex == 1 {
            progressBar.currentIndex = 0
            progressBar.completedTillIndex = 0
            previouseBtnOutlet.isHidden = true
            forthQuestionView.isHidden = true
            
        } else if progressBar.currentIndex == 3 {
            progressBar.currentIndex = 2
            progressBar.completedTillIndex = 2
            previouseBtnOutlet.isHidden = false
            thirdQuestionView.isHidden = true
            secondQuestionView.isHidden = false
            nextBtnOutlet.setTitle("Next", for: .normal)
        }
    }
    @IBAction func riskButoonDropDown(_ sender: UIButton) {
        let risk = ["Select","High","Moderately High","Moderate","Moderately Low","Low"]
        self.dropDownRisk.anchorView = sender
        self.dropDownRisk.dataSource = risk
        self.dropDownRisk.direction = .bottom
        self.dropDownRisk.selectionAction = { [unowned self] (index: Int, item: String) in
            self.riskTf.text = item
            //self..text = item
        }
        self.dropDownRisk.show()
    }
    
    @IBAction func yearsButtonDropDown(_ sender: UIButton) {
        self.dropDownYear.anchorView = sender
        self.dropDownYear.dataSource = [Int](1...60).map{String($0)}
        self.dropDownYear.direction = .bottom
        self.dropDownYear.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.tfYear.text = item
        }
        self.dropDownYear.show()
    }
    @IBAction func both(_ sender: Any) {
        mode = 3
        bothButtonOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        lumpsumButtonOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        sipButtonOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//        bothButtonOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1)
//        lumpsumButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        sipButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        sipButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1), for: .normal)
//        lumpsumButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1), for: .normal)
//        bothButtonOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
    @IBAction func sipButton(_ sender: Any) {
        mode  = 2
        bothButtonOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        lumpsumButtonOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        sipButtonOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
//        bothButtonOutlet.backgroundColor = UIColor.white
//        lumpsumButtonOutlet.backgroundColor = UIColor.white
//        sipButtonOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1)
//        sipButtonOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
//        lumpsumButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1), for: .normal)
//        bothButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1), for: .normal)
    }
    @IBAction func lumpSumButton(_ sender: Any) {
        mode = 1
        bothButtonOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        lumpsumButtonOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        sipButtonOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
//        bothButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        lumpsumButtonOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1)
//        sipButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        sipButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1), for: .normal)
//        lumpsumButtonOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
//        bothButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0.7058823529, blue: 0.9254901961, alpha: 1), for: .normal)
    }
    @IBOutlet weak var lumpsumButtonOutlet: UIButton!
   
    @IBOutlet weak var bothButtonOutlet: UIButton!
    
    @IBOutlet weak var sipButtonOutlet: UIButton!
    func add_pick_investment(){
        presentWindow.makeToastActivity(message: "Loading..")
        if riskTf.text == "High"{
            risk_mode = "H"
        } else if riskTf.text == "Moderately High"{
            risk_mode = "MH"
        } else if riskTf.text == "Moderate"{
            risk_mode = "M"
        }else if riskTf.text == "Moderately Low"{
            risk_mode = "ML"
        }else if riskTf.text == "Low"{
            risk_mode = "L"
        }
        var userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        if flag != "0"{
            userid = flag
        } else{
            userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.add_pick_investment)"
        let parameters = ["package":"\(id_package)","user_id":"\(userid)","goal_year":"\(tfYear.text ?? "")","corpus":"\(investTf.text ?? "")","risk_profile":"\(risk_mode)","investment_type":"\(mode)"] as [String : Any]
        //{"package":"1","user_id":"105856","goal_year":"1","corpus":"4000","risk_profile":"H","investment_type":"3"}
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    //self.presentWindow.hideToastActivity()
                    let data = response.result.value as? Int ?? 0
                    if data == 1 {
                        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "RecommendedFundsViewController") as! RecommendedFundsViewController
                        destVC.invest_value = self.investTf.text ?? ""
                        destVC.mode = self.mode
                        destVC.year = self.tfYear.text!
                        self.navigationController?.pushViewController(destVC, animated: false)
                    }
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getQuestions(){
        question_arr.removeAll()
        answer_arr.removeAll()
        answer_pts.removeAll()
        
        display_answer_pts.removeAll()
        if Connectivity.isConnectedToInternet {
           // self.totalCartValue = 0
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.getriskassessmentset)").responseJSON { response in
                let response = response.result.value as? [[String:Any]] ?? [[:]]
                if !response.isEmpty {
                    for a in response{
                        let question = a["question"] as? String ?? ""
                        let answer = a["answer"] as? String ?? "0"
                        let answer_pts = a["answer_pts"] as? String ?? ""
                        self.question_arr.append(question)
                        self.answer_arr.append(answer)
                        self.answer_pts.append(answer_pts)
                    }
                    let abc = self.answer_arr[0]
                    let dis_arr = abc.components(separatedBy: "||")
                    let dis_arr1 = dis_arr.map  { $0}
                    for (i,d) in dis_arr1.enumerated(){
                        if i == 0 {
                            self.display_answer_arr.append(["title":d, "is_selected":"true"])
                        }else {
                            self.display_answer_arr.append(["title":d, "is_selected":"false"])
                            
                        }
                        
                    }
                    let abcd = self.answer_pts[0]
                    
                    let dis_arr_pts = abcd.components(separatedBy: "||")
                    let dis_arr_pts2 = dis_arr_pts.map  { $0}
                    for i in dis_arr_pts2{
                        self.display_answer_pts.append(i)
                    }
                   // self.questionLabel.attributedText = self.question_arr[0].htmlToAttributedString
                    self.questionLabelHeader.attributedText = self.question_arr[0].htmlToAttributedString
                    self.questionLabelHeader.font = UIFont(name: "Helvetica Neue" , size: 17.0)
                    self.previousQuestionButtonOutlet.isHidden = true
                    self.answerTableView.reloadData()
                }
            }
        } else {
           
            
        }
    }
    
    @IBAction func DontKnowButtonClicked(_ sender: Any) {
        riskProfileView.isHidden = false
        self.display_answer_arr.removeAll()
        self.previouseBtnOutlet.isHidden = true
        self.nextQuestionButtonOutlet.setTitle("Next", for: .normal)
        usr_answer_pts.removeAll()
        selected_answer_index.removeAll()
        count = 0
        getQuestions()
        //answerTableView.reloadData()
    }
    @IBAction func nextQuestionButton(_ sender: UIButton) {
        previousQuestionButtonOutlet.isHidden = false
        
        
        if count == 0 {
            count = sender.tag
        }
        if  sender.currentTitle == "Next"{
        if selected_answer_index.indices.contains(count - 1) {
            selected_answer_index[count - 1] = display_answer_selected_id
            display_answer_selected_id = 0
            usr_answer_pts[count-1] = display_answer_pts[display_answer_selected_id]
        }else {
            
            if display_answer_selected_id > display_answer_pts.count {
                display_answer_selected_id = 0
            }
            selected_answer_index.append(display_answer_selected_id)
            usr_answer_pts[count-1] = display_answer_pts[display_answer_selected_id]
        
        }
    }
        print(selected_answer_index,"next button click",usr_answer_pts)
        display_answer_pts.removeAll()
        self.display_answer_arr.removeAll()
        if count < answer_arr.count {
            let abc = self.answer_arr[count]
            let dis_arr = abc.components(separatedBy: "||")
            let dis_arr1 = dis_arr.map  { $0}
            for (i,d) in dis_arr1.enumerated() {
                if i == 0 {
                    
                    self.display_answer_arr.append(["title":d, "is_selected":"true"])
                }else {
                    self.display_answer_arr.append(["title":d, "is_selected":"false"])
                }
                
            }
            
            let abcd = self.answer_pts[count]
            let dis_arr_pts = abcd.components(separatedBy: "||")
            let dis_arr_pts2 = dis_arr_pts.map  { $0}
            for i in dis_arr_pts2{
                self.display_answer_pts.append(i)
            }
            if count < answer_arr.count {
                questionLabelHeader.attributedText = self.question_arr[count].htmlToAttributedString
                questionLabelHeader.font = UIFont(name: "Helvetica Neue" , size: 17.0)
            }
            count = count + 1
            
            self.answerTableView.reloadData()
            if selected_answer_index.indices.contains(count - 1) {
            let selected_answer_index_previous = selected_answer_index[count-1]
            print(selected_answer_index_previous)
            let index_Path = IndexPath(row: selected_answer_index_previous!, section: 0)
            let cell = answerTableView.cellForRow(at: index_Path)
            cell?.imageView?.image = #imageLiteral(resourceName: "check")
              //  usr_answer_pts.removeAll()
                for (i,d) in display_answer_arr.enumerated() {
                   // self.display_answer_arr[selected_answer_index_previous!]["is_selected"]! = "true"
                    if i == selected_answer_index_previous {
                        self.display_answer_arr[i]["is_selected"]! = "true"
                    } else {
                        self.display_answer_arr[i]["is_selected"]! = "false"
                    }
                }
            }
            self.answerTableView.reloadData()
            if count == 10 {
                sender.setTitle("Submit", for: .normal)
                print(usr_answer_pts,"answerarrusr")
            }
        }else {
            sender.setTitle("Submit", for: .normal)
            print(usr_answer_pts,"answerarrusr")
            submitPickAnswer()
        }
    }
    
    @IBAction func skipQuestion(_ sender: Any) {
        riskProfileView.isHidden = true
        
        count = 0
    }
    @IBAction func previousQuestionButton(_ sender: UIButton) {
        count = count - 1
        self.display_answer_arr.removeAll()
        if count > 0{
            let abc = self.answer_arr[count - 1]
            let dis_arr = abc.components(separatedBy: "||")
            let dis_arr1 = dis_arr.map  { $0}
            for (i,d) in dis_arr1.enumerated() {
//                if i == 0 {
//                    self.display_answer_arr.append(["title":d, "is_selected":"true"])
//                }else {
                    self.display_answer_arr.append(["title":d, "is_selected":"false"])
                //}
                
            }
           
            let abcd = self.answer_pts[count - 1]
            let dis_arr_pts = abcd.components(separatedBy: "||")
            let dis_arr_pts2 = dis_arr_pts.map  { $0}
            for i in dis_arr_pts2{
                self.display_answer_pts.append(i)
            }
            
            
              questionLabelHeader.attributedText = self.question_arr[count - 1].htmlToAttributedString
              questionLabelHeader.font = UIFont(name: "Helvetica Neue" , size: 17.0)
            if count == 1 {
                 previousQuestionButtonOutlet.isHidden = true
            } else if count == 9 {
                nextQuestionButtonOutlet.setTitle("Next", for: .normal)
            }
            self.answerTableView.reloadData()
              if selected_answer_index.indices.contains(count - 1) {
                let selected_answer_index_previous = selected_answer_index[count-1]
                print(selected_answer_index_previous)
                let index_Path = IndexPath(row: selected_answer_index_previous!, section: 0)
                let cell = answerTableView.cellForRow(at: index_Path)
                cell?.imageView?.image = #imageLiteral(resourceName: "check")
                self.display_answer_arr[selected_answer_index_previous!]["is_selected"]! = "true"
            }
        }else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display_answer_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell")
        if display_answer_arr[indexPath.row]["is_selected"]! == "true"{
            cell?.imageView?.image = #imageLiteral(resourceName: "check")
            print(count,"count data")
            if usr_answer_pts.indices.contains(count-1) {
                usr_answer_pts[count-1] = display_answer_pts[indexPath.row]
            }else {
                usr_answer_pts.append(display_answer_pts[indexPath.row])
            }
        }else {
            cell?.imageView?.image = #imageLiteral(resourceName: "uncheck")
        }
        cell?.textLabel?.text = display_answer_arr[indexPath.row]["title"]!
        cell?.textLabel?.font =  UIFont.init(name: "Helvetica Neue", size: 17)
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print(usr_answer_pts,"didselect")
        print(display_answer_arr)
        for (index, element) in display_answer_arr.enumerated() {
            
            print(index," $$index")
            let index_Path = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: index_Path)
            if index == indexPath.row {
                 display_answer_arr[index]["is_selected"]! = "true"
                 display_answer_selected_id = index
                //usr_answer_pts.append(display_answer_pts[indexPath.row])
                 cell?.imageView?.image = #imageLiteral(resourceName: "check")
            }else {
                    display_answer_arr[index]["is_selected"]! = "false"
                    //usr_answer_pts.append(display_answer_pts[indexPath.row])
                    cell?.imageView?.image = #imageLiteral(resourceName: "uncheck")
            }
        }
        print(usr_answer_pts)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func submitPickAnswer(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading..")
        let  url = "\(Constants.BASE_URL)\(Constants.API.adduserriskassessment)"
        let intArray = usr_answer_pts.map { Int($0)!}
        let sum = intArray.reduce(0, +)
        let parameters = ["userid":"\(userid!)",
            "question_set":"1",
            "q1_answer":"\(usr_answer_pts[0])",
            "q2_answer":"\(usr_answer_pts[1])",
            "q3_answer":"\(usr_answer_pts[2])",
            "q4_answer":"\(usr_answer_pts[3])",
            "q5_answer":"\(usr_answer_pts[4])",
            "q6_answer":"\(usr_answer_pts[5])",
            "q7_answer":"\(usr_answer_pts[6])",
            "q8_answer":"\(usr_answer_pts[7])",
            "q9_answer":"\(usr_answer_pts[8])",
            "q10_answer":"\(usr_answer_pts[9])","total_pts":"\(sum)"
            ] as [String : Any]
            print(parameters)
        //{"package":"1","user_id":"105856","goal_year":"1","corpus":"4000","risk_profile":"H","investment_type":"3"}
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    let response = response.result.value as? String ?? ""
                    if response != "" {
                        self.getriskprofile()
                    }else {
                        self.presentWindow.hideToastActivity()
                        self.riskProfileView.isHidden = true
                        self.riskTf.text = "Moderate"
                    }
            }
        }
    }
    func getriskprofile(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getriskprofile)\(userid!)"
        if Connectivity.isConnectedToInternet {
            // self.totalCartValue = 0
            Alamofire.request("\(url)").responseJSON { response in
                print(response.result.value)
                let data = response.result.value as? [String:Any]
                let risk_profile = data?["risk_profile"] as? String ?? ""
                if risk_profile !=  ""{
                    self.presentWindow.hideToastActivity()
                    self.riskProfileView.isHidden = true
                    if risk_profile == "Very Aggressive"{
                         self.riskTf.text = "High"
                    }else if risk_profile == "Aggressive"{
                         self.riskTf.text = "Moderately High"
                    }else if risk_profile == "Assertive(Growth)"{
                         self.riskTf.text = "Moderate"
                    }else if risk_profile == "Balanced"{
                        self.riskTf.text = "Moderately Low"
                    }else if risk_profile == "Conservative"{
                        self.riskTf.text = "Low"
                    }
                    //self.usr_answer_pts.removeAll()
                    
                }else {
                    self.presentWindow.hideToastActivity()
                    self.riskProfileView.isHidden = true
                    self.riskTf.text = "Moderate"
                    
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == investTf {
            if textField.text?.count == 0 && string == "0" {
                return false
            }else {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
            }
        }
        return true
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
