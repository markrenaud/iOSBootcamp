> # This README contains the answers to Module 5's homework questions.

## Part 1 - Short-Answer Questions

#### _a) ?????? are used to customize the appearance and behavior of a View._

View modifiers

#### _b) The basic building block of a SwiftUI interface is a ??????._

`View`

#### _c) Each View in SwiftUI is a ?????? type._

value type (`struct`)

#### _d) List two ways you can find the modifiers of a View._
- Checking the Developer Documentation for the specific `View`.
- Use the *Modifiers* section of the *Library* and scrolling to the section relevant for the `View` (eg. `Text`).

#### _e) True or False: A modifier changes a View._

**true** - a modifier, when applied to a `View`, returns a modified version of the original `View` with the specified changes. This *new* version can have altered properties (layout, behaviour, etc).

#### _f) Modifiers are performed and returned in ?????? from the ?????? they are applied to._

Modifiers are performed and returned in **order** (top to bottom) from the **View** they are applied to.

#### _g) When the data driving a View changes, that View has to be ?????? to reflect the change._

recomputed/updated

#### _h) True or False: The @Binding establishes a two-way connection between Views._

true

#### _i) @State works with ?????? types and @StateObject works with ?????? types._

- Prior to iOS 17: `@State` works with value types and `@StateObject` works with reference types.
- iOS 17: With the new [Observation Framework](https://developer.apple.com/documentation/observation), `@State` can now handle appropriate reference types.

#### _j) True or False: A @State property can be defined as let (constant)._

false

#### _k) A List is a specialized version of a ?????? stack._

The question seems to be seeking the answer **vertical stack** (`VStack`).

However, this is not quite true - `List` is actually a wrapped UIKit `UICollectionView` under the hood.  (You can check via using the `Debug View Hierarchy` tool)

A `List` can offer memory benefits over **very** large vertical stacks (including `LazyVStacks`) as `UICollectionView` **reuses** cells.  A `LazyVStack` is "lazy" in that it creates a subview when it first appears on the screen, however, it will *not* 'evict' the subview when it disappears from screen.  This can cause performance issues when scrolling deep in stacks with *massive* numbers of subviews (increasing memory usage as each new view that is created).

#### _l) The default alignment of a VStack is ??????, and the default alignment of the HStack is ??????._

- `VStack` default alignment: `HorizontalAlignment.center`
- `HStack` default alignment: `VerticalAlignment.center`

#### _n) A stack always gets one ?????? from each of its children._

`View`

#### _o) The alignment guide for an HStack is ??????. And the alignment guide for a VStack is ??????._

- The alignment guide for an HStack is **vertical** (`VerticalAlignment`).
- The alignment guide for an VStack is **horizontal** (`HorizontalAlignment`).

#### _p) Grids only come in ?????? variants._

The question seems to be seeking the answer **`Lazy`** (as in `LazyHGrid` & `LazyVGrid`).

However, as of iOS 16, there is also the `Grid` View which is in fact "eager".  As per the documentation: 

> A grid can size its rows and columns correctly because it renders all of its child views immediately. If your app exhibits poor performance when it first displays a large grid that appears inside a ScrollView, consider switching to a LazyVGrid or LazyHGrid instead.

reference: [SwiftUI Documentation: Grid](https://developer.apple.com/documentation/swiftui/grid#Performance-considerations)


#### _q) The Grid Item Array defines the ?????? of the Grid._

Assuming we are talking about `LazyHGrid` & `LazyVGrid`:
- LazyHGrid: the `GridItem` array defines the size and position each **column** of the grid
- LazyVGrid: the `GridItem` array defines the size and position each **row** of the grid

## Part 2 / 3 - Programming Assignment / Above and Beyond

See the Xcode project for Part 2 and Part 3.

Note:
- Given the requirements, the programming assignment has been completed with a minimum iOS deployment target of 16 (it does not make use of the new Observation Framework).
- The model to represent a "Task" was named `TaskItem` rather than `Task` (to avoid namespace issues with Swift's concurrency task).
- The programming assignment has been implemented to best meet the assignment requirements. (My personal implementation approach might differ for my own app).
