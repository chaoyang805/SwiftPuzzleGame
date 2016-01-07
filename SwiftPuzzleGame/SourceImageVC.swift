//
//  SourceImageVC.swift
//  SwiftPuzzleGame
//
//  Created by chaoyang805 on 16/1/6.
//  Copyright © 2016年 com.jikexueyuan. All rights reserved.
//

import Foundation
import UIKit
class SourceImageVC : UIViewController{
    
    @IBOutlet var sourceImage:UIImageView?
    @IBOutlet var backBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Config.currentImage != nil {
            sourceImage!.image = UIImage(CGImage: Config.currentImage!)
        }
    }
    
    @IBAction func backBtnClicked(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}