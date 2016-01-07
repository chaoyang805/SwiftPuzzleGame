//
//  ViewController.swift
//  SwiftPuzzleGame
//
//  Created by chaoyang805 on 16/1/5.
//  Copyright © 2016年 com.jikexueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var gameView:GameView!
    @IBOutlet var sourceBtn:UIButton!
    @IBOutlet var breakBtn:UIButton!
    @IBOutlet var changeBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageStr = ImageData.nextInnerImg()
        NSLog("viewDidLoad,setImage:\(imageStr)")
        let image = UIImage(named: imageStr)?.CGImage
        //let image:CGImage? = (UIImage(named:imageStr)?.CGImage!)!
        if let cfImage = image {
            gameView.setGameImg(cfImage)
        }
        
    }
    var breakState:Int = 1
    @IBAction func btnBreakHandler(sender:AnyObject){
        switch(breakState){
        //处于停止状态，开始将图片打乱
        case 1:
            NSLog("开始打乱")
            breakState = 2
            sourceBtn.hidden = true
            changeBtn.hidden = true
            
            breakBtn.setTitle("停止", forState: UIControlState.Normal)
            gameView.startBreak()
        case 2:
            NSLog("停止打乱")
            breakState = 1
            sourceBtn.hidden = false
            changeBtn.hidden = false
            
            breakBtn.setTitle("打乱", forState: UIControlState.Normal)
            gameView.stopBreak()
        default:
            break
        }
    }
    
    @IBAction func btnSourceImageHandler(sender:AnyObject){
        
    }
    
    @IBAction func btnChangeImageHandler(sender: AnyObject) {
        //
        UIActionSheet(title: "请选择图片来源", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"内置图片","照像机","图库","相册").showInView(self.view)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("ActionSheet Clicked,\(buttonIndex)")
        var upc:UIImagePickerController
        switch(buttonIndex){
        case 1://内置图片
            gameView.setGameImg(UIImage(named: ImageData.nextInnerImg())!.CGImage!)
        case 2://相机
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                upc = UIImagePickerController()
                upc.sourceType = UIImagePickerControllerSourceType.Camera
                upc.delegate = self
                self.presentViewController(upc, animated: true, completion: { () -> Void in
                    //
                })
            }else {
                let alert = UIAlertController.init(title: "提示", message: "您的设备没有摄像头", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction.init(title: "好", style: UIAlertActionStyle.Default, handler: {
                            (UIAlertAction)->Void in
                                //
                            })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion:nil)
            }
        case 3://图库
            upc = UIImagePickerController()
            upc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            upc.delegate = self
            self.presentViewController(upc, animated: true, completion: nil)
        case 4://相册
            upc = UIImagePickerController()
            upc.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            upc.delegate = self
            self.presentViewController(upc,animated: true,completion: nil)
        default:
            break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let width = CGImageGetWidth(image.CGImage)
        let height = CGImageGetHeight(image.CGImage)
        let minValue = CGFloat(min(width, height))
        if minValue > 320 {
            let imageWidth = CGFloat(320)
            let imageCopy:CGImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, minValue, minValue))!
            let newImage = UIImage(CGImage: imageCopy)
            
            UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageWidth))
            newImage.drawInRect(CGRectMake(0, 0, imageWidth, imageWidth))
            gameView.setGameImg(UIGraphicsGetImageFromCurrentImageContext().CGImage!)
            UIGraphicsEndImageContext()
        } else {
            gameView.setGameImg(image.CGImage!)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

