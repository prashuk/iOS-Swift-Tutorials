import Foundation

// Properties associate values with a particular class, structure, or enumeration.
// Stored properties store constant and variable values as part of an instance, whereas computed properties calculate (rather than store) a value.

// Computed properties are provided by classes, structures, and enumerations.
// Stored properties are provided only by classes and structures.

// Stored and computed properties are usually associated with instances of a particular type. However, properties can also be associated with the type itself. Such properties are known as type properties.



// Stored Properties
// Stored properties can be either variable stored properties (introduced by the var keyword) or constant stored properties (introduced by the let keyword).
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3) // the range represents integer values 0, 1, and 2
rangeOfThreeItems.firstValue = 6 // 6

let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4) // this range represents integer values 0, 1, 2, and 3
//rangeOfFourItems.firstValue = 6 // this will report an error, even though firstValue is a variable property
// Because rangeOfFourItems is declared as a constant (with the let keyword), it is not possible to change its firstValue property, even though firstValue is a variable property.
// This behavior is due to structures being value types. When an instance of a value type is marked as a constant, so are all of its properties.
// The same is not true for classes, which are reference types. If you assign an instance of a reference type to a constant, you can still change that instance’s variable properties.

class FixedLength {
    var firstValue: Int
    var length: Int
    init(firstValue: Int, length: Int) {
        self.firstValue = firstValue
        self.length = length
    }
}
var rangeOne = FixedLength(firstValue: 0, length: 3)
rangeOne.firstValue = 6

let rangeTwo = FixedLength(firstValue: 1, length: 4)
rangeTwo.firstValue = 5 // it will not throw any errors



// Lazy Stored Properties
// A lazy stored property is a property whose initial value is not calculated until the first time it is used. You indicate a lazy stored property by writing the lazy modifier before its declaration.
// You must always declare a lazy property as a variable (with the var keyword)
// That lazy variable is nil before it is used
class DataImporter {
    var filename = "data.txt"
}
class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // the DataManager class would provide data management functionality here
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// the DataImporter instance for the importer property has not yet been created
print(manager.importer.filename) // Prints "data.txt"
// If a property marked with the lazy modifier is accessed by multiple threads simultaneously and the property has not yet been initialized, there’s no guarantee that the property will be initialized only once.



// Computed Properties
// In addition to stored properties, classes, structures, and enumerations can define computed properties, which do not actually store a value.
// Instead, they provide a getter and an 'optional' setter to retrieve and set other properties and values indirectly.
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))") // Prints "square.origin is now at (10.0, 10.0)"



// Shorthand Setter Declaration
// If a computed property’s setter doesn’t define a name for the new value to be set, a default name of "newValue" is used.
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}



// Shorthand Getter Declaration
// If the entire body of a getter is a single expression, the getter implicitly returns that expression
struct CompactRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            Point(x: origin.x + (size.width / 2),
                  y: origin.y + (size.height / 2))
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}



// Read-Only Computed Properties
// A computed property with a getter but no setter is known as a read-only computed property.
// A read-only computed property always returns a value, and can be accessed through dot syntax, but cannot be set to a different value.
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)") // Prints "the volume of fourByFiveByTwo is 40.0"



// Property Observers
// Property observers observe and respond to changes in a property’s value. Property observers are called every time a property’s value is set, even if the new value is the same as the property’s current value.
// You can add property observers in the following places:
    // Stored properties that you define
    // Stored properties that you inherit
    // Computed properties that you inherit

// For an inherited property, you add a property observer by overriding that property in a subclass. For a computed property that you define, use the property’s setter to observe and respond to value changes, instead of trying to create an observer.

// You have the option to define either or both of these observers on a property:
    // willSet is called just before the value is stored.
    // didSet is called immediately after the new value is stored.
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(x) {
            print("About to set totalSteps to \(x)") // or without x you can use newValue as default param
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps") // similarly here oldValue is the default param
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps



// If you implement a willSet observer, it’s passed the new property value as a constant parameter. You can specify a name for this parameter as part of your willSet implementation. If you don’t write the parameter name and parentheses within your implementation, the parameter is made available with a default parameter name of 'newValue'.
// Similarly, if you implement a didSet observer, it’s passed a constant parameter containing the old property value. You can name the parameter or use the default parameter name of 'oldValue'. If you assign a value to a property within its own didSet observer, the new value that you assign replaces the one that was just set.



// Property Wrappers
//



// Global and Local Variables
// Global variables are variables that are defined outside of any function, method, closure, or type context.
// Local variables are variables that are defined within a function, method, or closure context.
// The global and local variables you have encountered in previous chapters have all been stored variables. Stored variables, like stored properties, provide storage for a value of a certain type and allow that value to be set and retrieved.
// However, you can also define computed variables and define observers for stored variables, in either a global or local scope. Computed variables calculate their value, rather than storing it, and they are written in the same way as computed properties.
// Global constants and variables are always computed lazily, in a similar manner to Lazy Stored Properties. Unlike lazy stored properties, global constants and variables do not need to be marked with the lazy modifier.
// Local constants and variables are never computed lazily.



// Type Properties
// Instance properties are properties that belong to an instance of a particular type. Every time you create a new instance of that type, it has its own set of property values, separate from any other instance.
// You can also define properties that belong to the type itself, not to any one instance of that type.
// There will only ever be one copy of these properties, no matter how many instances of that type you create. These kinds of properties are called type properties.

// Stored type properties can be variables or constants.
// Computed type properties are always declared as variable properties, in the same way as computed instance properties.


// Type Property Syntax
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

// You define type properties with the 'static' keyword.
// For computed type properties for class types, you can use the class keyword instead to allow subclasses to override the superclass’s implementation
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
extension SomeClass {
    var overrideableComputedTypeProperty: Int {
        return 100
    }
}
var newInstense = SomeClass()
print(newInstense.overrideableComputedTypeProperty) // Prints "100"
// You can also define read-write computed type properties with the same syntax as for computed instance properties.



// Querying and Setting Type Properties
// Type properties are queried and set with dot syntax, just like instance properties. However, type properties are queried and set on the type, not on an instance of that type.
print(SomeStructure.storedTypeProperty) // Prints "Some value."
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty) // Prints "Another value."
print(SomeEnumeration.computedTypeProperty) // Prints "6"
print(SomeClass.computedTypeProperty) // Prints "27"
print(SomeClass.overrideableComputedTypeProperty) // Prints "107" -- see difference ** IMP **
