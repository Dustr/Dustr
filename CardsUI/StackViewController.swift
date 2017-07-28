//
//  StackViewController.swift
//  CardsUI
//
//  Created by Hamza Ghani on 7/27/17.
//  Copyright © 2017 dustr. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {

    
    @IBOutlet weak var headerLabel: UILabel!
    var headerString:String? {
        
        didSet {
            configureView()
        }
        
    }
    
    func configureView() {
        headerLabel.text = headerString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
