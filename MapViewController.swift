//
//  MapViewController.swift
//  FoodPin
//
//  Created by Ollie on 2016/10/9.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    // MARK: - Variables
    var restaurant: Restaurant!

    // MARK: - @IBOutlet & @IBAction
    @IBOutlet weak var myMapView: MKMapView!
    
    // MARK: View Property & Func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1. 建立CLGeocoder物件
        let geoCoder = CLGeocoder()
        
        // 2. 將地址轉換成經緯度地理座標,並標註顯示在地圖上
        geoCoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            if let finalMarks: [CLPlacemark] = placemarks {
                // 取得第一個座標
                let targetMark = finalMarks[0]
                // 建立顯示的標註資訊
                let annotation = MKPointAnnotation()
                
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = targetMark.location {
                    annotation.coordinate = location.coordinate
                }
                
                // 將標註顯示出來
                self.myMapView.showAnnotations([annotation], animated: true)
                // 不需按下大頭針即顯示標注泡泡框(callout bubble)
                self.myMapView.selectAnnotation(annotation, animated: true)
            }
        }
        
        // 定義mapView的delegate
        self.myMapView.delegate = self
        
        // 顯示交通流量
        self.myMapView.showsTraffic = true
        // 顯示比例尺
        self.myMapView.showsScale = true
        // 顯示指南針
        self.myMapView.showsCompass = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 當mapView需要一個annoatation View時候,會呼叫此方法
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        // 如果標註物件＝使用者目前位置,回傳nil
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // 確認是否有標註視圖可以回收使用,沒有則建立一新的標註視圖
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // 顯示標註泡泡框裡的資訊
            annotationView?.canShowCallout = true
        }
        
        // 建立縮圖
        let leftIconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconImage.image = UIImage(data: restaurant.image! as Data)
        
        annotationView?.leftCalloutAccessoryView = leftIconImage
        // 自訂大頭針顏色
        annotationView?.pinTintColor = UIColor.red
        
        return annotationView
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
