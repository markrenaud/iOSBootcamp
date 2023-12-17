import Foundation
/*: ## Part 2 - Programming assignment.
 */
/*:
 a) Create an array of `Int` called **nums** with values 0 through 20. Iterate over the `Array` and print the even numbers.
 */
let nums = Array(0...20)
for num in nums where num % 2 == 0 {
    print(num)
}
/*:
 b) In your Playground, define the following String:
 
 `let sentence = "The qUIck bRown fOx jumpEd over the lAzy doG"`
 
 Iterate over sentence counting the vowels (a, e, i, o, u), ignoring the case.
 */
let sentence = "The qUIck bRown fOx jumpEd over the lAzy doG"
let vowels: [Character] = ["a", "e", "i", "o", "u"]
var count = 0
for character in sentence.lowercased() {
    if vowels.contains(character) { count += 1 }
}
print("the sentence contains \(count) vowels")
/*:
 c) Create two arrays of `Int` with the values of 0 through 4. Use a nested for loop to print a mini multiplication table. The output, which should be multiple lines, should be in the following format:
 
 `0 * 0 = 0`
 
 The format follows the number from the first array, space, followed by the character *, space, followed by the number from the second array, space,  followed by =, space, followed by the result of the number from the first array multiplied by the number from the second array (just like the example above). There are a couple of ways to achieve this, but String Interpolation is the easiest.
 
 */
let aTerms = Array(0...4)
let bTerms = Array(0...4)
for aTerm in aTerms {
    for bTerm in bTerms {
        let result = aTerm * bTerm
        print("\(aTerm) * \(bTerm) = \(result)")
    }
}
/*:
 d) Write a function called average that takes an optional array of Int. If the array is not nil, calculate the average of the array's values and print:
 
 `"The average of the values in the array is <average>."`
 
 Where <average> is the calculated average. If the array is nil, print:
 
 `"The array is nil. Calculating the average is impossible."`
 
 Note: the average is calculated by summing the values in the array and dividing by the number of elements.
 
 Call this function two times. First, pass in the nums array from part A and second by passing an optional array of Int.
 */
func average(_ values: [Int]?) {
    guard let values = values else {
        print("The array is nil. Calculating the average is impossible.")
        return
    }
    // avoid divide by zero error if an empty
    // array is passed in - this will require a different
    // message to be printed to the debug console, and will
    // thus be put in a separate guard statement.
    guard !values.isEmpty else {
        print("The array is empty. Calculating the average is impossible.")
        return
    }
    let average = values.reduce(0, +) / values.count
    print("The average of the values in the array is \(average).")
}

average(nums)
average(nil)
average([])
/*:
 Create a `struct` called `Person` with the properties `firstName`, `lastName`, and `age`. Choose appropriate data types for the properties. Include a method on `Person` called `details` that prints the values stored in the properties in the following format:
 
 `Name: <firstName> <lastName>, Age: <age>`
 
 Create an instance of `Person` called person. Pass your first name, last name, and age for the properties. Finally, call the method `details`.
 */
struct Person {
    let firstName: String
    let lastName: String
    var age: Int
    
    func details() {
        print("Name: \(firstName) \(lastName), Age: \(age)")
    }
}

let person = Person(
    firstName: "Mark",
    lastName: "Renaud",
    age: 30
)

person.details()
/*:
 f) Create a `class` called `Student` with two properties: `person` of type `Person` and `grades`, an array of `Int`.
 
 The class must have a method called `calculateAverageGrade` that takes no parameters and returns a `Double`.
 
 Include a method called `details` that prints the values of the properties stored in `Student` along with the average grade in the following format:
 
 `Name: <firstName> <lastName>, Age: <age>, GPA: <average grade>.`
 
 Create an instance of `Student` called `student` passing in your first name, last name, age, and an array of five numbers: 94, 99, 81, 100, 79. Next call the details method to output the details of the student.
 */
class Student {
    var person: Person
    var grades: [Int]
    
    init(person: Person, grades: [Int]) {
        self.person = person
        self.grades = grades
    }
    
    init(firstName: String, lastName: String, age: Int, grades: [Int]) {
        self.person = Person(
            firstName: firstName,
            lastName: lastName,
            age: age
        )
        self.grades = grades
    }
    
    func calculateAverageGrade() -> Double {
        Double(grades.reduce(0, +)) / Double(grades.count)
    }
    
    func details() {
        // calculate average grade as a String to 2-decimal places
        // to improve aesthetics when printing to console in cases
        // where the fractional part is long.
        let gpa = String(format: "%.2f", calculateAverageGrade())
        print("Name: \(person.firstName) \(person.lastName), Age: \(person.age), GPA: \(gpa).")
    }
}

let student = Student(
    firstName: "Mark",
    lastName: "Renaud",
    age: 30,
    grades: [94, 99, 81, 100, 79]
)
student.details()
/*: ## Part 3 - Above and Beyond.
 */
/*:
 Copy the following code to your Playground and run it.
 ```
 struct Square {
     var side: Int
     func area() -> Int {
         return side * side
     }
 }

 class Rectangle {
     var length: Int
     var width: Int
     init(length: Int, width: Int) {
         self.length = length
         self.width = width
     }
     func area() -> Int {
         return length * width
     }
 }

 var square1 = Square(side: 4)
 var square2 = square1
 square2.side = 5
 print("Area: square1 - \(square1.area()) square2 - \(square2.area())")

 var rectangle1 = Rectangle(length: 4, width: 4)
 var rectangle2 = rectangle1
 rectangle2.length = 5
 print("Area: rectangle1 - \(rectangle1.area()) rectangle2 - \(rectangle2.area())")
 ```
 
 In your README file, include the two lines of print out from this code and explain why the output is what it is.
 */
struct Square {
    var side: Int
    func area() -> Int {
        return side * side
    }
}

class Rectangle {
    var length: Int
    var width: Int
    init(length: Int, width: Int) {
        self.length = length
        self.width = width
    }
    func area() -> Int {
        return length * width
    }
}

var square1 = Square(side: 4)
var square2 = square1
square2.side = 5
print("Area: square1 - \(square1.area()) square2 - \(square2.area())")

var rectangle1 = Rectangle(length: 4, width: 4)
var rectangle2 = rectangle1
rectangle2.length = 5
print("Area: rectangle1 - \(rectangle1.area()) rectangle2 - \(rectangle2.area())")
