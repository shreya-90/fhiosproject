//
//  AboutUsViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 04/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    @IBOutlet weak var textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
   self.textview.scrollRangeToVisible(NSMakeRange(0, 0))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
