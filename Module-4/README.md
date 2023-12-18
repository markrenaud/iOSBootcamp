> # This README contains the answers to Module 4's homework questions.

## Part 1 - Short-Answer Questions

#### _a) List two Collection Types in Swift._

- `Array`
- `Dictionary`

#### _b) Name a function that uses variadic parameters._
- `print()`

#### _c) True or False: Only a class can adopt a protocol in Swift._

- false

#### _d) Name the four Named Types you have been introduced to so far._

- `enum` (enumerations)
- `struct` (structures)
- `class` (classes)
- `protocol` (protocols)


#### _e) The variadic parameter is treated as an ????? in the function._

- array

#### _f) In Swift, structs are ????? types, and classes are ????? types._

- `structs` are **value** types
- `class`es are **reference** types

#### _g) True or False: Functions in Swift, by default, can alter parameters passed to the function._

- `false` - By **default** functions cannot alter the value of parameters passed to them.  By default, paramaters are passed as constants.
- However, by using the `inout` keyword before a parameter's type, a function can modify the value of that parameter - eg:

```swift
var balance: Double = 100.0

func applyInterest(_ accountBalance: inout Double, rate: Double = 0.1) {
    accountBalance *= (1.0 + rate)
}

applyInterest(&balance)
```

#### _h) ????? are what a type has, and ????? are what a type can do._

- **properties** are what a type has
- **methods** are what a type can do


#### _i) A class, struct, or enum that adopts a protocol is said to ????? to the protocol_

- conform

#### _j) A lazy property is calculated only when ?????._

- it is first read/accessed

#### _k) True or False: Extensions in Swift allow you to add new functionality to an existing type._

- true

#### _l) True or False: A convenience initializer in Swift is responsible for initializing properties of a class._

- **false**
- A convenience initializer in Swift is not directly responsible for initializing properties of a class. Instead, it must call another initializer from the same class which is responsible for initializing properties.
- The convenience initializer can then provide additional customization.
