> # This README contains the answers to Module 2's homework questions.

## Part 1 - Short-Answer Questions

#### _a) Describe the two size classes in iOS._

iOS currently defines two size classes: `compact` and `regular`.  
These size classes are used both vertically and horizontal - and can be used to help tailor content to different layouts.


For example on the **iPhone 15 Pro**: 

| orientation | horizontal size class | vertical size class |
| ----------- | --------------------- | ------------------- |
| portrait    | `.compact`            | `.regular`          |
| landscape   | `.compact`            | `.compact`          |

#### _b) What is Continuous Learning, and why is it important in mobile development?_

Continuous Learning is the process of consistently updating and expanding one's knowledge and skills in a specific area.

Continuous learning is crucial in software development, much like in the field of medicine, where there is a vast and ever-evolving body of knowledge. Engaging in continuous learning ensures that developers remain relevant and informed about the latest technologies and practices and retain existing skills.

#### _c) How can you find out what modifiers a View has?_

There are a number of ways to find modifiers for a View, including

- Checking the Developer Documentation for the specific View.
- Referring to `SwiftUI` > `Views` > `View fundamentals` >  `Configuring view elements` subsections in Developer Documentation.
- Select the View in the editor window or the Canvas (when in `Selectable` mode), then go to the `Attributes Inspector` in the `Inspectors` side drawer.  
- Use the `Modifiers` section of the `Library` and scroll to the section relevant for the View (eg. Text).

#### _d) What is a breakpoint?_

A breakpoint is a way to interrupt and pause running code at a defined line in order to debug and inspect variables in the app.  The execution of code can then be controlled and stepped through.

#### _e) How can you access environment values in your App?_

With the `@Environment` property wrapper using the associated `EnvironmentValue` key path for the relevant property.

eg. 
```
    @Environment(\.verticalSizeClass) var verticalSizeClass
```

#### _f) How can you determine, in code, if the App is in Dark or Light Mode?_

By checking the `colorScheme` environment value:

```
@Environment(\.colorScheme) var colorScheme
```

Which will be either: `ColorScheme.light` or `ColorScheme.dark`

#### _g) Why are magic numbers an issue, and how should you avoid them?_

“Magic numbers” are hard-coded numeric values that are used directly in code  The term “magic” is used because the number has unexplained meaning.

Magic numbers issues:
- **Reduced readability** of the code (hard to understand what the number represents without context).
-  **Reduced maintainability** (if the same number is used in multiple places, it needs to be changed everywhere it occurs; are all cases where that number is used representing the same concept?).
- **Difficulty debugging** (if the magic number is causing the issue, where did it come from, and why is it there?).

Magic numbers can be avoided by using named constants or creating sets of related constants (e.g., using enums or static variables in structs).

#### _h) How can you view your App in Light and Dark Modes simultaneously?_

- Choosing the `Color Scheme Variants` in the Xcode Canvas.
- Creating multiple previews in the `PreviewProvider` for the `View` with associated `.preferredColorScheme(_:) ` modifiers and switch between the two.

#### _i) Below is an image of the Canvas from Xcode. The Canvas is in selectable mode. Can you explain why the red background does not cover the entire button area?_

The order modifiers applied to a View matters.

The shown result is likely due to a `padding` modifier being applied **after** a `background` modifier.

By moving the `padding` modifier **before** the `background` modifier, the desired outcome can be achieved.

Change:
```
Text("Delete")
    .foregroundStyle(.white)
    .background(.red)
    .padding()
```            

To:
```
Text("Delete")
    .padding()
    .foregroundStyle(.white)
    .background(.red)
```

#### _j) Modifier padding(10) adds padding to the view's top, bottom, left, and right sides. How could a padding of 10 be added to only the left and right sides of the view? The answer for this question should be a short section of code._

```
Text("Delete")
    .padding(.horizontal, 10)
```

#### _k) Provide two reasons why you would want to extract views._

- To increase code reusability.
- To decompose complex view into a series of simpler subviews.

#### _l) How can you determine, in code, if the device is in Portrait or Landscape mode?_

SwiftUI promotes using vertical and horizontal size class Environment variables to determine how a View should be laid out. On most iPhones, using the vertical size class can be used as a proxy for determining if the device is in Portrait or Landscape mode (refer to the table in answer to a).

It is important to remember that some devices (eg. iPad) may allow for multitasking, split screens, and multiple windows. The size classes in such instances refer only to the area the system gives the app to render (and thus cannot always determine the device orientation).

A (non-SwiftUI) alternative way would be to call into UIKit and read the `UIDevice.current.orientation` property, which will provide information regarding the physical device orientation.

#### _m) What is a literal value?_

A literal value is a value that is used directly in code (cf. a value that is used from a variable/constant).

In the following code example, `25.0` is a literal value:
```
RoundedRectangle(cornerRadius: 25.0)
```

#### _o) What are the safe areas?_

Safe areas are the zones of the display screen that are not covered by interactive (eg. toolbar, navigationbar) or display features (eg. notch, dynamic island).

#### _p) This line of code was in the lesson on animation. Can you state in English what the line means?
.frame(width: wideShapes ? 200 : 100)_

This is a ternary operator.  It essentially compresses an `if-else` statement to one line.

Here, the frame’s width is set to 200 points if the `wideShapes` property is `true`, or 100 points if the `wideShapes` property is `false`.

#### _q) Describe the two transitions you were introduced to in this week’s lesson._

- Scale transition: scales the size of the view during the transition.
- Opacity transition: adjusts the opacity of the view (fades in on appear, fades out on disappear) during the transition.

#### _r) In Bullseye, the Game struct is what type of object?__

Data model.

#### _s) What are SFSymbols?_

SF Symbols are interface icons provided by Apple that can be used without the need to import individual assets into the project. They are designed to be consistent with Apple’s Human Interface Guidelines and have variants that can be customized.

SF Symbols can also refer to the Apple app that can be used to browse the icons.

#### _t) What is the difference between “step into” and “step over " in the debugger?”_

- `Step Into` jumps to and executes the next instruction - whether this is in the current function or inside another method or function
- `Step Over` executes the next line of code in the same function but does not step into any function calls.

#### _u) Name some items you would place in the Asset Catalog (Assets.)_
- Colors.
- Icons.
- Images.

#### _v) How do you change the Display Name of your app?_

By updating the `Display Name` field for the app'a Target (under the `General` tab).


## Part 2 - Programming Assignment

Refer to the project code.


## Part 3 - Above and Beyond

Refer to the project code.


