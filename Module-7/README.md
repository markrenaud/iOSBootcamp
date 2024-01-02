> # This README contains the answers to Module 7's homework questions.

## Part 1 - Short-Answer Questions

#### _a) The ??????? ??????? class allows you to interact with the file system and its contents._

`FileManager`

#### _b) Apps on iOS are ??????? from each other._

sandboxed

#### _c) True or False: `FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]` will give the document directories for all Apps the user has on their device._

False. It will give the document directory for the **current** sandboxed app.

#### _d)The ??????? folder is a good place to put re-usable code when using Playgrounds._

The **Sources** folder is a good place to put re-usable code when using Playgrounds.

#### _e) What `URL` property allows you to view the `URL`’s path?  ??????? allows you to add a file name to a directory._

The `path` property allows you to view the URL’s path without the scheme (e.g., without file://, http://).

The `absoluteString` property allows you to view path including the scheme (though it should be noted that it also percent encodes the path).

The `appending(path:)` method allows you to add a filename to a directory (iOS 16+).

#### _f) Name at least three Swift Data Types you have used up to this point in the bootcamp._

- `String`
- `Double`
- `Int`

#### _g) How can you find the number of bytes a Data Type uses?_

You can use `MemoryLayout<T>.size` to find the number of bytes a Data Type (`T`) uses:

- eg. `MemoryLayout<UInt16>.size` would return `2`

#### _h) Using Playgrounds, how can you tell that the `Data.write` operation succeeded?_

The `write(to:options:)` method of `Data` is throwing - and will throw and error if the operation fails.

In Swift Playgrounds, continued execution past the `write(to:options:)` call, the operation succeeded.

#### _i) You can mostly treat `Data` objects like ??????? of bytes._

You can mostly treat `Data` objects like an **array** of bytes.

#### _j) The write and read methods of `Data` require a ???????._

The write and read methods of `Data` require a **`URL`**.

#### _k) What JavaScript calls an object is the same concept as a heterogeneous ??????? in Swift with ??????? for keys._

What JavaScript calls an object is the same concept as a heterogeneous `Dictionary` in Swift with `String` for keys.

#### _l) How do you resolve the error: Use of unresolved identifier ‘Bundle’?_

To resolve the error `Use of unresolved identifier 'Bundle'` you need to make sure that the Foundation framework, which includes the definition for `Bundle`, is imported at the beginning of your Swift file.

```Swift
import Foundation
```

#### _m) Give an example of Snake Case._

`this_is_an_example_of_snake_case`

#### _n) A struct that will be used in the reading and writing of data must conform to the ??????? Protocol_

A struct that conforms to the built-in `Codable` protocol can automatically encode and decode its properties for reading and writing data.

**However**, it's important to note that `Codable` is **not the only means** for a struct to read and write data. 

#### _o) Show the line of code used to access the user’s document directory for the running app._

```Swift
FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
```

#### _p) Files added to the project that will be used by the app can be found in the ??????? ??????? when the app is running._

File added to the project that will be used by the app can be found in the **Main Bundle** when the app is running.

## Part 2 - Programming Assignment
See Xcode project.

## Part 3 - Above & Beyond
See Xcode project.
