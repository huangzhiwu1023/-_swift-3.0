//
//  WSStar.swift
//  xinxin
//
//  Created by zwj on 17/1/4.
//  Copyright © 2017年 zwj. All rights reserved.
//

/**
 使用方法：
 如：WSStar.starView.StarInView(view: self.view, rect: CGRect(x: 120, y: 80, width: 125, height: 30), currentStars: 3.5, allStars: 5, isContrainsHalfStar: false, isVariable: false)
 参数：        view:需要加载的View
 rect:
 currentStars:当前需要显示的星
 allStar:总共需要多少星
 isContrainsHalfStar:是否包含一半个的星
 isVariable:是否可以点
 
 一般情况：
 评价时：isContrainsHalfStar :flase isVariable:true
 显示平均评价分：isContrainsHalfStar :true isVariable:flase
 */

import UIKit

protocol WSStarDelete : class {
    func didChangeStar()
}
typealias starNum = (_ backMsg :CGFloat) -> ()//目前几颗星

class WSStar: UIView {
    var fullScore: CGFloat?//评分的满分值，默认为1
    var actualScore : CGFloat?//评分的实际分数，默认为1
    var isContrainsHalfStar:Bool?//是否包含半颗星，默认为NO
    weak var delegate : WSStarDelete?
    
    
    fileprivate lazy var frontView = UIView()
    fileprivate lazy var backgroundView = UIView()
    var starNum: starNum!
    
    fileprivate var numberOfStars : CGFloat?
    fileprivate var isvariadle : Bool?
    
    static let starView = WSStar()
    
    func
        StarInView(view:UIView,rect:CGRect,currentStars:CGFloat,allStars:CGFloat,isContrainsHalfStar:Bool, isVariable:Bool) {
        // WSStar.starView.backgroundColor = UIColor.orange
        WSStar.starView.numberOfStars = currentStars
        WSStar.starView.frame = rect
        WSStar.starView.fullScore = (CGFloat)(allStars)
        WSStar.starView.actualScore = 1//最低1星
        WSStar.starView.isContrainsHalfStar = isContrainsHalfStar
        WSStar.starView.backgroundView = WSStar.starView.createStarViewWithImage(image: "star_gray.png", currentStars:allStars,allStars:allStars ,isHA: isContrainsHalfStar)
        
        WSStar.starView.frontView = WSStar.starView.createStarViewWithImage(image: "star_yellow.png", currentStars:currentStars,allStars:allStars,isHA: isContrainsHalfStar)
        //        WSStar.starView.backgroundView.backgroundColor = UIColor.red
        //        WSStar.starView.frontView.backgroundColor = UIColor.blue
        WSStar.starView.addSubview(WSStar.starView.backgroundView)
        WSStar.starView.addSubview(WSStar.starView.frontView)
        if isVariable == true {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(tap:)))
            self.addGestureRecognizer(tap)  }
        view.addSubview(WSStar.starView)
        
    }
    
    
    func tapClick(tap:UITapGestureRecognizer) {
        let point:CGPoint = tap.location(in: self)
        let offset:CGFloat = point.x
        var offsetPerecent = offset/self.bounds.size.width
        if self.isContrainsHalfStar != true {
            offsetPerecent = self.changeToComleteStar(precent: offsetPerecent, allStar: self.fullScore!)
        }
        self.actualScore = offsetPerecent * self.fullScore! == 0 ? 1:offsetPerecent * self.fullScore!
        
        //  print("....(\(self.actualScore))")
        WSStar.starView.frontView.removeFromSuperview()
        WSStar.starView.frontView = WSStar.starView.createStarViewWithImage(image: "star_yellow.png", currentStars:self.actualScore!,allStars:(self.fullScore!) ,isHA: self.isContrainsHalfStar!)
        //
        if isContrainsHalfStar == true {
            // self.frontView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width/self.actualScore!, height: self.bounds.size.height)
        }
        WSStar.starView.addSubview(WSStar.starView.frontView)
        self.starNum((self.actualScore!))
        self.setNeedsLayout()
        
        //[self.delegate didChangeStar];
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if ((Float)(self.actualScore!) > (Float)(self.fullScore!)) {
            self.actualScore = self.fullScore
        }else if (Float)(self.actualScore!) < 0 {
            self.actualScore = 0
        }else{
            //        self.actualScore = self.actualScore
        }
        var scorePercent = self.actualScore! / self.fullScore!
        if self.isContrainsHalfStar != true {
            scorePercent = changeToComleteStar(precent: scorePercent, allStar: self.fullScore!)
        }
        // self.frontView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width/scorePercent, height: self.bounds.size.height)
    }
    
}

extension WSStar {
    func createStarViewWithImage(image:String,currentStars:CGFloat,allStars:CGFloat,isHA:Bool) ->(UIView){
        let view = UIView()//.init(frame: self.bounds)
        var star = currentStars-1
        if isHA {
            view.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width*(currentStars/allStars), height: self.bounds.size.height)
            star = (CGFloat)((Int)(star)) == star ? star : star+1
        }else{
            view.frame = self.bounds
        }
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        for i in 0..<(Int)(allStars) {
            let imageView = UIImageView.init(image: UIImage.init(named: image))
            imageView.frame = CGRect(x: CGFloat(i * ((Int)(self.bounds.size.width)/(Int)(allStars))), y: 0, width: self.bounds.size.width/CGFloat(allStars), height: self.bounds.size.height)
            imageView.contentMode = .scaleAspectFit
            
            if i>(Int)(star) {
                
            }else{
                // print("\(i)")
                view.addSubview(imageView)
            }
        }
        return view
    }
    func changeToComleteStar(precent:CGFloat,allStar:CGFloat)->(CGFloat) {
        var preceent :CGFloat = 0.0
        for i in 1...(Int)(allStar) {
            if precent > (CGFloat)(i-1)/allStar&&precent <= (CGFloat)(i)/allStar {
                preceent = (CGFloat)(i)/allStar
            }
        }
        return preceent
    }
    
    
}






