import Foundation

struct FarmShare: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var farmName: String
    var amountPaid: Double
    var pickupDate: Date
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), farmName: String = "", amountPaid: Double = 0, pickupDate: Date = Date(), notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.farmName = farmName
        self.amountPaid = amountPaid
        self.pickupDate = pickupDate
        self.notes = notes
    }
}
