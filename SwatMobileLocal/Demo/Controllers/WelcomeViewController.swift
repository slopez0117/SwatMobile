//
//  WelcomeViewController.swift
//  Demo
//
//  Created by Julian Gonzalez on 4/24/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.delegate = self
        TableView.dataSource = self
        
        //setting up swarthmore logo to be displayed in navigation bar
        let swarthmoreLogo = UIImage(named: "swarthmore_logo")
        navigationItem.titleView = UIImageView(image: swarthmoreLogo)
        navigationItem.titleView?.layer.cornerRadius = 15
        navigationItem.titleView?.layer.masksToBounds = true
        
    }

}

extension WelcomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row == 0{
            //if second table view cell is clicked
            UIApplication.shared.open(URL(string: "https://dash.swarthmore.edu/")! as URL, options: [:], completionHandler: nil)
        }
        if indexPath.row == 1{
            //if second table view cell is clicked
            UIApplication.shared.open(URL(string: "https://www.facebook.com/groups/595460011369319")! as URL, options: [:], completionHandler: nil)
        }
        if indexPath.row == 2{
            //if second table view cell is clicked
            UIApplication.shared.open(URL(string: "https://www.facebook.com/slopezval/")! as URL, options: [:], completionHandler: nil)
        }
        TableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WelcomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return 1 since there will only be one row opulated by the welcome message
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeMessage", for: indexPath) as! eventTableViewCell
        
        cell.roundImage()
        if indexPath.row == 0{
            cell.cellTextLabel.text = "Welcome to SwatMobile! Here you can find multiple user-friendly features to navigate college resources such as campus events and monthly dining options. The app supports the ability to add selected events to your calendar or invite a friend to a specified meal. I am currently working on improving existing features and bringing more resources to this app to help you navigate campus life."
            cell.cellTimeLabel.text = "Tap here to go to the Dash. Below you will find additional information and resources."
            //image config
            let image =  UIImage(named: "GarnetBackground")
            cell.cellImage.image = image!
        }
        
        else if indexPath.row == 1{
            cell.cellTextLabel.text = "Join the student-run facebook group to stay on top of campus updates and student activities."
            cell.cellTimeLabel.text = "Tap here to view the group on facebook."
            //image config
            let image =  UIImage(named: "fbBackground")
            cell.cellImage.image = image!
        }
        
        else if indexPath.row == 2{
            cell.cellTextLabel.text = "As you may have noticed, many of the current features are greatly limited and there is still much to improve on. Please share your suggestions/ideas/app experiences with me through facebook."
            cell.cellTimeLabel.text = "Tap here to be directed to my facebook profile."
            //image config
            let image =  UIImage(named: "GarnetBackground")
            cell.cellImage.image = image!
        }
        
        return cell
        
    }
}
