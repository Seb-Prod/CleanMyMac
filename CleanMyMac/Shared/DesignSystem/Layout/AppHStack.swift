import SwiftUI

/// Conteneur horizontal réutilisable de MacCleaner Pro.
///
/// Centralise l'alignement, l'espacement, les marges intérieures,
/// le fond et les dimensions afin de conserver une mise en page cohérente.
struct AppHStack<Content: View>: View {

    // MARK: - Properties

    let alignment: VerticalAlignment
    let spacing: AppSpacing
    let padding: AppPadding?
    let background: AppBackground
    let cornerRadius: AppCornerRadius
    let width: CGFloat?
    let height: CGFloat?
    let maxWidth:CGFloat?
    let content: Content

    // MARK: - Initialization

    init(
        alignment: VerticalAlignment = .center,
        spacing: AppSpacing = .medium,
        padding: AppPadding? = nil,
        background: AppBackground = .clear,
        cornerRadius: AppCornerRadius = .none,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
    maxWidth: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.padding = padding
        self.background = background
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        self.maxWidth = width
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: alignment, spacing: spacing.value) {
            content
        }
        .padding(padding?.value ?? 0)
        .background(background.shapeStyle)
        .clipShape(
            RoundedRectangle(cornerRadius: cornerRadius.value)
        )
        .frame(width: width, height: height)
        .frame(maxWidth: maxWidth)
    }
}

// MARK: - Preview

#Preview("App HStack") {
    AppHStack(
        alignment: .center,
        spacing: .medium,
        padding: .large,
        background: .secondary,
        width: 300
    ) {
        Text("Premier élément")
        Text("Deuxième élément")
        Text("Troisième élément")
    }
}
