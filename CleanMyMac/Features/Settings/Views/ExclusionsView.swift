import AppKit
import SwiftUI

struct ExclusionsView: View {
    @State private var exclusionService = ExclusionService()
    @State private var excludedFolders: [ExcludedFolder] = []
    @State private var selectedFolderURL: URL?
    @State private var selectedAnalyses: Set<AnalysisType> = []
    @State private var isSelectionPresented = false

    // MARK: - Methods

    private func loadExclusions() {
        excludedFolders = exclusionService.loadExclusions()
    }

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.title = "Choisir un dossier à exclure"
        panel.message =
            "Sélectionnez le dossier que vous souhaitez exclure des analyses."
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false

        guard panel.runModal() == .OK,
            let selectedURL = panel.url
        else {
            return
        }

        selectedFolderURL = selectedURL
        selectedAnalyses = [.largeFiles, .duplicates, .junk]
        isSelectionPresented = true
    }

    private func saveSelectedExclusion() {
        guard let selectedFolderURL,
            !selectedAnalyses.isEmpty
        else {
            return
        }

        let exclusion = ExcludedFolder(
            url: selectedFolderURL,
            excludedAnalyses: selectedAnalyses
        )

        exclusionService.addExclusion(exclusion)
        loadExclusions()

        self.selectedFolderURL = nil
        selectedAnalyses = []
        isSelectionPresented = false
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            PageHeader(
                title: "Dossiers exclus",
                subtitle: "Choisissez les dossiers à ignorer lors des analyses."
            ) {
                PrimaryButton(
                    title: "Ajouter un dossier",
                    icon: "folder.badge.plus",
                    action: selectFolder
                )
            }

            if excludedFolders.isEmpty {
                PlaceholderView(
                    title: "Aucun dossier exclu",
                    message:
                        "Vous n'avez pas encore ajouté de dossier aux exclusions.",
                    icon: "folder"
                )
            } else {
                List {
                    ForEach(excludedFolders) { folder in
                        ExcludedFolderRow(folder: folder)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            exclusionService.removeExclusion(excludedFolders[index])
                        }

                        loadExclusions()
                    }
                }
            }
        }
        .padding()
        .onAppear { loadExclusions() }
        .navigationTitle("Parmètres")
        .sheet(isPresented: $isSelectionPresented) {
            VStack(spacing: 20) {
                Text("Configurer l'exclusion")
                    .font(.title2.weight(.semibold))

                if let selectedFolderURL {
                    Text(selectedFolderURL.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                ExclusionSelectionView(
                    selectedAnalyses: $selectedAnalyses
                )

                HStack {
                    CancelButton(
                        title: "Annuler",
                        action: {
                            isSelectionPresented = false
                            selectedFolderURL = nil
                        }
                    )

                    PrimaryButton(
                        title: "Enregistrer",
                        action: saveSelectedExclusion
                    )
                    .disabled(selectedAnalyses.isEmpty)
                }
            }
            .padding(24)
            .frame(width: 420)
        }
    }
}
