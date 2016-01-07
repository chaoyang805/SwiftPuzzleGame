//
//  GameView.swift
//  SwiftPuzzleGame
//
//  Created by chaoyang805 on 16/1/5.
//  Copyright © 2016年 com.jikexueyuan. All rights reserved.
//

import Foundation
import UIKit
class GameView : UIView{
    
    let DIR_LEFT = 1
    let DIR_UP = 2
    let DIR_RIGHT = 3
    let DIR_DOWN = 4
    let DIR_NONE = 5
    
    var lastDirection:Int
    
    var currentImageWidth:Int = 0
    var currentImageHeight:Int = 0
    var currentImagePicWidth:Int = 0
    var currentImagePicHeight:Int = 0
    
    var currentNullIndexI:Int = Config.H_COUNT - 1
    var currentNullIndexJ:Int = Config.V_COUNT - 1
    var gameImage:CGImageRef?
    var threeDoubles = [Double](count: 3, repeatedValue: 0.0)
    
    var cards = CardsMap<Card?>(Rows: Config.H_COUNT, Columns: Config.V_COUNT)
    var picsArr:NSMutableArray
    
    var isBreaking:Bool = false
    
    var success:Bool = false
    
    //自动移动卡片的位置数组
    var autoMoveCardDirArr:NSMutableArray
    
    required init?(coder aDecoder: NSCoder) {
        lastDirection = DIR_NONE
        picsArr = NSMutableArray()
        autoMoveCardDirArr = NSMutableArray()
        self.isBreaking = false
        super.init(coder: aDecoder)
        
    }
    
    override func touchesBegan(var touches: Set<UITouch>, withEvent event: UIEvent?) {
        if success {
            setGameImg(Config.currentImage!)
            success = false
        }
        let touch:UITouch = touches.popFirst()!
        let point:CGPoint = touch.locationInView(self)
        let indexI = Int(point.x / Config.CARD_WIDTH)
        let indexJ = Int(point.y / Config.CARD_HEIGHT)
        //如果触摸点超出边界区域，直接返回
        if indexI < 0 || indexI > Config.H_COUNT - 1 || indexJ < 0 || indexJ > Config.V_COUNT - 1 {
            return
        }
        //如果触摸到空白的卡片，直接返回
        if currentNullIndexI == indexI && currentNullIndexJ == indexJ {
            return
        }
        var touchedCard:Card = cards[indexI,indexJ]!!
        let checkSuccessHandler = Selector("checkSuccessHandler")
        let dir:Int = getDirection(touchedCard)
        switch(dir){
        case DIR_LEFT:
            //将当前位置的卡片赋值为nil
            cards[indexI,indexJ] = nil
            //记录nil位置的index
            currentNullIndexI = indexI
            currentNullIndexJ = indexJ
            //将当前位置的卡片移动赋值给左边的卡片
            cards[indexI - 1,indexJ] = touchedCard
            //并修改卡片的index为左边的index
            touchedCard.indexI = CGFloat(indexI - 1)
            touchedCard.indexJ = CGFloat(indexJ)
            //调用卡片的motoPosition方法,移动结束后执行checkSuccessHanlder方法
            touchedCard.moveToPositionByIndexIJ(checkSuccessHandler, target: self)
        case DIR_RIGHT:
            cards[indexI,indexJ] = nil
            currentNullIndexI = indexI
            currentNullIndexJ = indexJ
            cards[indexI + 1,indexJ] = touchedCard
            touchedCard.indexI = CGFloat(indexI + 1)
            touchedCard.indexJ = CGFloat(indexJ)
            touchedCard.moveToPositionByIndexIJ(checkSuccessHandler, target: self)
        case DIR_UP:
            cards[indexI,indexJ] = nil
            currentNullIndexI = indexI
            currentNullIndexJ = indexJ
            cards[indexI,indexJ - 1] = touchedCard
            touchedCard.indexI = CGFloat(indexI)
            touchedCard.indexJ = CGFloat(indexJ - 1)
            touchedCard.moveToPositionByIndexIJ(checkSuccessHandler, target: self)
        case DIR_DOWN:
            cards[indexI,indexJ] = nil
            currentNullIndexI = indexI
            currentNullIndexJ = indexJ
            cards[indexI,indexJ + 1] = touchedCard
            touchedCard.indexI = CGFloat(indexI)
            touchedCard.indexJ = CGFloat(indexJ + 1)
            touchedCard.moveToPositionByIndexIJ(checkSuccessHandler, target: self)
        default:
            
            break
            
        }
        
    }
    /*
    * 卡片移动结束检查是否成功
    */
    func checkSuccessHandler(){
        if checkSuccess() {
            self.addSubview(picsArr.lastObject! as! Card)
            success = true
            UIAlertView(title: "恭喜你", message: "拼图成功", delegate: self, cancelButtonTitle: "关闭").show()
        }
    }
    
    func setGameImg(image:CGImageRef){
        gameImage = image
        Config.currentImage = image
        //清空场景
        for picture in picsArr {
            picture.removeFromSuperview()
        }
        //移除数组中的所有元素
        picsArr.removeAllObjects()
        //重新配置新图片的宽高
        currentImageWidth = CGImageGetWidth(image)
        currentImageHeight = CGImageGetHeight(image)
        currentImagePicWidth = currentImageWidth / Config.H_COUNT
        currentImagePicHeight = currentImageHeight / Config.V_COUNT
        //创建矩形和卡片对象
        var rect:CGRect = CGRectMake(0, 0,
            CGFloat(currentImagePicWidth) ,
            CGFloat(currentImagePicHeight))
        var card:Card
        //循环添加card
        for i in 0..<Config.H_COUNT {
            for j in 0..<Config.V_COUNT {
                    
                    rect.origin.x = CGFloat(currentImagePicWidth * i)
                    rect.origin.y = CGFloat(currentImagePicHeight * j)
                    card = Card(image: UIImage(CGImage: CGImageCreateWithImageInRect(gameImage, rect)!))
                    card.indexI = CGFloat(i)
                    card.indexJ = CGFloat(j)
                    card.rightIndexI = CGFloat(i)
                    card.rightIndexJ = CGFloat(j)
                    card.resetPositionByIndexIJ()
                
                    picsArr.addObject(card)
                
                if i < Config.H_COUNT - 1 || j < Config.V_COUNT - 1 {
                    //将卡片添加到当前的view上
                    self.addSubview(card)
                    //并将卡片按对应位置放到二维数组里
                    NSLog("index:\(i),\(j)")
                    cards[i,j] = card
                }
            }
            //将空位置放在最后一个
            currentNullIndexI = Config.H_COUNT - 1
            currentNullIndexJ = Config.V_COUNT - 1
            cards[currentNullIndexI,currentNullIndexJ] = nil
        }
        
    }
    /**
    * 获得卡片可以移动的方向
    */
    func getDirection(card:Card)->Int{
        let indexI:Int = Int(card.indexI)
        let indexJ:Int = Int(card.indexJ)
        //如果indexI大于0且左边的元素为nil，则方向为左
        if indexI > 0 && cards[indexI - 1,indexJ] == nil {
            return DIR_LEFT
        }
        //如果indexI小于行数且右边的元素为nil，则方向为右
        if indexI < Config.H_COUNT - 1 && cards[indexI + 1,indexJ] == nil {
            return DIR_RIGHT
        }
        //如果indexJ大于0，且上边的元素为nil，方向为上
        if indexJ > 0 && cards[indexI,indexJ - 1] == nil {
            return DIR_UP
        }
        //如果indexJ小于列数，且下边的元素为nil，方向为下
        if indexJ < Config.V_COUNT - 1 && cards[indexI,indexJ + 1] == nil {
            return DIR_DOWN
        }
        return DIR_NONE
    }
    //开始打乱卡片
    func startBreak(){
        if !isBreaking {
            isBreaking = true
            self.breakCard()
        }
    }
    
    //停止打乱卡片
    func stopBreak(){
        isBreaking = false
    }
    
    /*
    *  随机返回空白卡片可以移动到的下一个位置
    */
    func getAutoMoveCardDir()->Int{
        //移除所有的元素
        autoMoveCardDirArr.removeAllObjects()
        if currentNullIndexI > 0 && lastDirection != DIR_RIGHT {
            autoMoveCardDirArr.addObject(DIR_LEFT)
        }
        if currentNullIndexJ > 0 && lastDirection != DIR_DOWN {
            autoMoveCardDirArr.addObject(DIR_UP)
        }
        if currentNullIndexI < Config.H_COUNT - 1 && lastDirection != DIR_LEFT {
            autoMoveCardDirArr.addObject(DIR_RIGHT)
        }
        if currentNullIndexJ < Config.V_COUNT - 1 && lastDirection != DIR_UP {
            autoMoveCardDirArr.addObject(DIR_DOWN)
        }
        let index:Int = Int(arc4random_uniform(UInt32(autoMoveCardDirArr.count)))
        
        lastDirection = autoMoveCardDirArr.objectAtIndex(index) as! Int
        return lastDirection
    }
    
    //打乱卡片
    func breakCard(){
        let direction = self.getAutoMoveCardDir()
        var currentCard:Card
        let cardMoveEndHandler = Selector("cardMoveEndHandler")
        switch(direction){
        case DIR_UP:
            //当前需要替换的卡片为空白卡片的上一个
            currentCard = cards[currentNullIndexI,currentNullIndexJ - 1]!!
            //将需要替换的卡片放到原来空白位置
            cards[currentNullIndexI,currentNullIndexJ] = currentCard
            //将需要替换的卡片的位置设置为nil
            cards[currentNullIndexI,currentNullIndexJ - 1] = nil
            //修改移动后的卡片的index
            currentCard.indexI = CGFloat(currentNullIndexI)
            currentCard.indexJ = CGFloat(currentNullIndexJ)
            //重新设置空白卡片的index
            currentNullIndexJ -= 1
            //使用动画移动当前卡片到指定位置
            currentCard.moveToPositionByIndexIJ(cardMoveEndHandler, target: self)
        case DIR_DOWN:
            currentCard = cards[currentNullIndexI,currentNullIndexJ + 1]!!
            cards[currentNullIndexI,currentNullIndexJ] = currentCard
            cards[currentNullIndexI,currentNullIndexJ + 1] = nil
            currentCard.indexI = CGFloat(currentNullIndexI)
            currentCard.indexJ = CGFloat(currentNullIndexJ)
            currentNullIndexJ += 1
            currentCard.moveToPositionByIndexIJ(cardMoveEndHandler, target: self)
        case DIR_LEFT:
            currentCard = cards[currentNullIndexI - 1,currentNullIndexJ]!!
            cards[currentNullIndexI,currentNullIndexJ] = currentCard
            cards[currentNullIndexI - 1,currentNullIndexJ] = nil
            currentCard.indexI = CGFloat(currentNullIndexI)
            currentCard.indexJ = CGFloat(currentNullIndexJ)
            currentNullIndexI -= 1
            currentCard.moveToPositionByIndexIJ(cardMoveEndHandler, target: self)
        case DIR_RIGHT:
            currentCard = cards[currentNullIndexI + 1,currentNullIndexJ]!!
            cards[currentNullIndexI,currentNullIndexJ] = currentCard
            cards[currentNullIndexI + 1,currentNullIndexJ] = nil
            currentCard.indexI = CGFloat(currentNullIndexI)
            currentCard.indexJ = CGFloat(currentNullIndexJ)
            currentNullIndexI += 1
            currentCard.moveToPositionByIndexIJ(cardMoveEndHandler, target: self)
        default:

            break
            
        }
    }
    /*
    * 卡片移动结束后如果还在打乱的状态，继续执行breakCard
    *
    */
    func cardMoveEndHandler(){
        if isBreaking {
            self.breakCard()
        }
    }
    
     /**
     *检查是否成功
     *
     */
    func checkSuccess()->Bool{
        var card:Card
        for index in 0..<picsArr.count {
             card = picsArr.objectAtIndex(index) as! Card
            if !card.onRightPlace() {
                return false
            }
        }
        return true
    }
    
    
    
    //检查是否成功并呈现对话框
    func checkSuccessAndShowDialog(){
        if checkSuccess() {
            UIAlertView(title: "恭喜你", message: "拼图成功", delegate: self, cancelButtonTitle: "关闭").show()
            
        }
    }

}