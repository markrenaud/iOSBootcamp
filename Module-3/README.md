> # This README contains the answers to Module 3's homework questions.

## Part 1 - Short-Answer Questions


#### _a) 0...5 and 0..<5 are two types of ?????. How are they different?_

`0...5` is a `ClosedRange<Int>`. It contains values from the lower bound (0) up to and including the upper bound (5). Here, we could iterate over the sequence of contained values: `0, 1, 2, 3, 4, 5`.

`0..<5` is a `Range<Int>` (half-open range). It includes values from the lower bound up to, but not including, the upper bound. Here, we could iterate over the sequence of contained values: `0, 1, 2, 3, 4`.

#### _b) Describe type inference in Swift and give an example._

Type inference in Swift is the compiler's ability to deduce the type of a variable or constant without an explicit type annotation.

*Explicit Type Annotation*:
```swift
let name: String = "Mark"
```
*Type Inference* (here, Swift infers the type of name to be `String` based on the assigned value):
```swift
let name = "Mark"
```
Explicit type annotation may be required when Swift cannot unambiguously infer the type, or when you want to specify a type that is different from the one that would be inferred.

#### _c) List three advantages of Playgrounds._

1. Playgrounds can automatically execute code, with the results quickly available for review.
2. The results of each line of code can be visualized in the sidebar, making it easier to understand the effects of code changes in real-time.
3. Playgrounds provide a lightweight and convenient environment for experimentation and testing outside of a full project context.

#### _d) When does the execution of a while loop end?_

A while loop ends immediately at the point when the comparison statement evaluates to `false`.

Consider the following example:
```swift
var t = 0

while t < 10 {
    print(t)
    t += 1
}
```

Here, when `t` is incremented to `10`, and the loop comparison is next evaluated, the execution of the while loop will end. This means that while `10` will never be printed to the console (as the loop exits before printing `t` inside of the loop), the value of `t` at which the loop exits will be `10`.

#### _e) True or False: Tuples in Swift can contain values of different data types._

True - tuples can contain values of different data types.

However, once a specific tuple is defined, the types of data it contains remain fixed (immutabe) throughout its lifetime.

```swift
var locationTuple = (houseNumber: 123, street: "Sesame")

locationTuple.houseNumber = 345     // Works because it's the same type `Int`
locationTuple.houseNumber = "12/3A" // Would not work, as it's trying to assign a `String` to `houseNumber`, which is of type `Int`
```

#### _f) List three data types you have used in Swift._

- `String`
- `Bool`
- `Int`

#### _g) To execute alternative code when the condition of an if statement is not met, you can use what clause?_

`else` clause

#### _h) What is the third element of the array nums defined below?_
#### `let nums = [5, 0, 44, 20, 1]`

The third **element** of the array is `44`.

#### _i) An ????? is a unit of code that resolves to a single value._

expression

#### _j) Define two ways to unwrap optionals in Swift._

There are a number of ways to unwrap optionals, **including**:

1. Force unwrapping - `let name = myOptionalString!`
2. Nil coalescing - `let name = myOptionalString ?? "unknown"`

#### _k) True or False: The condition in an if statement must be true or false._

true

#### _l) Arrays in Swift are ????? indexed._

Arrays in Swift are **0-indexed**.  That is, the **first** element in an array can be accessed using the array index **0**.

m) An unordered collection of unique values of the same type is a ?????.

`Set`

## Part 3 - Above & Beyond

#### _Copy the following code to your Playground and run it._
 ```swift
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
 
### _In your README file, include the two lines of print out from this code and explain why the output is what it is._


The two lines of print out are:
```
Area: square1 - 16 square2 - 25
Area: rectangle1 - 20 rectangle2 - 20
```

The reason the areas of `square1` and `square2` are **not** equal is because `struct`s in Swift have value semantics. That is, when assigning `square2` the value of `square1`, we are creating a distinct **copy** of `square1`. Changing the side of `square2` does not affect `square1`'s properties.

Conversely, the areas of `rectangle1` and `rectangle2` **are** equal because `class`es in Swift have reference semantics. That is, when setting `rectangle2` equal to `rectangle1`, we are not creating a new instance but rather making `rectangle2` point to the same underlying object in memory as `rectangle1`. Therefore, changing the `length` property of `rectangle1` also affects `rectangle2` since both variables reference the same instance.