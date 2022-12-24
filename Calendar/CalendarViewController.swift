//
//  ViewController.swift
//  Calendar
//
//  Created by Will on 2022/12/24.
//

import UIKit

class CalendarViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var monthCount: Int = 0
    var data:[String] = []
    var monthList: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
         collectionView.register(UINib(nibName: "DayListCell", bundle: nil), forCellWithReuseIdentifier: "DayListCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        let calendar = NSCalendar.current
        monthList = calendar.shortMonthSymbols
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())
    
        
        var list: [String] = []
        for year in 2022...2030 {
            for month in 1...12 {
                monthCount += 1
                if month < 10 {
                    list.append(String(year) + "-0" + String(month) + "-01")
                }else {
                    list.append(String(year) + "-" + String(month) + "-01")
                }
            }
        }
//        print(list)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
//        for item in list {
//            let tmpDate = format.date(from: item)!
//            let rang = calendar.range(of: .day, in: .month, for: tmpDate)
//            print("这个月" + item + " 一共" + String(rang!.count) + "天")
//            let components = calendar.dateComponents([.year, .month, .day, .weekday], from: tmpDate)
//            print("这个月1号是星期" + String(components.weekday!))
//        }
        data = list
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let month = data[section]
        var format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = TimeZone(secondsFromGMT: -3600*8)
        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: -3600*8)!
        let tmpDate = format.date(from: month)!
        let rang = calendar.range(of: .day, in: .month, for: tmpDate)
       
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: tmpDate)
        print(tmpDate)
        print("这个月1号是星期" + String(components.weekday!))
        print(rang!.count + (components.weekday! == 1 ? 0 : components.weekday! - 1))
        return rang!.count + (components.weekday! == 1 ? 0 : components.weekday! - 1) + 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let month = data[indexPath.section]
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = TimeZone(secondsFromGMT: -3600*8)
        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: -3600*8)!
        let tmpDate = format.date(from: month)!
       
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: tmpDate)

        
        let begin = components.weekday! == 1 ? 0 : components.weekday! - 1
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayListCell", for: indexPath) as! DayListCell
        cell.lineView.isHidden = false
        if indexPath.row < (components.weekday! - 1) {
            cell.lineView.isHidden = true
        }
        if indexPath.row < (begin + 7){
            if indexPath.row == (components.weekday! - 1) {
                cell.dayLabel.text = monthList[components.month! - 1]
            }else {
                cell.dayLabel.text = ""
            }
        }else {
            cell.dayLabel.text = String(indexPath.row - begin + 1 - 7)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 20) / 7, height: 60)
    }
    
   

}

