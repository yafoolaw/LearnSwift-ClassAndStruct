//
//  ViewController.swift
//  SwiftClassAndStruct
//
//  Created by 刘延峰 on 15/10/12.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

// MARK: 结构体是值类型,类是关系类型
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

// MARK: 验证lazy关键字

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

// MARK:属性

struct Point {
    
    var x = 0.0, y = 0.0
}

struct Size {
    
    var width = 0.0 , height = 0.0
}

struct Rect {
    
    var origin = Point()
    
    var size   = Size()
    
    var center : Point {
    
        get {
        
            let centerX = origin.x + (size.width/2)
            
            let centerY = origin.y + (size.height/2)
            
            return Point(x: centerX, y: centerY)
        }
        
        set(newCenter) {
        
            origin.x = newCenter.x - (size.width/2)
            
            origin.y = newCenter.y - (size.height/2)
        }
        
//        // 快捷写法
//        set {
//            
//            origin.x = newValue.x - (size.width/2)
//            
//            origin.y = newValue.y - (size.height/2)
//        }
    }
}

struct Cubiod {
    
    var width = 0.0, height = 0.0, depth = 0.0
    
    // 计算属性的只读方式: 实现get,不实现set
    var volume : Double {
    
        return width * height * depth
    }
}

class StepCounter {
    
    // 属性观察者
    // 你可以为除了lazy标记的以外的存储属性(计算属性直接在它的setter中观察就可以),
    // 或者为从父类继承的属性(存储和计算),通过override的方式,添加属性观察者
    var totalSteps : Int = 0 {
    
        // 观察新值
        willSet {
        
            print("About to set totalSteps to \(newValue)")
        }
        
        // 观察旧值
        didSet {
        
            if totalSteps > oldValue {
            
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

// MARK: 类型属性
// 实例的属性属于一个特定类型实例，每次类型实例化后都拥有自己的一套属性值，实例之间的属性相互独立。
// 也可以为类型本身定义属性，不管类型有多少个实例，这些属性都只有唯一一份。这种属性就是类型属性。类似C中的静态常量或变量.
struct SomeStructure {

    static var storedTypeProperty   = "SomeValue"
    
    // 可读可写
    static var computedTypeProperty : Int {
    
        get {
        
            return 1
        }
        
        set {
        
            print(" computedTypeProperty setter")
        }
    }
}

enum SomeEnumeration {

    static var storedTypeProperty   = "SomeValue"
    
    // 只读
    static var computedTypeProperty : Int {
    
        return 6
    }
}

class SomeClass {

    static var storedTypeProperty   = "SomeValue"
    
    static var computedTypeProperty : Int {
    
        return 27
    }
    
    // 对于计算类型属性,用class代替static,则该计算类型属性可以在子类中重写
    class var overridableComputedProperty : Int {
    
        return 107
    }
    
    var storedProperty : String?
    
    var computedProperty : Int?
}

class SubClassFromSomeClass: SomeClass {
    
    // 用class修饰的计算类型属性,子类可以重写
    override static var overridableComputedProperty : Int {
    
        return 1000
    }
    
//    override static var computedTypeProperty : Int {
//    
//        return 127
//    }
}

// MARK: 方法
// 值类型的数据,其属性在其实例方法中是不可变的,除非加上mutating关键字
struct MutatingPoint {
    
    var x = 0.0, y = 0.0
    
    mutating func move(deltaX: Double, deltaY: Double) {
    
        x += deltaX
        
        y += deltaY
    }
}

enum TriStateSwitch {

    case Off, Low, High
    
    mutating func next() {
    
        switch self {
        
        case .Off:
            
            self = .Low
            
        case .Low:
            
            self = .High
            
        case .High:
            
            self = .Off
        }
    }
}

// MARK: 类型方法
// 与类型属性相似,static和class的用法相同
struct LevelTracker {

    static var hightestUnlockedLevel = 1
    
    static func unlockedLevel(level: Int) {
    
        if level > hightestUnlockedLevel {
        
            hightestUnlockedLevel = level
        }
    }
    
    static func levelIsUnlocked(level: Int) -> Bool {
    
        return level <= hightestUnlockedLevel
    }
    
    var currentLevel = 1
    
    mutating func advanceToLevel(level: Int) -> Bool {
    
        if LevelTracker.levelIsUnlocked(level) {
        
            currentLevel = level
            
            return true
            
        } else {
        
            return false
        }
    }
}

class Player {
    
    var tracker = LevelTracker()
    
    let playerNmae : String
    
    func completedLevel(level: Int) {
    
        LevelTracker.unlockedLevel(level + 1)
        
        tracker.advanceToLevel(level + 1)
        
    }
    
    init(name: String) {
    
        playerNmae = name
    }
}

// MARK: 下标
// 快捷方式使用成员变量
struct TimesTable {

    let mutiplier : Int
    
    // 只实现了getter,所以为只读
    subscript(index: Int) -> Int {
    
        return mutiplier * index
    }
}

struct Matrix {
    
    let rows : Int, columns : Int
    
    var grid : [Double]
    
    init(rows: Int, columns: Int) {
    
        // 用self来区分属性和同名参数
        self.rows    = rows
        
        self.columns = columns
        
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
    
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
    
        get {
        
            assert(indexIsValid(row, column: column), "越界")
            
            return grid[row * columns + column]
        }
        
        set {
        
            assert(indexIsValid(row, column: column), "越界")
            
            grid[row * columns + column] = newValue
        }
    }
}

// MARK: ViewController
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        /* ----------------------------------------
        
        * 结构体是值类型,类是关系类型
        
        ------------------------------------------- */
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
        
        
         /*--------------------------------------------
        
         * 测试lazy关键字(被lazy修饰的属性,只要使用时,才初始化)
        
           -------------------------------------------- */
        let manager = DataManager()
        
        manager.data.append("some data")
        
        sleepTime(5)
        
        manager.data.append(manager.importer.importFile("平凡的世界") as! String)
        
//        print(manager.data)
        
        /* -----------------------------------------
        
        * 测试属性观察者
        
        -------------------------------------------- */
        let stepCounter = StepCounter()
        
        stepCounter.totalSteps = 200
        
        stepCounter.totalSteps = 360
        
        stepCounter.totalSteps = 880
        
        /* -----------------------------------------
        
        * 测试类型属性
        
        -------------------------------------------- */
        print(SomeStructure.storedTypeProperty)
        // 打印 "SomeValue"
        
        SomeStructure.storedTypeProperty = "AnotherValue"
        
        print(SomeStructure.storedTypeProperty)
        // 打印 "AnotherValue"
        
        print(SomeEnumeration.computedTypeProperty)
        // 打印 "6"
        
        print(SomeClass.computedTypeProperty)
        // 打印 "27"
        
        /* -----------------------------------------
        
        * 测试类型方法
        
        -------------------------------------------- */
        var player = Player(name: "刘大帅")
        
        player.completedLevel(1)
        
        print("打开的最高关卡是\(LevelTracker.hightestUnlockedLevel)")
        // 打印 "打开的最高关卡是2"
        
        player = Player(name: "游贤明")
        
        if player.tracker.advanceToLevel(6) {
        
            print("打开关卡6")
            
        } else {
        
            print("还没有打开关卡6")
            
        }
        // 打印 "还没有打开关卡6"
        
        // 下标
        var matrix = Matrix(rows: 2, columns: 2)
        
        print(matrix)
        // 打印 "Matrix(rows: 2, columns: 2, grid: [0.0, 0.0, 0.0, 0.0])"
        
        matrix[0, 1] = 1.5
        matrix[1, 0] = 3.2
        
        print(matrix)
        // 打印 "Matrix(rows: 2, columns: 2, grid: [0.0, 1.5, 3.2, 0.0])"
        
    }
    
    func sleepTime(timeInterval:UInt32) {
        
        sleep(timeInterval)
        
        print("模拟读取大量数据耗费时间")
    }

}

