//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Ollie on 2016/10/3.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    // MARK: - Variables
    var rating: String?
    
    // MARK: - @IBOutlet & @IBAction
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    @IBAction func ratingSelected (sender: UIButton) {
        switch sender.tag {
            case 1: rating = "dislike"
            case 3: rating = "good"
            case 5: rating = "great"
            default: break
        }
        
        self.performSegue(withIdentifier: "unwindToDetailView", sender: nil)
    }
    
    // MARK: View Property & Func 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        backgroundImageView.image = UIImage(named: "barrafina")
        
        //加上模糊效果
        /*
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundImageView.bounds
        // for supporting device rotation
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        */
 
        //Scale animation:縮放變換（起始狀態）
        //ratingStackView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        
        //Slide-up animation:滑動變換
        //ratingStackView.transform = CGAffineTransform.init(translationX: 0.0, y: 500.0)
        
        //結合Scale & Slide-up
        //swift2.3語法：CGAffineTransformConcate(t1,t2)
        let scale: CGAffineTransform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        let translation: CGAffineTransform = CGAffineTransform.init(translationX: 0.0, y: 500.0)

        //ratingStackView.transform = scale.concatenating(translation)
        
        let dislikeButton = ratingStackView.arrangedSubviews[0]
        dislikeButton.transform = scale.concatenating(translation)
        
        let goodButton = ratingStackView.arrangedSubviews[1] as! UIButton
        goodButton.transform = scale.concatenating(translation)
        
        ratingStackView.arrangedSubviews[2].transform = scale.concatenating(translation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //在viewDidAppear載入動畫（終止狀態）
        //CGAffineTransform.identity：表示重新設定視圖至原來大小及位置的常數
        
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
//            self.ratingStackView.transform = CGAffineTransform.identity
//            }, completion: nil)
        
        //彈跳動畫
//        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
//                self.ratingStackView.transform = CGAffineTransform.identity
//            }, completion: nil)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { 
                self.ratingStackView.arrangedSubviews[0].transform = .identity
            }, completion: nil)
        UIView.animate(withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.ratingStackView.arrangedSubviews[1].transform = .identity
            }, completion: nil)
        UIView.animate(withDuration: 0.7, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.ratingStackView.arrangedSubviews[2].transform = .identity
            }, completion: nil)
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

    // MARK: - User Defined Method
}
