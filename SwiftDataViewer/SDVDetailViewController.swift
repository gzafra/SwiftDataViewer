//
//  SDVDetailViewController.swift
//  SwiftDataViewer
//
//  Created by Guillermo Zafra on 20/06/16.
//
//

import UIKit

class SDVDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var jackpotLabel : UILabel!
    
    var jsonItem : SDVJsonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateLabel.text = jsonItem?.itemDate.asLocaleDate;
        jackpotLabel.text = jsonItem?.jackpot.asLocaleCurrency
        navigationItem.title = jsonItem?.itemName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions

}
