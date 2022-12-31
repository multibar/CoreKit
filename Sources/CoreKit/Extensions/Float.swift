import CoreGraphics

extension CGFloat {
    public var safe: CGFloat {
        guard isNaN || isInfinite else { return self }
        return .zero
    }
}
