import SwiftUI
import SwiftData

/// InsightsView — Pro feature: searchable archive, field filter, streak.
struct InsightsView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedField: String? = nil
    @State private var selectedConcept: Concept? = nil

    private var allFields: [String] {
        Array(Set(appModel.allConcepts.map { $0.field })).sorted()
    }

    private var filtered: [Concept] {
        var base = appModel.allConcepts
        if let field = selectedField {
            base = base.filter { $0.field == field }
        }
        if !searchText.isEmpty {
            let lower = searchText.lowercased()
            base = base.filter {
                $0.title.lowercased().contains(lower) ||
                $0.field.lowercased().contains(lower) ||
                $0.explainer.lowercased().contains(lower)
            }
        }
        return base
    }

    private var streak: Int {
        let understood = appModel.allConcepts.filter { $0.understood }
            .map { Calendar.current.startOfDay(for: $0.dateUnlocked) }
            .sorted(by: >)
        var count = 0
        var check = Calendar.current.startOfDay(for: Date())
        for date in understood {
            if date == check {
                count += 1
                check = Calendar.current.date(byAdding: .day, value: -1, to: check)!
            } else {
                break
            }
        }
        return count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                VStack(spacing: 0) {
                    // Stats row
                    HStack(spacing: 12) {
                        MetricTile(value: "\(appModel.allConcepts.count)", label: "Total")
                        MetricTile(value: "\(appModel.allConcepts.filter { $0.understood }.count)", label: "Understood")
                        MetricTile(value: "\(streak)", label: "Streak")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                    // Field filter pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterPill(label: "All", isSelected: selectedField == nil) {
                                selectedField = nil
                            }
                            ForEach(allFields, id: \.self) { field in
                                FilterPill(label: field, isSelected: selectedField == field) {
                                    selectedField = selectedField == field ? nil : field
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }

                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search concepts...", text: $searchText)
                            .textFieldStyle(.plain)
                    }
                    .padding(12)
                    .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                    // Concept list
                    List(filtered, id: \.id) { concept in
                        Button {
                            selectedConcept = concept
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(concept.title)
                                        .font(.body.weight(.medium))
                                        .foregroundStyle(.primary)
                                    Text(concept.field)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if concept.understood {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.qmCorrect)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $selectedConcept) { concept in
                NavigationStack {
                    ConceptDetailView(concept: concept)
                        .environmentObject(appModel)
                }
            }
        }
    }
}

// MARK: - Filter Pill

struct FilterPill: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(isSelected ? .white : Color.qmAccent)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.qmAccent : Color.qmCard,
                            in: Capsule())
        }
        .buttonStyle(.plain)
    }
}
