//
//  ViewController.swift
//  SwiftClassAndStruct
//
//  Created by 刘延峰 on 15/10/12.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

struct Resolution {
    
    var width  = 0
    
    var height = 0
}

class VideoMode {
    
    var resolution = Resolution()
    
    var interlaced = false
    
    var frameRate  = 0.0
    
    var name : String?
}

class DataImportor {
    
    var fileNmae = "data.txt"
    
    init() {
    
        NSLog("DataImportor----注意初始化时间,来验证lazy关键字")
    }
    
    func importFile(aFileName: String) -> AnyObject {
    
        let filePath = NSBundle.mainBundle().pathForResource(aFileName, ofType: "txt")
        
        fileNmae = aFileName
        
        var fileStr : String!
        
        do {
        
            fileStr = try NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding) as String
            
        } catch {
        
            print("读取文件失败!")
            
        }
        
        return fileStr!
    }
}

class DataManager {
    
    lazy var importer = DataImportor()
    
         var data     = [String]()
    
    init() {
    
        NSLog("DataManager----注意初始化时间,来验证lazy关键字")
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 最简单的初始化
        let someResolotion = Resolution()
        
        let someVideoMode  = VideoMode()
        
        // 可以直接对结构体属性的变量赋值(OC不允许)
        someVideoMode.resolution.width = 1280
        
        // 结构体自动生成一种成员变量式的初始化
        let vga = Resolution(width: 640, height: 480)
        
        // error 一个常量结构体的存储属性变量是不可变的,改变它会报错
        // 一个常量类可以改变它的属性变量,因为类是关系引用
//        vga.height = 960
        
        let manager = DataManager()
        
        manager.data.append("some data")
        
        sleepTime(5)
        
        manager.data.append(manager.importer.importFile("平凡的世界") as! String)
        
        print(manager.data)
        
    }
    
    func sleepTime(timeInterval:UInt32) {
        
        sleep(timeInterval)
        
        print("模拟读取大量数据耗费时间")
    }

}

