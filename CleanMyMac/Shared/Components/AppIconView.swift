import SwiftUI

/// Une vue SwiftUI qui affiche l'icône principale de l'application.
///
/// Cette vue charge dynamiquement le fichier `AppIcon.icns` depuis le bundle principal
/// et l'affiche dans un cadre redimensionnable. Si l'icône n'est pas trouvée,
/// la vue reste vide.
struct AppIconView: View {
    /// La taille (largeur et hauteur) de l'icône.
    /// La valeur par défaut est de 80 points.
    var size: CGFloat = 80

    var body: some View {
        Group {
            if let appIconURL = Bundle.main.url(
                forResource: "AppIcon",
                withExtension: "icns"
            ),
                let appIcon = NSImage(contentsOf: appIconURL)
            {
                Image(nsImage: appIcon)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: size, height: size)
        .shadow(
            color: .black.opacity(0.15),
            radius: 6,
            y: 3
        )
    }
}
