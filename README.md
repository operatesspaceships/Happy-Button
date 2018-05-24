# Happy Button
A custom, animated confirmation button for iOS with a completion handler. Written in Swift.

![Run Once Demo](https://user-images.githubusercontent.com/38790651/40490696-da57c6dc-5f31-11e8-9e21-191770f4b046.gif)

![Loop Demo](https://user-images.githubusercontent.com/38790651/40491083-c4c0366e-5f32-11e8-9d8d-e95e5cb1cab5.gif)

# Usage
1. Drag the HappyButton.swift and SeahorseStyleKit.swift into your Xcode project.
2. Drag a UIButton onto your project's storyboard.
3. Assign the HappyButton class to the button.
4. Set the button's text label and background colour.

# Additional Details
1. There are a number of IBInspectable properties that can be changed in the storyboard.
     - The progress indicator's active and inactive colours.
     - The progress indicator's border width.
     - The button's corner radius.
     - The icon's stroke colour.
     - Whether the animation should run once or loop until interrupted by a callback.

2. The button and its icon are resolution-independent.
     - The icon's fill settings can be manipulated in code by changed CheckImageView's 'resizingBehavior' property.

3. When the animation completes, it can optionally call a completion handler.
     - You can set the completion handler's implementation details by injecting a function into the 'completion' instance property.
     - If you opt to loop the animation, you can pass in your completionHandler via a trailing closure when you call button.perform(action: andCall: ).

# Example:
```
let button = HappyButton()

button.completion = {
     print("Animation completed.")
}
```
