import SwiftUI

extension View {
    /// Applies a translucent, randomly colored background and a randomly colored border to the view.
    ///
    /// This modifier is intended for debugging UI layouts by visually highlighting the frame
    /// of each view it's applied to. Each time the view is rendered or updated, the colors
    /// for the background and border will be randomly generated, making it easy to distinguish
    /// individual view boundaries and their rendering behavior.
    ///
    /// - Returns: A view with a randomly colored, translucent background and a randomly colored border.
    ///
    /// Usage:
    /// Apply this modifier to any `View` to visualize its boundaries during development.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         VStack {
    ///             Text("Hello, World!")
    ///                 .padding()
    ///                 .debugMode() // Apply the debug mode here
    ///
    ///             Rectangle()
    ///                 .frame(width: 100, height: 100)
    ///                 .debugMode() // And here
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Note: This modifier generates random colors for each application, which can be useful
    ///   for distinguishing multiple nested views. The opacity of the background is set to 0.5
    ///   to allow underlying content to be partially visible, while the border is opaque.
    ///   It should be removed for production builds.
    func debugMode() -> some View {
        return self.background(
            Color(
                red: .random(in: 0.7...1.0),
                green: .random(in: 0.7...1.0),
                blue: .random(in: 0.7...1.0),
                opacity: 0.5
            )
        )
        .border(
            Color(
                red: .random(in: 0.7...1.0),
                green: .random(in: 0.7...1.0),
                blue: .random(in: 0.7...1.0),
                opacity: 1
            ),
            width: 3
        )
    }
}
