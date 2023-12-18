import Foundation
/*: ## Part 2 - Programming assignment.
 */
/*:
 a) In the assignment for Module 3, part D asked you to write a function that would compute the average of an array of `Int`. Using that function and the array created in part A, create two overloaded functions of the function `average`.
*/
func average(_ values: [Int]?) {
    guard let values = values else {
        print("The array is nil. Calculating the average is impossible.")
        return
    }
    guard !values.isEmpty else {
        print("The array is empty. Calculating the average is impossible.")
        return
    }
    let average = values.reduce(0, +) / values.count
    print("The average of the values in the array is \(average).")
}

// Overloaded
// - by changing parameter types to make more generic
// - by adding argument label
// - by changing return type
//
// Two overloaded functions can be created to generically support `average`
// functions across both floating point and integer types.

func average<T: BinaryInteger>(of values: [T]?) -> T? {
    // Sanity checking:
    // 1) check nil was not passed in
    // 2) check the element count of values can actually fit into
    //    the type's maximum value (eg. if T was Int8, max count of elements,
    //    would be Int8.max = 127)
    // 3) check the count is not equal to 0 (as this would cause a divide by
    //    zero fatal error).
    guard
        let values = values,
        let count = T(exactly: values.count),
        count != .zero
    else {
        // unable to calculate the average - return nil
        return nil
    }

    return values.reduce(T.zero, +) / count
}

func average<T: FloatingPoint>(of values: [T]?) -> T? {
    guard
        let values = values,
        let count = T(exactly: values.count),
        count != .zero
    else {
        // unable to calculate the average - return nil
        return nil
    }

    return values.reduce(T.zero, +) / count
}

// example usage using array created in Module 3, part A.
let someInts = Array(0...20)
let avg = average(of: someInts) ?? 0
/*:
 Create an `enum` called `Animal` that has at least five animals. Next, make a function called `theSoundMadeBy` that has a parameter of type `Animal`. This function should output the sound that the animal makes. For example, if the Animal pass is a cow, the function should output, `"A cow goes moooo."`
 
 **Hint**: Do not use if statements to complete this section.
 
 Call the function twice, sending a different Animal each time.
 */
enum Animal: String {
    case dog
    case cat
    case cow
    case snake
    case owl
}

extension Animal {
    var sound: String {
        switch self {
        case .dog:
            "woof"
        case .cat:
            "meow"
        case .cow:
            "moooo"
        case .snake:
            "sssssss"
        case .owl:
            "hoot"
        }
    }
}

func theSoundMadeBy(_ animal: Animal) {
    print("A \(animal.rawValue) goes \(animal.sound).")
}

theSoundMadeBy(.dog)
theSoundMadeBy(.snake)
/*:
 c) This question will have you creating multiple functions that will require you to use closures and collections. First, you will do some setup.
 
 - Create an array of `Int` called nums with the values of 0 to 100.
 
 - Create an array of `Int?` called `numsWithNil` with the following values:
 `79, nil, 80, nil, 90, nil, 100, 72`
 
 - Create an array of `Int` called `numsBy2` with values starting at 2 through 100, by 2.
 
 - Create an array of `Int` called `numsBy4` with values starting at 2 through 100, by 4.
 
 You can set the values of the arrays above using whatever method you find the easiest. In previous modules, you were introduced to ranges and sequences in Swift. Leveraging those in the Array initializer will allow you to create the requested arrays in a single line. Don’t let the last two break your stride.
 
 - Create a function called `evenNumbersArray` that takes a parameter of `[Int]` (array of `Int`) and returns `[Int]`. The array of `Int` returned should contain all the even numbers in the array passed. Call the function passing the `nums` array and print the output.
 
 - Create a function called `sumOfArray` that takes a parameter of `[Int?]` and returns an `Int`. The function should return the sum of the array values passed that are not `nil`. Call the function passing the `numsWithNil` array, and print out the results.
 
 - Create a function called `commonElementsSet` that takes two parameters of `[Int]` and returns a `Set<Int>` (set of `Int`). The function will return a `Set<Int>` of the values in both arrays.
 
 - Call the function `commonElementsSet` passing the arrays `numsBy2`, `numsBy4`, and print out the results.
 */
let nums = Array(0...100)
let numsWithNil = [79, nil, 80, nil, 90, nil, 100, 72]
let numsBy2 = Array(stride(from: 2, through: 100, by: 2))
let numsBy4 = Array(stride(from: 2, through: 100, by: 4))

func evenNumbersArray(_ array: [Int]) -> [Int] {
    array.filter { $0 % 2 == 0 }
}

func sumOfArray(_ array: [Int?]) -> Int {
    array.reduce(0) { runningTotal, element in
        runningTotal + (element ?? 0)
    }
}

print(sumOfArray(numsWithNil))

func commonElementsSet(_ arrayA: [Int], _ arrayB: [Int]) -> Set<Int> {
    Set(arrayA).intersection(arrayB)
}

print(commonElementsSet(numsBy2, numsBy4))
/*:
 d) Create a struct called `Square` that has a stored property called `sideLength` and a computed property called `area`. Create an instance of `Square` and print out the area.
*/
struct Square {
    var sideLength: Double
    var area: Double { pow(sideLength, 2) }
}

let square = Square(sideLength: 5.0)
print("square area:", square.area)
/*: ## Part 3 - Above and Beyond.
 */
/*:
 Create a `protocol` called `Shape` with a `calculateArea() -> Double` method. Create two `struct`s called `Circle` and `Rectangle` that conform to the protocol `Shape`. Both `Circle` and `Rectangle` should have appropriate stored properties for calculating the area.
 
 Create instances of `Circle` and `Rectangle` and print out the area for each.
 
 Next, extend the protocol `Shape` to add a new method called `calculateVolume() -> Double`.
 
 Finally, create a `struct` called `Sphere` that conforms to `Shape`. `Sphere` should have appropriate stored properties for calculating area and volume.
 
 Create an instance of `Sphere` and print out the area and volume.
 */
protocol Shape {
    func calculateArea() -> Double
    func calculateVolume() -> Double
}

struct Circle: Shape {
    var radius: Double
    
    func calculateArea() -> Double {
        .pi * pow(radius, 2)
    }
}

struct Rectangle: Shape {
    var width: Double
    var length: Double
    
    func calculateArea() -> Double {
        width * length
    }
}

let circle = Circle(radius: 5)
print("circle area:", circle.calculateArea())

let rectangle = Rectangle(width: 2.0, length: 4.0)
print("rectangle area:", rectangle.calculateArea())

extension Shape {
    /// Provides default implementation for shapes that do not have a volume (where height is
    /// inferred to be 0).
    func calculateVolume() -> Double {
        return 0.0
    }
}

struct Sphere: Shape {
    var radius: Double
    
    /// calculates the **surface** area
    func calculateArea() -> Double {
        4.0 * .pi * pow(radius, 2)
    }
    
    func calculateVolume() -> Double {
        4.0 / 3.0 * .pi * pow(radius, 3)
    }
}

let sphere = Sphere(radius: 5.0)
print("sphere surface area:", sphere.calculateArea())
print("sphere volume:", sphere.calculateVolume())
