import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [FarmShare] = []
    @Published var isPro: Bool = false

    static let freeLimit = 8

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("farmshare_items.json")
    }()

    init() {
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: FarmShare) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: FarmShare) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: FarmShare) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([FarmShare].self, from: data) {
            items = decoded
        } else {
            items = Store.seedData
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static let seedData: [FarmShare] = [
        FarmShare(farmName: "Farmname 1", amountPaid: 10.0, pickupDate: Date().addingTimeInterval(-86400), notes: "Notes 1"),
        FarmShare(farmName: "Farmname 2", amountPaid: 20.0, pickupDate: Date().addingTimeInterval(-172800), notes: "Notes 2"),
        FarmShare(farmName: "Farmname 3", amountPaid: 30.0, pickupDate: Date().addingTimeInterval(-259200), notes: "Notes 3")
    ]
}
