import Foundation

extension Task where Failure == Error {
    @discardableResult
    public static func delayed(by seconds: Double,
                        priority: TaskPriority? = nil,
                        operation: @escaping @Sendable () async throws -> Success) -> Task {
        Task(priority: priority) {
            let delay = UInt64(seconds * 1_000_000_000)
            try await Task<Never, Never>.sleep(nanoseconds: delay)
            return try await operation()
        }
    }
}
