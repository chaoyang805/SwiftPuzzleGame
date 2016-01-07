//
//  Card.swift
//  SwiftPuzzleGame
//
//  Created by chaoyang805 on 16/1/5.
//  Copyright © 2016年 com.jikexueyuan All rights reserved.
//

import Foundation
import UIKit
class Card:UIImageView{
    let CARD_WIDTH:CGFloat = 70
    let CARD_HEIGHT:CGFloat = 70
    
    var rightIndexI:CGFloat = 0,rightIndexJ:CGFloat = 0,indexI:CGFloat = 0,indexJ:CGFloat = 0
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.frame = CGRectMake(0, 0,CARD_WIDTH,CARD_HEIGHT)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //将card移动到i，j的位置
    func moveToPositionByIndexIJ(moveEnd:Selector,target:AnyObject?){
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            var f:CGRect = self.frame
            f.origin.x = self.indexI * self.CARD_WIDTH
            f.origin.y = self.indexJ * self.CARD_HEIGHT
            self.frame = f
            } , completion: { (Bool) -> Void in
                //动画完成后执行的内容
                if target != nil {
                    target!.performSelector(moveEnd)
                }
                
        })
    }
    
    // 根据Index重置Card的位置
    func resetPositionByIndexIJ(){
        var f:CGRect = self.frame
        f.origin.x = indexI * CARD_WIDTH
        f.origin.y = indexJ * CARD_HEIGHT
        self.frame = f
    }
    
    
    //卡片是否在正确的位置
    func onRightPlace()->Bool{
        return rightIndexI == indexI && rightIndexJ == indexJ
    }
}