import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    private let benefits: [(icon: String, text: String)] = [
        ("archivebox", "Searchable archive of every explained concept"),
        ("slider.horizontal.3", "Pick which fields appear more often"),
        ("bell.badge", "Daily concept reminder with a learning streak")
    ]

    var body: some View {
        ZStack {
            QMBackground()
            VStack(spacing: 0) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.qmCard)
                        .frame(width: 88, height: 88)
                    Image(systemName: "atom")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.qmAccent)
                }
                .padding(.bottom, 20)

                Text("Aha Pro")
                    .font(.largeTitle.weight(.bold))

                Text("\(store.displayPrice) / month. Auto-renews until you cancel.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 4)

                // Benefits
                VStack(spacing: 16) {
                    ForEach(benefits, id: \.text) { benefit in
                        HStack(spacing: 14) {
                            Image(systemName: benefit.icon)
                                .font(.body)
                                .foregroundStyle(Color.qmAccent)
                                .frame(width: 24)
                            Text(benefit.text)
                                .font(.body)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                    }
                }
                .padding(20)
                .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.top, 28)

                Spacer()

                // Actions
                VStack(spacing: 12) {
                    Button {
                        Task { await store.purchase() }
                    } label: {
                        Group {
                            if store.purchaseInFlight {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Unlock Aha Pro")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .prominentButton()
                    .disabled(store.purchaseInFlight)
                    .padding(.horizontal, 24)

                    Button {
                        Task { await store.restore() }
                    } label: {
                        Text("Restore Purchase")
                            .font(.subheadline)
                            .foregroundStyle(Color.qmAccent)
                    }
                }

                // Disclosure
                Text("Subscription auto-renews monthly at \(store.displayPrice) until cancelled in App Store settings. Cancel anytime.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.top, 12)

                HStack(spacing: 16) {
                    Link("Terms", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    Link("Privacy", destination: URL(string: "https://shimondeitel.github.io/aha-site/privacy.html")!)
                }
                .font(.caption)
                .foregroundStyle(Color.qmAccent)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .onChange(of: store.isPro) { _, newVal in
            if newVal { dismiss() }
        }
    }
}
