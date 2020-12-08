//
//  ViewController.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 3/25/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //table view for holding cells that will function as buttons that will segue into the other additionbal views when pressed
    @IBOutlet weak var homeTableView: UITableView!
    
    //view constraint outlets that will be shifted to make the menu appear
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    //side menu option button outlets
    @IBOutlet weak var welcomeButton: UIButton!
    @IBOutlet weak var sharplesButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    
    //menu var to indicate wether the menu is out
    var menuOut = false
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        //setting up swarthmore logo to be displayed in navigation bar
        let swarthmoreLogo = UIImage(named: "swarthmore_logo")
        navigationItem.titleView = UIImageView(image: swarthmoreLogo)
        navigationItem.titleView?.layer.cornerRadius = 15
        navigationItem.titleView?.layer.masksToBounds = true
        
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
        if menuOut == false {
            //if menu isn't out, proceed to shift view constraints to display it
            leading.constant = 150
            trailing.constant = -150
            menuOut = true
        }
        else{
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        
        //animation code that animates the side bar menu when it is opened/closed
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    //ibaction functions for when menu buttons are pressed
    @IBAction func welcomePressed(_ sender: Any){
         performSegue(withIdentifier: "goToWelcome", sender: self)
    }
    @IBAction func sharplesPressed(_ sender: Any){
        performSegue(withIdentifier: "goToSharples", sender: self)
    }
    @IBAction func eventsPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEvents", sender: self)
    }
    @IBAction func mapPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0{
            performSegue(withIdentifier: "goToWelcome", sender: self)
        }
        else if indexPath.row == 1{
            performSegue(withIdentifier: "goToSharples", sender: self)
        }
        else if indexPath.row == 2{
            performSegue(withIdentifier: "goToEvents", sender: self)
        }
        else if indexPath.row == 3{
            performSegue(withIdentifier: "goToMap", sender: self)
        }
        
        homeTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tableViewCell is no longer a default prototype, but is of the class we created -> eventTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "homePageCell", for: indexPath) as! eventTableViewCell
        
        if indexPath.row == 0{
            cell.cellTextLabel.text = "Welcome"
            let image =  UIImage(named: "WelcomeCell")
            cell.cellImage.image = image!
            cell.roundImage()
        }
        else if indexPath.row == 1{
            cell.cellTextLabel.text = "Sharples"
            let image =  UIImage(named: "sharplesCell")
            cell.cellImage.image = image!
            cell.roundImage()
        }
        else if indexPath.row == 2{
            cell.cellTextLabel.text = "Events"
            let image =  UIImage(named: "EventCell")
            cell.cellImage.image = image!
            cell.roundImage()
        }
        else if indexPath.row == 3{
            cell.cellTextLabel.text = "Campus Map"
            let image =  UIImage(named: "WelcomeCell")
            cell.cellImage.image = image!
            cell.roundImage()
        }
        
        
        
        return cell
    }
}
