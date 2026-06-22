import SwiftUI
import SwiftData

/// ConceptDetailView — the primary concept reading and interaction screen.
/// Named GridView.swift per the recipe but exposes ConceptDetailView struct.
struct ConceptDetailView: View {
    let concept: Concept

    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    @State private var analogyRevealed = false
    @State private var markedUnderstood = false

    var body: some View {
        ZStack {
            QMBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Field + Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text(concept.field.uppercased())
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.qmAccent)
                            .tracking(1.2)

                        Text(concept.title)
                            .font(.system(size: 32, weight: .bold, design: .default))

                        Text(formattedDate(concept.dateUnlocked))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Atom icon divider
                    HStack {
                        Image(systemName: "atom")
                            .font(.title3)
                            .foregroundStyle(Color.qmAccent)
                        Rectangle()
                            .fill(Color.qmHair)
                            .frame(height: 1)
                    }

                    // Explainer
                    VStack(alignment: .leading, spacing: 8) {
                        Text("THE IDEA")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .tracking(1)
                        Text(concept.explainer)
                            .font(.body)
                            .lineSpacing(6)
                    }

                    // Analogy reveal
                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            withAnimation(.easeOut(duration: 0.25)) {
                                analogyRevealed = true
                                Haptics.tap()
                            }
                        } label: {
                            HStack {
                                Image(systemName: analogyRevealed ? "lightbulb.fill" : "lightbulb")
                                    .foregroundStyle(Color.qmAccent)
                                Text(analogyRevealed ? "THE ANALOGY" : "Reveal the analogy")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(analogyRevealed ? .secondary : Color.qmAccent)
                                    .tracking(analogyRevealed ? 1 : 0)
                            }
                        }
                        .disabled(analogyRevealed)

                        if analogyRevealed {
                            Text(concept.analogy)
                                .font(.body)
                                .italic()
                                .foregroundStyle(.secondary)
                                .lineSpacing(6)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(16)
                    .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                    // Mark Understood button
                    let isUnderstood = concept.understood || markedUnderstood
                    if isUnderstood {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.qmCorrect)
                            Text("Marked as understood")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(Color.qmCorrect)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.qmCorrect.opacity(0.1), in: RoundedRectangle(cornerRadius: 50, style: .continuous))
                    } else {
                        Button {
                            Haptics.success()
                            appModel.markUnderstood(concept)
                            markedUnderstood = true
                        } label: {
                            Text("I understand this")
                                .frame(maxWidth: .infinity)
                        }
                        .prominentButton()
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") { dismiss() }
            }
        }
        .navigationTitle("")
        .onAppear { analogyRevealed = false }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: date)
    }
}
