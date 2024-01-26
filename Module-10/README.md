> # This README contains the answers to Module 10's homework questions.

## Part 1 - Short-Answer Questions


#### _a) True or False: The function URLSession.dataTask(with:completionHandler:) is synchronous._

False.  URLSession.dataTask(with:completionHandler:) operates asynchronously returning results via a completion handler closure.  

#### _b) The sleep function is synchronous and it blocks its ?????????._

Assuming we are talking about the `Task.sleep(for:tolerance:clock:)` and `Task.sleep(until:tolerance:clock:)` methods in the Swift Concurrency model, then the sleep function blocks the execution of the **current task** for the specified period.

There are also the older `sleep(until:)` and `sleep(forTimeInterval:)` methids,  which operate outside of the Swift Concurrency model. These functions and methods block the **calling thread**, not just a task.

#### _c) True or False: The new data(from:) async method from URLSession returns both data and a URL response object._

True.

The full signature is:
```Swift
func data(from url: URL) async throws -> (Data, URLResponse)
```

#### _d) The code within a task closure runs sequentially, but the task itself runs on a ????????? thread._

The task itself runs on **different** thread ('different' is preferred over 'background' as Swift doesn't make any guarantees about which thread that function will run on).

#### _e) True or False: In the new concurrency model, you usually don't need to capture self or other variables in async functions._

False - any use of self or other variables in async function implicitly 'captures' them strongly (even if not in a explicit capture list).  For this reason, it is important to be aware of the potential to create retain cycles in reference-type objects (Class / Actor) and explicitly capture weakly to break the retain cycle if needed.

#### _f) When defining an asynchronous function that can throw errors, the ????????? keyword always comes before the throws keyword._

`async`

#### _g) True or False: If you wrap code within a Task, it will always run on the main thread._

False.

#### _h) In SwiftUI, to resolve the issue of calling an asynchronous method in a nonconcurrent context, one can replace onAppear with ?????????._

You can replace `onAppear` with the `task` view modifier.

#### _i) True or False: In SwiftUI, view modifiers like onAppear inherently run code asynchronously._

False.

#### _j) The ????????? keyword indicates a function contains a suspension point._

The `await` keyword indicates a function being called contains a suspension point.

The `async` keyword in a function definition indicates the function is aynchronous and *may* contain a suspension point.

#### _k) True or False: You can design your own custom asynchronous sequences in Swift._

True.  A custom asynchronous sequence can be implemented using the `AsyncSequence` protocol.

#### _l) Computed properties can be marked with both ????????? and throws._

Computed properties **cannot** be **"marked"** with `async` or `throws` in the traditional sense of property attributes. However, they can retrieve values using both the `async` and `throws` keywords in the getter, making them effectful read-only properties.

```Swift
class MrCat {
        
    var remoteFact: String {
        get async throws {
            try await CatFact.asyncThrowingCatFactMethod()
        }
    }

```

#### _m) The AsyncSequence protocol requires defining the element type and providing an ?????????._

You must provide a `makeAsyncIterator()` method.

It also requires that the `AsyncIterator` associated type be defined, which must conform to the `AsyncIteratorProtocol`.

#### _n) Task cancellation in Swift is ????????? in nature._

cooperative 

From [Swift Documentation](https://developer.apple.com/documentation/swift/task/cancel()):
> Task cancellation is cooperative: a task that supports cancellation checks whether it has been canceled at various points during its work.

#### _o) True or False: To detect if a task has been canceled, you can refer to the isCanceled attribute of the task._

True.  The `isCanceled` property indicates whether a task has been **marked** for canecllation, and should stop executing.

Alternatively, the static method `Task.checkCancellation()` can be used to throw an error if the task was canceled.

#### _p) By using async let, variables are initialized ?????????._

asynchronously

#### _q) An async let constant acts like a ????????? that either a value or an error will become available._

promise

## Part 2 - Programming Assignment
See Xcode Playground.
