> ### This README contains the answers to Module 1's homework questions.

## Part 1 - Short-Answer Questions

#### _a) What does the command `git status` output?_

The `git status`  command shows the current state of the local Git repository. This includes the active branch and modified files, both staged and unstaged, as well as its position in relation to any connected remote repositories.

#### _b) In SwiftUI, anything that gets drawn on the screen is a **`View`**._

#### _c) print(“Hello world”) is an example of a **`(global) function`** call._
#### _viewModel.getData() is an example of a **`method`** call._

#### _d) Name some Views you have seen so far in SwiftUI._

- `HStack`
- `VStack`
- `Text`
- `Slider`


#### _e) How do you create a new local repository using git? (Feel free to answer with how you use git, i.e. terminal or another app)_

In Terminal (at the root folder of the project), execute:
`git init` 

#### _f) How do you preview your app in multiple orientations?_

There are a number of ways to do this in Xcode:

- Click on the `variants` button and select `orientation variants`

- Create multiple previews using the `#Preview` macro in Xcode 15:
```
#Preview("Portrait") {
    ContentView()
        .previewInterfaceOrientation(.portrait)
}
#Preview("Landscape Left") {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)
}
```
- Create multiple previews using `PreviewProvider` in earlier versions of Xcode:

```
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Portrait")
            .previewInterfaceOrientation(.portrait)
        ContentView()
            .previewDisplayName("Landscape Left")
            .previewInterfaceOrientation(.landscapeLeft)

    }
}
```

#### _g) An app is made up of **`instances`** of **`classes`** and **`structs`** that contain **`data`** and **`methods`**._

#### _h) Name two components of a SwiftUI Button._

- A `title` to display.
- An `action` to be performed.

#### _i) In git, what is the difference between a local repository and a remote repository?_

- A `local repository` is a copy of the code and version history on the local device (eg., a laptop).  This allows the programmer to work on fixes/features/code independently.  As it is a local copy, the repository can be accessed offline.

- A `remote repository` is the code and version history stored in a central location that can be accessed by multiple programmers.  It can be used as a point of collaboration, and the ‘main’ branch of the remote repository is often considered ‘the source of truth’ for the official codebase.  The remote repository is often stored in the cloud or on a LAN, thus requiring internet or network access.

#### _j) Give an example of camel case._

`thisIsCamelCase`

#### _k) What is a branch in git, and how do you create one? (Feel free to answer with how you use git, i.e. terminal or another app)_

A `branch` is a copy of the main codebase where the programmer can develop new features/fixes/experiment.  Once checked into this new branch, the developer can make changes to the working tree without affecting the main (or other) branches.  

- `git branch [my-new-branch]` (to create a new branch)
- `git checkout [my-new-branch]` (to switch to the new branch)  

#### _l) What are some common mistakes that can lead to errors while programming?_

- A typographical error.
- A case sensitivity error.
- Forgetting to close scope with a brace or parentheses.

#### _m) VStack, HStack, and ZStack are **`container`** views used for **`laying out subviews (vertically, horizontally, depth-wise respectively)`**._

#### _n) How do you list the branches on your local repository? (Feel free to answer with how you use git, i.e. terminal or another app)_

`git branch`

#### _o) What happens when @State variable changes in SwiftUI?_

SwiftUI automatically reevaluates the `body` computed property for views in the heirarchy that depend on the underlying value.


#### _p) What is the Single Responsibility Principle?_

It is a way of organising code where each class or struct is responsible for a single task or job.
Improves ability to understand, modify, and test the code.

#### q) What will the print statement below produce?
```var name = “Ozma”
print(“Hello, \(name)!”)
```

It would output:
	`Hello, Ozma!`

#### _r) What commands can you use in git to download data from a remote repository? What commands can you use in git to send data to a remote repository? (Feel free to answer with how you use git, i.e. terminal or another app)_

- Downloading data from a remote repository:

    - `git clone` : creates a local repository from a remote repository 
    - `git fetch` : fetches any changes from a remote repository but does not merge these changes into the local repositories working directory (ie. we can see that there are changes on the server, but they haven’t impacted the local working code).
    - `git pull` : fetches changes from a remote repository and merges those changes into the local repositories branch.

- Sending data to a remote repository:
    - `git push`: sends the local staged and committed files to the remote repository 

#### _s) Why is a programming To-Do list important, and what is a minimum viable product?_

A `To-Do list` helps the programmer to think about the functionality of the program upfront. This helps to define what the program should achieve before actually implementing the functionality, aiding in clarifying the goals of the program before development begins.

A `minimum viable product` (MVP) is an app that includes just the core functionality required to make the program perform its vital ("must-haves") functions.

#### _t) What is a simple way of describing Binding in SwiftUI?_

A bidirectional interface between a SwiftUI component the user interacts with (e.g., a Slider) and the underlying stored value (e.g., a Float). In the slider example: a change of the Slider by the user automatically updates the underlying Float value it represents. Likewise, a change in the stored Float value automatically updates the position of the Slider seen by the user.

One very nice way that I have heard a Binding described is: "a reactive glue between a UI component and a data source - holding them together so that changes in one are automatically reflected in the other."

#### _u) What command do you use in git to move changes from one branch to another? (Feel free to answer with how you use git, i.e. terminal or another app)_

`git merge`

For example if you wanted to move the changes from branch `feature-branch` into `main`:

- Ensure you are on the `main` branch 
    - if not, switch to the `main` branch using: `git checkout main`.
- Merge in the changes from `feature-branch` using: `git merge feature1`.

### _v) What is the type of the variable defined below?_
``` 
var a = 87
```

`Int` (integer)

#### _w) What is the difference between var and let?_

- A `var` is a variable, meaning that the value assigned to it can be changed over the lifetime of its scope.
- A `let` is a constant, meaning that the value assigned to it is fixed and cannot be changed over the lifetime of its scope.


## Part 2 - Programming Assignment


Refer to the code in `ContentView.swift`.


## Part 3 - Above and Beyond

> These answers refer to code in the Homework document.

In ContentView, lines 1 and 2 show the definition of `State Properties`.

In ContentView, line 3 shows the definition of an `Instance Property`.

In ContentView, line 4 shows the definition of a `Computed Property`.

In ContentView, line 5 shows an `Instance` of Game calling the `Method` points.

In ContentView, line 6 is the definition of the `Method` doSomethingWithCounter().

In Game, lines a, b, and c show the definition of `Instance Properties`.

In Game, line d is the definition of the `Function` points(sliderValue: Int).

Lines 3, a, b, and c are the `Instance Properties` and lines 6 and d are the `Methods` of the structs.
