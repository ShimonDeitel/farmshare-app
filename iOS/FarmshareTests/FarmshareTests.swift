import XCTest
@testable import Farmshare

@MainActor
final class FarmshareTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
        store.items = []
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(FarmShare())
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let item = FarmShare()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testCanAddMoreWhenBelowLimit() {
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        store.isPro = false
        store.items = (0..<Store.freeLimit).map { _ in FarmShare() }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProRegardlessOfLimit() {
        store.isPro = true
        store.items = (0..<(Store.freeLimit + 5)).map { _ in FarmShare() }
        XCTAssertTrue(store.canAddMore)
    }

    func testFreeLimitAboveSeedDataCount() {
        XCTAssertGreaterThan(Store.freeLimit, Store.seedData.count)
    }

    func testUpdateModifiesExistingItem() {
        var item = FarmShare()
        store.add(item)
        item.farmName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.farmName, "Updated")
    }

    func testSaveAndLoadRoundTrip() {
        store.items = [FarmShare()]
        store.save()
        let reloaded = Store()
        XCTAssertFalse(reloaded.items.isEmpty)
    }
}
