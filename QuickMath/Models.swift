import SwiftUI
import SwiftData

// MARK: - SwiftData Models

@Model
final class Concept {
    var id: String
    var title: String
    var field: String
    var explainer: String
    var analogy: String
    var dateUnlocked: Date
    var understood: Bool

    init(id: String, title: String, field: String, explainer: String, analogy: String, dateUnlocked: Date, understood: Bool = false) {
        self.id = id
        self.title = title
        self.field = field
        self.explainer = explainer
        self.analogy = analogy
        self.dateUnlocked = dateUnlocked
        self.understood = understood
    }
}

@Model
final class FieldProgress {
    var field: String
    var conceptsSeen: Int

    init(field: String, conceptsSeen: Int = 0) {
        self.field = field
        self.conceptsSeen = conceptsSeen
    }
}

// MARK: - Concept catalogue (built-in daily backlog)

struct ConceptEntry {
    let id: String
    let title: String
    let field: String
    let explainer: String
    let analogy: String
}

let allConceptEntries: [ConceptEntry] = [
    ConceptEntry(id: "entropy", title: "Entropy", field: "Physics",
                 explainer: "Entropy is the universe's tendency to spread energy out evenly. Ordered systems naturally drift toward disorder unless energy is added to maintain them.",
                 analogy: "A tidy desk that slowly gets messy on its own — putting it back in order always costs effort."),
    ConceptEntry(id: "natural_selection", title: "Natural Selection", field: "Biology",
                 explainer: "Individuals with traits that help them survive and reproduce pass those traits to offspring. Over generations, useful traits become common while harmful ones fade.",
                 analogy: "A filter that keeps the designs that work and discards the rest — no engineer required."),
    ConceptEntry(id: "relativity", title: "Special Relativity", field: "Physics",
                 explainer: "The speed of light is the same for every observer. As a result, time slows and lengths shrink for objects moving fast — and mass and energy are interchangeable (E=mc²).",
                 analogy: "Two trains moving at different speeds both see the same headlight beam — so their clocks must tick at different rates to make it work."),
    ConceptEntry(id: "quantum_superposition", title: "Quantum Superposition", field: "Physics",
                 explainer: "A quantum particle can exist in multiple states simultaneously until it is measured. Measurement collapses all possibilities into one definite outcome.",
                 analogy: "A coin spinning in the air is neither heads nor tails — only landing (measuring) pins it down."),
    ConceptEntry(id: "dna_replication", title: "DNA Replication", field: "Biology",
                 explainer: "Before a cell divides, special proteins unzip the double helix and copy each strand, producing two identical DNA molecules with one old and one new strand each.",
                 analogy: "A zipper being pulled open while two copy-machines trace each exposed track to produce a perfect duplicate."),
    ConceptEntry(id: "black_holes", title: "Black Holes", field: "Astronomy",
                 explainer: "A black hole forms when mass is compressed so densely that its gravity prevents even light from escaping. The boundary of no return is called the event horizon.",
                 analogy: "A drain in a bathtub so powerful that even soap bubbles cannot swim away from it."),
    ConceptEntry(id: "neural_plasticity", title: "Neuroplasticity", field: "Neuroscience",
                 explainer: "The brain rewires itself in response to experience. Neurons that fire together form stronger connections; unused pathways weaken and are pruned.",
                 analogy: "A field where paths appear wherever people walk most often, and overgrow where nobody treads."),
    ConceptEntry(id: "plate_tectonics", title: "Plate Tectonics", field: "Earth Science",
                 explainer: "Earth's crust is split into large plates that float on molten rock and drift a few centimetres per year. Their collisions and separations create mountains, earthquakes, and ocean trenches.",
                 analogy: "Puzzle pieces floating on a slow lava conveyor belt, occasionally crashing into or sliding under each other."),
    ConceptEntry(id: "photosynthesis", title: "Photosynthesis", field: "Biology",
                 explainer: "Plants convert sunlight, water, and CO₂ into glucose and oxygen. Light energy is captured by chlorophyll and stored as chemical energy in sugar bonds.",
                 analogy: "A solar panel that pays its electricity bill in food instead of money."),
    ConceptEntry(id: "game_theory", title: "Nash Equilibrium", field: "Mathematics",
                 explainer: "In a strategic situation, a Nash equilibrium is reached when no player can improve their outcome by changing strategy while everyone else stays put.",
                 analogy: "Traffic that settles into patterns where switching lanes would only make your commute worse."),
    ConceptEntry(id: "big_bang", title: "The Big Bang", field: "Cosmology",
                 explainer: "Around 13.8 billion years ago all matter, energy, space and time emerged from an extremely hot, dense state and has been expanding and cooling ever since.",
                 analogy: "Not an explosion in space but an expansion of space itself — like dots drawn on a balloon as it inflates."),
    ConceptEntry(id: "immune_system", title: "Adaptive Immunity", field: "Biology",
                 explainer: "After encountering a pathogen, B and T cells learn to recognise its protein markers. Memory cells persist so future encounters trigger a faster, stronger response.",
                 analogy: "A security force that photographs intruders and trains a specialist squad — always ready for a repeat attack."),
    ConceptEntry(id: "supply_demand", title: "Supply and Demand", field: "Economics",
                 explainer: "Prices rise when buyers want more than sellers offer, and fall when sellers offer more than buyers want. The market-clearing price balances both sides.",
                 analogy: "A scale that tips toward the heavier side until weight is added to the lighter pan to level it."),
    ConceptEntry(id: "crispr", title: "CRISPR-Cas9", field: "Genetics",
                 explainer: "CRISPR is a bacterial immune memory repurposed as a gene editor. A guide RNA steers the Cas9 protein to a precise DNA sequence, where it cuts — allowing insertion, deletion, or replacement of genes.",
                 analogy: "A GPS-guided molecular scissors that snips a sentence from a book at exactly the right page."),
    ConceptEntry(id: "machine_learning", title: "Gradient Descent", field: "Computer Science",
                 explainer: "A learning algorithm tunes its parameters by measuring its error and nudging each parameter slightly in the direction that reduces that error, step by step.",
                 analogy: "Finding the lowest valley in foggy hills by always taking a small step downhill wherever the slope is steepest."),
    ConceptEntry(id: "fermats_theorem", title: "Fermat's Last Theorem", field: "Mathematics",
                 explainer: "There are no whole-number solutions to xⁿ + yⁿ = zⁿ for any n greater than 2. Fermat claimed a proof in 1637; Andrew Wiles finally provided one in 1995.",
                 analogy: "Pythagoras's triangle rule works perfectly for squares, but the moment you cube the sides, the equation refuses to balance with whole numbers."),
    ConceptEntry(id: "information_theory", title: "Shannon Entropy", field: "Computer Science",
                 explainer: "Information content is measured by surprise. A coin flip carries one bit. Events that always happen carry no information; unpredictable ones carry the most.",
                 analogy: "News headlines: 'Sun rises again' tells you nothing; 'Airport vanishes overnight' tells you a lot."),
    ConceptEntry(id: "oxidation", title: "Oxidation and Reduction", field: "Chemistry",
                 explainer: "Oxidation is the loss of electrons; reduction is the gain of electrons. These always happen together — one substance loses electrons that another gains.",
                 analogy: "A two-lane tollbooth: every car leaving the left lane instantly fills a spot in the right lane."),
    ConceptEntry(id: "dopamine", title: "Dopamine and Reward", field: "Neuroscience",
                 explainer: "Dopamine signals predicted reward and surprise. It spikes when something better than expected happens and drops below baseline when an expected reward does not arrive.",
                 analogy: "A radio station that turns the volume up for unexpected good songs and cuts out briefly when a promised song doesn't play."),
    ConceptEntry(id: "habeas_corpus", title: "Habeas Corpus", field: "Law",
                 explainer: "Habeas corpus is the legal right to have a court decide whether your detention is lawful. It prevents governments from holding people indefinitely without judicial review.",
                 analogy: "A required receipt: the government must show a judge the 'invoice' for locking someone up before the cage can stay locked."),
    ConceptEntry(id: "compound_interest", title: "Compound Interest", field: "Economics",
                 explainer: "Interest earned on an investment is added to the principal, so future interest is calculated on a larger base. This creates exponential, not linear, growth over time.",
                 analogy: "A snowball rolling downhill — each rotation adds more snow, making each next rotation add even more."),
    ConceptEntry(id: "wave_particle", title: "Wave-Particle Duality", field: "Physics",
                 explainer: "Quantum objects like electrons behave as waves (interfering with themselves) or as particles (landing at a point) depending on how they are observed.",
                 analogy: "Water that acts like ripples in a pool until you reach in to touch it — then it feels like a marble."),
    ConceptEntry(id: "cognitive_bias", title: "Confirmation Bias", field: "Psychology",
                 explainer: "People tend to seek, notice, and remember information that confirms what they already believe, while ignoring or dismissing contradicting evidence.",
                 analogy: "Reading only the pages in a history book that support your favourite theory and skimming past the rest."),
    ConceptEntry(id: "epigenetics", title: "Epigenetics", field: "Genetics",
                 explainer: "Gene expression can be switched on or off by chemical tags on DNA or its packaging proteins, without changing the underlying sequence. These changes can be influenced by environment and sometimes passed to offspring.",
                 analogy: "The DNA is a script; epigenetics is the director highlighting some lines and crossing out others for this particular performance."),
    ConceptEntry(id: "gravity_waves", title: "Gravitational Waves", field: "Astronomy",
                 explainer: "Massive accelerating objects (like merging black holes) stretch and squeeze spacetime itself, sending ripples outward at the speed of light that squeeze and stretch everything they pass through.",
                 analogy: "Dropping a stone in a cosmic pond — the ripples are not in water but in the fabric of space and time."),
    ConceptEntry(id: "antibiotics_resistance", title: "Antibiotic Resistance", field: "Biology",
                 explainer: "When antibiotics kill most bacteria in an infection, resistant mutants survive and reproduce. Repeated exposure selects for bacteria that are better at evading the drug.",
                 analogy: "Weed-killer that wipes out all but the hardiest weeds — the survivors seed a garden that the same killer can't touch."),
    ConceptEntry(id: "thermodynamics_2nd", title: "Second Law of Thermodynamics", field: "Physics",
                 explainer: "Total entropy in an isolated system always increases or stays the same. Heat flows naturally from hot to cold, never the reverse, without external work.",
                 analogy: "A cup of hot coffee in a cold room always cools down — you'll never see a cold cup spontaneously heat up."),
    ConceptEntry(id: "boolean_logic", title: "Boolean Logic", field: "Computer Science",
                 explainer: "All digital computing reduces to combinations of AND, OR, and NOT gates. These simple rules, applied billions of times per second, produce every computation.",
                 analogy: "Light switches wired in series (AND) or in parallel (OR) — your entire laptop is a very complicated arrangement of such switches."),
    ConceptEntry(id: "tectonic_rifting", title: "Continental Drift", field: "Earth Science",
                 explainer: "Over hundreds of millions of years, the continents have moved thousands of kilometres because the tectonic plates carrying them are driven by convection currents in the mantle.",
                 analogy: "Continents like crumbs on a very slowly boiling pot of porridge, drifting apart or colliding as the porridge bubbles."),
    ConceptEntry(id: "social_contract", title: "Social Contract", field: "Philosophy",
                 explainer: "Political authority is legitimate only if citizens have (implicitly) agreed to surrender some freedoms to a government in exchange for order and the protection of remaining rights.",
                 analogy: "A homeowners' association agreement — you give up painting your door purple in exchange for a well-kept street and a functional rubbish rota.")
]

// MARK: - AppModel

@MainActor
final class AppModel: ObservableObject {
    let container: ModelContainer
    weak var store: Store?

    @Published private(set) var todayConcept: Concept?
    @Published private(set) var allConcepts: [Concept] = []
    @Published private(set) var fieldProgressList: [FieldProgress] = []

    init(container: ModelContainer) {
        self.container = container
        reload()
    }

    static func makeContainer() -> ModelContainer {
        let schema = Schema([Concept.self, FieldProgress.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            let fallback = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            if let mc = try? ModelContainer(for: schema, configurations: [fallback]) {
                return mc
            }
            fatalError("Cannot create ModelContainer")
        }
    }

    func reload() {
        let ctx = container.mainContext
        // Seed concepts if none exist
        let existingFetch = FetchDescriptor<Concept>()
        let existing = (try? ctx.fetch(existingFetch)) ?? []

        if existing.isEmpty {
            let today = Calendar.current.startOfDay(for: Date())
            for (index, entry) in allConceptEntries.enumerated() {
                let unlock = Calendar.current.date(byAdding: .day, value: index, to: today) ?? today
                // Only unlock concepts up to and including today
                if unlock <= today {
                    let c = Concept(id: entry.id, title: entry.title, field: entry.field,
                                    explainer: entry.explainer, analogy: entry.analogy,
                                    dateUnlocked: unlock)
                    ctx.insert(c)
                }
            }
            try? ctx.save()
        }

        let descriptor = FetchDescriptor<Concept>(sortBy: [SortDescriptor(\.dateUnlocked, order: .reverse)])
        allConcepts = (try? ctx.fetch(descriptor)) ?? []

        // Today's concept = the one unlocked most recently on or before today
        let todayStart = Calendar.current.startOfDay(for: Date())
        todayConcept = allConcepts.first(where: { Calendar.current.startOfDay(for: $0.dateUnlocked) <= todayStart })

        // Build field progress
        let fpFetch = FetchDescriptor<FieldProgress>()
        fieldProgressList = (try? ctx.fetch(fpFetch)) ?? []

        // Ensure FieldProgress entries exist for all seen fields
        let knownFields = Set(allConcepts.map { $0.field })
        let existingFields = Set(fieldProgressList.map { $0.field })
        for field in knownFields where !existingFields.contains(field) {
            let fp = FieldProgress(field: field, conceptsSeen: allConcepts.filter { $0.field == field }.count)
            ctx.insert(fp)
        }
        try? ctx.save()
        fieldProgressList = (try? ctx.fetch(fpFetch)) ?? []
    }

    func refresh() {
        reload()
    }

    func markUnderstood(_ concept: Concept) {
        let ctx = container.mainContext
        concept.understood = true
        try? ctx.save()
        reload()
    }

    func deleteAllData() {
        let ctx = container.mainContext
        try? ctx.delete(model: Concept.self)
        try? ctx.delete(model: FieldProgress.self)
        try? ctx.save()
        allConcepts = []
        todayConcept = nil
        fieldProgressList = []
    }
}
