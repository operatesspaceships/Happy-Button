# Happy Button
A custom, animated confirmation button for iOS with a completion handler. Written in Swift.

![Demo](https://user-images.githubusercontent.com/38790651/40369485-afd92994-5da3-11e8-88bb-c8cd890d286b.gif)

# Usage
1. Drag the HappyButton.swift and SeahorseStyleKit.swift into your Xcode project.
2. Drag a UIButton onto your project's storyboard.
3. Assign the HappyButton class to the button.
4. Set the button's text label and background colour.

# Additional Details
1. There are a number of IBInspectable properties that can be changed in the storyboard.
- The progress indicator's active and inactive colours.
- The button's corner radius.
- The icon's stroke colour.

2. The button and its icon are resolution-independent.
- The icon's fill settings can be manipulated in code by changed CheckImageView's 'resizingBehavior' property.

3. When the animation completes, it can optionally call a completion handler.
- You can set the completion handler's implementation details by injecting a function into the 'completion' instance property.

# For example:
```
let button = HappyButton()

button.completion = {
     print("Animation completed.
}
```
