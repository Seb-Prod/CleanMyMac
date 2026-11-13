import SwiftUI

// MARK: - Stack Axis

/// Définit l'orientation du conteneur AppStack.
enum AppStackAxis: String, CaseIterable {
    case vertical
    case horizontal
}

/// Conteneur adaptatif permettant de choisir entre une disposition verticale ou horizontale.
struct AppStack<Content: View>: View {

    // MARK: - Properties

    let axis: AppStackAxis
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: AppSpacing
    let padding: AppPadding?
    let background: AppBackground
    let cornerRadius: AppCornerRadius
    let width: CGFloat?
    let height: CGFloat?
    let maxWidth: CGFloat?
    let content: Content

    // MARK: - Initialization

    init(
        axis: AppStackAxis,
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: AppSpacing = .medium,
        padding: AppPadding? = nil,
        background: AppBackground = .clear,
        cornerRadius: AppCornerRadius = .none,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.padding = padding
        self.background = background
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        self.maxWidth = maxWidth
        self.content = content()
    }

    // MARK: - Body

    @ViewBuilder
    var body: some View {
        switch axis {
        case .vertical:
            AppVStack(
                alignment: horizontalAlignment,
                spacing: spacing,
                padding: padding,
                background: background,
                cornerRadius: cornerRadius,
                width: width,
                height: height
            ) {
                content
            }

        case .horizontal:
            AppHStack(
                alignment: verticalAlignment,
                spacing: spacing,
                padding: padding,
                background: background,
                cornerRadius: cornerRadius,
                width: width,
                height: height
            ) {
                content
            }
        }
    }
}

// MARK: - Preview

#Preview("AppStack Horizontal") {
    AppStack(
        axis: .horizontal,
        horizontalAlignment: .center,
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

#Preview("AppStack Vertical") {
    AppStack(
        axis: .vertical,
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
