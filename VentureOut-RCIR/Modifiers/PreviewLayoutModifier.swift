
import SwiftUI

/// A view modifier that enhances the preview experience by applying a specific layout, display name, and padding.
struct PreviewLayoutModifier: ViewModifier {
    /// The display name to be shown in the preview.
    let name: String
    
    /// Modifies the view's appearance in the preview.
    ///
    /// - Parameter content: The content view to be modified.
    /// - Returns: The modified content view with preview enhancements.
    func body(content: Content) -> some View {
        content
            .previewLayout(.sizeThatFits)
            .previewDisplayName(name)
            .padding()
    }
}

extension View {
    /// A convenience method for applying the `PreviewLayoutModifier` to a view.
    ///
    /// - Parameter name: The display name to be shown in the preview.
    /// - Returns: The modified view with the specified enhancements for preview.
    func preview(with name: String) -> some View {
        self.modifier(PreviewLayoutModifier(name: name))
    }
}
