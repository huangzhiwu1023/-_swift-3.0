//
//  ViewController.swift
//  xinxin
//
//  Created by zwj on 17/1/4.
//  Copyright © 2017年 zwj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //()
      WSStar.starView.StarInView(view: self.view, rect: CGRect(x: 120, y: 80, width: 125, height: 30), currentStars: 3.5, allStars: 5, isContrainsHalfStar: false, isVariable: false)

        WSStar.starView.starNum = {(num) in
        print("==\(num)")
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

