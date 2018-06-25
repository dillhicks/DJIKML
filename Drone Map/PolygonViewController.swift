//
//  PolygonViewController.swift
//  Drone Map
//
//  Created by Dillon on 6/6/18.
//  Copyright © 2018 E4E. All rights reserved.
//

import UIKit
import GoogleMaps

class PolygonViewController: UIViewController {
    func initViewController() -> ViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        return firstViewController
    }
    @IBOutlet weak var generatePolyButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func generatePoly_TouchUpInside(_ sender: Any) {
        let firstViewController = initViewController()
            firstViewController.polygonConversion()
        
    }
    @IBOutlet weak var generateRandom_TouchUpInside: UIButton!
    
    @IBAction func test(_ sender: Any) {
        let firstViewController = initViewController()
           // firstViewController.test = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
