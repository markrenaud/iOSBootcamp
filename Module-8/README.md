> # This README contains the answers to Module 6's homework questions.

## Part 1 - Short-Answer Questions


#### _a) Concurrency means doing ?????? things at once._

multiple

#### _b) In Swift's concurrency, the term "main actor" is often used in place of ??????._

"main thread" or "main queue"

#### _c) The main challenge of concurrent programming is that the ?????? of operations can change._

order

#### _d) URLSession is used to ?????? data from a URL._

request

#### _e) True or false: The @MainActor attribute can only be used on classes, not methods._

false

#### _f) True or False: A potential concurrency problem is when multiple code paths try to access and change the same state at the same time._

true

#### _g) The term often used to indicate when methods are not safe to use concurrently is ??????._

"not thread-safe".

#### _h) You must provide an ?????? for a background configuration so the system can reconstruct its sessions._

identifier (`String`)

#### _i) True or False: URLSession allows you to configure tasks to run in the foreground only._

false

#### _j) The three concrete subclasses of URLSessionTask are ??????, ??????, and ??????._

`URLSessionDataTask`, `URLSessionDownloadTask`, `URLSessionStreamTask` are all *concrete* subclasses of `URLSessionTask`.

It's also worth noting that `URLSessionUploadTask` is a subclass of `URLSessionDataTask`.

#### _k) True or False: The OS will always strictly follow the priority you set for a task._

false - it is a suggestion to the operating system.

#### _l) By default, the system assumes your task has a ?????? priority._

The system assumes your task has a `.medium` priority if it cannot determine the priority of the calling code path.

This answer deserves some clarification - I have seen multiple (usually reputable) resources claim otherwise.

The default priority can be confirmed with a detached task (**it is important that the task be detatched so it is not inheriting any priority from the calling code**)

```Swift
Task.detached(priority: nil) {
    print(Task.currentPriority)
}
```
Output: `TaskPriority.medium`

We can also refer to the code for TaskPriority (https://github.com/apple/swift/blob/main/stdlib/public/Concurrency/Task.swift) and see that previously used `.default` `TaskPriority` maps to the same raw value as `.medium`:

```Swift
public struct TaskPriority: RawRepresentable, Sendable {
    // ...
    public static var medium: TaskPriority {
        .init(rawValue: 0x15)
    }
    // ... 
    @available(*, deprecated, renamed: "medium")
    public static let `default`: TaskPriority = .init(rawValue: 0x15)
}
```

If the priority of the calling code can be determined, the `Task`'s default priority will be that of the calling code.

Thus, if the task is created inside of another task, its default priority is the same as the parent task.

Likewise, if the task was created on the main thread, its default priority will be `.high` (which has the same priority raw value as `.userInitiated`).

#### _m) True or False: If a cached response is available, the URL loading system will always use it instead of fetching new data._

false - The use of a cached response depends on the value of the `requestCachePolicy` property of the `URLSessionConfiguration``.

#### _n) The Network Link Conditioner allows you to simulate different network ?????? and conditions._
speed

## Part 2 - Programming Assignment
See Xcode project.


## Part 3 - Above & Beyond
See Xcode project.
