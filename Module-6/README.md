> # This README contains the answers to Module 6's homework questions.

## Part 1 - Short-Answer Questions

#### _a) In SwiftUI, you describe your interfaces ?????? and leave the ?????? to the Framework._

In SwiftUI, you describe your interfaces **declaratively** and leave the **drawing and updating of views** to the Framework.

#### _b) When a `View` first appears, and you want it to animate in, you can do so in the Views ?????? modifier._

The question is somewhat ambiguous as both `.transition(_:)` and `.onAppear` modifiers are required.

The `.transition(_:)` modifier specifies the transition to be applied when a `View` appears or disappears, allowing for animating it in and out.

However, the `.onAppear` modifier is where you would trigger state changes that cause a `View` to animate. The associated state changes would need to be inside of a `withAnimation` block to animate.


For example:
```Swift
struct AnimateInView: View {
    @State private var showingView: Bool = false

    var body: some View {
        VStack {
            if showingView {
                Text("I have arrived")
                    .transition(.slide)
            }
        }
        .onAppear {
            withAnimation {
                showingView = true
            }
        }
    }
}
```

#### _c) In Swift, the native types ?????? and ?????? implement the `Hashable` protocol._

There are multiple native Swift types that implement the `Hashable` protocol: https://developer.apple.com/documentation/swift/hashable#conforming-types.

Two frequently used native types that implement `Hashable` are:
1. `String`
2. `Int`

#### _d) ?????? is how long an animation takes to complete._

Duration 

#### _e) The `ScrollViewReader` requires each view inside the `ScrollView` to have a unique ?????? to identify and navigate to them._

`.id(_:)` modifier

#### _f) ?????? protocol’s only requirement is to have an id property that conforms to `Hashable`._

`Identifiable`

#### _g) A ?????? `Grid` lets you specify an exact size for a column or row._

`GridItem.Size.fixed(_:)` lets you specify an exact size for a column or row.

Considering this question might be a little ambiguous in the context of the latest SwiftUI framework, I am going to assume the question was written before iOS 16 and the actual introduction of the `Grid` view.

See also my answer to question **j** below.

#### _h) ?????? allows you to scroll to any position inside a `ScrollView` programmatically._

A `ScrollViewReader`'s `ScrollViewProxy`

#### _i) True or False: All animations in SwiftUI are interruptible and reversible by default._

True

#### _j) The ?????? defines how items in a `Grid` should be sized and aligned._

`GridItem` array

I'm presuming this question, like previous module questions (and answer g of this module), refers to `Grid` as a generic term for `LazyVGrid` and `LazyHGrid` prior to iOS 16. 

iOS 16 introduced a new `Grid` view which is laid out quite differently.

For `LazyVGrid` and `LazyHGrid`, the **`GridItem`** array is the key determinant in defining how items should be sized and aligned.

For an iOS 16+ `Grid` view, the determinants of how items are sized and aligned include:
- The contents of each `GridRow`
- The alignment and spacing parameters specified when the `Grid` is instantiated
- Any applied view modifiers.

#### _k) Wrap any changes you want to animate in a call to ??????_

Wrap any changes you want to animate in a call to **`withAnimation`**.

#### _l) The native SwiftUI grid view builds on the ?????? and ?????? views._

The native SwiftUI grid view builds on the **`VStack`** and **`HStack` views.**

#### _m) The ?????? method of `ScrollViewReader` is used to navigate to a particular position in a `ScrollView`._

`scrollTo(_:anchor:)`

However, it should be noted that `scrollTo(_:anchor:)` is a method on the `ScrollViewReader`'s **`ScrollViewProxy`** (**not** a direct method on `ScrollViewReader` itself)


## Part 2 - Programming Assignment
See Xcode project.


## Part 3 - Above & Beyond
See Xcode project.
