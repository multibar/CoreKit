import Foundation

extension String {
    public var url: URL? {
        var url = self
        if !hasPrefix("http") && !hasPrefix("https") && range(of: "://") == nil {
            url = "https://\(url)"
        }
        return URL(string: url)
    }
}
extension Optional where Wrapped == String {
    public var url: URL? {
        guard let string = self else { return nil }
        return string.url
    }
}
extension URL {
    public var string: String {
        return absoluteString
    }
    public var valid: Bool {
        let url = string
        let schemes = ["http": true, "https": true]
        if let escaped = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: escaped), let scheme = url.scheme, let requiresTopLevelDomain = schemes[scheme], let host = url.host, (!requiresTopLevelDomain || host.contains(".")) && url.user == nil {
            if requiresTopLevelDomain {
                let components = host.components(separatedBy: ".")
                let domain = (components.first ?? "")
                if domain.empty {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}
