//
//  ContactUsViewController.swift
//  Minty
//
//  Created by iosdevelopermme on 06/12/17.
//  Copyright © 2017 iosdevelopermme. All rights reserved.
//

import UIKit
import GoogleMaps
import MessageUI
//import Mixpanel
//import Google

class ContactUsViewController: BaseViewController,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "CONTACT US"
        addBackbutton()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContactUsViewController.tapFunction))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ContactUsViewController.email))
        callLabel.isUserInteractionEnabled = true
        callLabel.addGestureRecognizer(tap)
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(tap1)
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @objc func email(){
        print("email")
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Query Regarding:")
       
        picker.setToRecipients([emailLabel.text!])
        
        present(picker, animated: true, completion: nil)
        //Mixpanel.mainInstance().track(event: "Contact Us Screen :- Email Selected")
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
       // Mixpanel.mainInstance().track(event: "Contact Us Screen :- Cancel Pressed")
    }
    @objc func tapFunction(){
        let abc = callLabel.text
        let url: NSURL = URL(string: "TEL://\(abc!)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
       // Mixpanel.mainInstance().track(event: "Contact Us Screen :- Tapped On Call")
    }
    @objc func back()
    {
       // Mixpanel.mainInstance().track(event: "Contact Us Screen :- Back Button")
         navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.settings.zoomGestures = true
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        mapView.settings.compassButton = true
        
        mapView.isUserInteractionEnabled = true
        mapView.isMultipleTouchEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: 19.1151216,
                                              longitude: 72.8613308,
                                              zoom: 12)
        mapView.camera = camera

        let position = CLLocationCoordinate2D(latitude: 19.1151216, longitude: 72.8613308)
        let marker = GMSMarker(position: position)
        marker.title = "Financial Hospital"
        marker.map = mapView

        
    }
   

}

