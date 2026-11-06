import SwiftUI

/// Fond en dégradé maillé bleu/cyan/indigo, réutilisable sur toutes les pages.
///
/// - Le point central dérive lentement pour donner de la vie au fond.
/// - Les couleurs sont adaptées au mode clair et au mode sombre.
/// - L'animation est désactivée si « Réduire les animations » est actif.
struct AppBackground: View {

    /// Mode d'apparence courant (clair ou sombre).
    @Environment(\.colorScheme) private var colorScheme

    /// Préférence d'accessibilité : coupe l'animation si activée.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Bascule qui déplace le point central du maillage.
    @State private var isShifted = false

    /// Positions des 9 points de la grille 3×3.
    /// Seul le point central (index 4) bouge ; les bords restent fixes.
    private var points: [SIMD2<Float>] {
        [
            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
            [0.0, 0.5], isShifted ? [0.62, 0.42] : [0.38, 0.58], [1.0, 0.5],
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0],
        ]
    }

    /// Couleurs du maillage adaptées au mode d'apparence.
    private var colors: [Color] {
        if colorScheme == .dark {
            return [
                Color(red: 0.08, green: 0.06, blue: 0.22),
                Color(red: 0.12, green: 0.10, blue: 0.38),
                Color(red: 0.06, green: 0.15, blue: 0.34),

                Color(red: 0.16, green: 0.12, blue: 0.42),
                Color(red: 0.20, green: 0.16, blue: 0.48),
                Color(red: 0.08, green: 0.22, blue: 0.42),

                Color(red: 0.07, green: 0.06, blue: 0.20),
                Color(red: 0.13, green: 0.09, blue: 0.32),
                Color(red: 0.05, green: 0.12, blue: 0.28),
            ]
        } else {
            return [
                Color(red: 0.82, green: 0.84, blue: 1.00),
                Color(red: 0.78, green: 0.82, blue: 1.00),
                Color(red: 0.76, green: 0.88, blue: 1.00),

                Color(red: 0.80, green: 0.82, blue: 0.98),
                Color(red: 0.88, green: 0.86, blue: 1.00),
                Color(red: 0.76, green: 0.88, blue: 1.00),

                Color(red: 0.86, green: 0.84, blue: 1.00),
                Color(red: 0.82, green: 0.84, blue: 0.98),
                Color(red: 0.78, green: 0.88, blue: 1.00),
            ]
        }
    }

    var body: some View {
        MeshGradient(width: 3, height: 3, points: points, colors: colors)
            .ignoresSafeArea()
            .onAppear {
                // Pas d'animation si l'utilisateur a réduit les mouvements
                guard !reduceMotion else { return }
                withAnimation(
                    .easeInOut(duration: 9).repeatForever(autoreverses: true)
                ) {
                    isShifted = true
                }
            }
    }
}

// ── Extension d'usage ───────────────────────────────────────

extension View {

    /// Applique le fond en dégradé maillé de l'application.
    func appBackground() -> some View {
        background { AppBackground() }
    }
}
