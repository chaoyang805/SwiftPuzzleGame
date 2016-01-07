//
//  ImageData.swift
//  SwiftPuzzleGame
//
//  Created by chaoyang805 on 16/1/6.
//  Copyright © 2016年 com.jikexueyuan. All rights reserved.
//

import Foundation
class ImageData:NSObject {
    static var innerImgs:NSArray!
    static var imgIndex = -1
    class func nextInnerImg()->String{
        imgIndex++
        if imgIndex > getInnerImgs().count - 1 {
            imgIndex = 0
        }
        NSLog("setImage\(imgIndex)")
        return getInnerImgs().objectAtIndex(imgIndex) as! String
        
    }
    //static var imgArr = ["img1.jpg","img2.jpg","img3.jpg","img4.jpg","img5.jpg","img6.jpg"]
    class func getInnerImgs()->NSArray{
            innerImgs = NSDictionary(contentsOfURL:
                NSBundle.mainBundle().URLForResource("innerimgs", withExtension: "plist")!)!
                        .objectForKey("imgs") as! NSArray
        return innerImgs
    }
}