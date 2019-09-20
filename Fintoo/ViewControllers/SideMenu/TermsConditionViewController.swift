//
//  TermsConditionViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 13/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class TermsConditionViewController: BaseViewController {
    
    
    var id :String!
    
    @IBOutlet weak var textview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        self.textview.scrollRangeToVisible(NSMakeRange(0, 0))
        print(id)
        print("hello")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        if id == "12"{
            navigationController?.popViewController(animated: true)
            
        }
        else{
             self.textview.scrollRangeToVisible(NSMakeRange(0, 0))
            dismiss(animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
