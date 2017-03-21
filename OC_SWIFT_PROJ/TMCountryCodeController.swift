//
//  TMCountryCodeController.swift
//  OC_SWIFT_PROJ
//
//  Created by 澳达国际 on 17/3/16.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

@objc class TMCountryCodeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias SelectionBlock = (_ countryArray:Array<String>) -> Void
    var selectBlock:SelectionBlock?
    
    let cellReuseID = "kTMCountryCodeController"
    var dataDict: Dictionary<String, NSMutableArray> = [:]
    var capitalArray: [String] = []
    
    func pinyin(_ chineseString: String) -> String {
        let str1: CFMutableString = CFStringCreateMutableCopy(nil, 0, chineseString as CFString!)
        CFStringTransform(str1, nil, kCFStringTransformToLatin, false)
        CFStringTransform(str1, nil, kCFStringTransformStripCombiningMarks, false)
//        let str2 = CFStringCreateWithSubstring(nil, str1, CFRangeMake(0, 1))
        return str1 as String
    }
    
    func sortData(_ array: NSArray) -> [String: NSMutableArray] {
        var countryDict = [String: NSMutableArray]()
        
        for string in array as! [String] {
            let separatedArray = string.components(separatedBy: "-") as Array
            let pinyinString = pinyin(separatedArray[1])
            let index = pinyinString.index(pinyinString.startIndex, offsetBy: 1)
            let firstCharacter = pinyinString.substring(to: index).uppercased()
            if let sortedArray = countryDict[firstCharacter] {
                sortedArray.add(separatedArray)
            } else {
                let sortedArray = NSMutableArray()
                sortedArray.add(separatedArray)
                countryDict[firstCharacter] = sortedArray
            }
        }
        print(countryDict)
        return countryDict
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let capital = self.capitalArray[section]
        return (self.dataDict[capital]?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.capitalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellReuseID)
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
        }
        let capitalKey = self.capitalArray[indexPath.section]
        let countries = self.dataDict[capitalKey]
        let countryArr = countries?.object(at: indexPath.row) as! Array<String>
        print(countryArr)
        cell?.textLabel?.text = countryArr[1]
        cell?.detailTextLabel?.text = countryArr[0]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.capitalArray[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let capitalKey = self.capitalArray[indexPath.section]
        let countries = self.dataDict[capitalKey]
        let countryArr = countries?.object(at: indexPath.row) as! Array<String>
        if (self.selectBlock != nil) {
            self.selectBlock!(countryArr)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if let file = Bundle.main.url(forResource: "countries", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [String] {
                    // json is an array
                    let dict = sortData(object as NSArray)
                    self.dataDict = dict
                    self.capitalArray = dict.keys.sorted()
                    self.tableView.reloadData()
                    print(self.capitalArray)
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        self.edgesForExtendedLayout = []
        tableView.sectionHeaderHeight = 35
        tableView.rowHeight = 45
    }
    
}
