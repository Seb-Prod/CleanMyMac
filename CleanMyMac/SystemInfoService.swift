
import Foundation

struct SystemSnapshot {

    let totalStorage: Int64
    let availableStorage: Int64
    let usedStorage: Int64
    let totalMemory: UInt64

    var storageUsage: Double {
        guard totalStorage > 0 else { return 0 }

        return Double(usedStorage) / Double(totalStorage)
    }

    var formattedTotalStorage: String {
        ByteCountFormatter.string(
            fromByteCount: totalStorage,
            countStyle: .file
        )
    }

    var formattedAvailableStorage: String {
        ByteCountFormatter.string(
            fromByteCount: availableStorage,
            countStyle: .file
        )
    }

    var formattedUsedStorage: String {
        ByteCountFormatter.string(
            fromByteCount: usedStorage,
            countStyle: .file
        )
    }

    var formattedMemory: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(clamping: totalMemory),
            countStyle: .memory
        )
    }
}

struct SystemInfoService {

    func getSnapshot() -> SystemSnapshot {

        let diskURL = URL(fileURLWithPath: "/")

        let values = try? diskURL.resourceValues(
            forKeys: [
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityKey
            ]
        )

        let total = Int64(
            values?.volumeTotalCapacity ?? 0
        )

        let available = Int64(
            values?.volumeAvailableCapacity ?? 0
        )

        let used = max(0, total - available)

        return SystemSnapshot(
            totalStorage: total,
            availableStorage: available,
            usedStorage: used,
            totalMemory: ProcessInfo.processInfo.physicalMemory
        )
    }
}


