import SwiftUI
import SwiftData

struct HomeView: View {
    var forceScreen: String? = nil

    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store

    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showInsights = false
    @State private var showConcept = false

    var body: some View {
        ZStack {
            QMBackground()
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Aha")
                                .font(.largeTitle.weight(.bold))
                            Text("One idea, made simple")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.title3)
                                .foregroundStyle(Color.qmAccent)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Today's Concept Card
                    if let concept = appModel.todayConcept {
                        Button {
                            showConcept = true
                        } label: {
                            TodayConceptCard(concept: concept)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "atom")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.qmAccent)
                            Text("Loading today's concept...")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .padding(.horizontal, 16)
                    }

                    // Stats row
                    HStack(spacing: 12) {
                        MetricTile(value: "\(appModel.allConcepts.count)", label: "Unlocked")
                        MetricTile(value: "\(appModel.allConcepts.filter { $0.understood }.count)", label: "Understood")
                        MetricTile(value: "\(appModel.fieldProgressList.count)", label: "Fields")
                    }
                    .padding(.horizontal, 16)

                    // Pro Archive tile
                    Button {
                        if store.isPro {
                            showInsights = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Image(systemName: "archivebox")
                                        .foregroundStyle(Color.qmAccent)
                                    Text("Concept Archive")
                                        .font(.headline)
                                }
                                Text("Search and filter every explained concept")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if !store.isPro {
                                Text("Pro")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.qmAccent, in: Capsule())
                            } else {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .qmCard()
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(store)
                .environmentObject(appModel)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .environmentObject(store)
        }
        .sheet(isPresented: $showInsights) {
            InsightsView()
                .environmentObject(appModel)
                .environmentObject(store)
        }
        .sheet(isPresented: $showConcept) {
            if let concept = appModel.todayConcept {
                ConceptDetailView(concept: concept)
                    .environmentObject(appModel)
            }
        }
        .onAppear {
            if forceScreen == "paywall" { showPaywall = true }
            else if forceScreen == "insights" { showInsights = true }
            else if forceScreen == "settings" { showSettings = true }
        }
    }
}

// MARK: - Today Concept Card

struct TodayConceptCard: View {
    let concept: Concept

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("TODAY")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.qmAccent)
                    Text(concept.title)
                        .font(.title2.weight(.bold))
                }
                Spacer()
                if concept.understood {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.qmCorrect)
                }
            }

            Text(concept.field)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.qmAccent, in: Capsule())

            Text(concept.explainer)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(3)

            HStack {
                Image(systemName: "lightbulb")
                    .foregroundStyle(Color.qmAccent)
                Text(concept.analogy)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            }
            .padding(12)
            .background(Color.qmCard2, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            HStack {
                Spacer()
                Text("Tap to explore")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
