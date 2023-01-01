import CryptoKit
import Foundation

public func encrypt(secret: String, with password: String) -> String? {
    guard let data = secret.data,
          let key = password.key,
          let encrypted = try? ChaChaPoly.seal(data, using: key).combined
    else { return nil }
    return encrypted.base64EncodedString()
}
public func decrypt(secret: String, with password: String) -> String? {
    guard let data = Data(base64Encoded: secret),
          let key = password.key,
          let box = try? ChaChaPoly.SealedBox(combined: data),
          let decrypted = try? ChaChaPoly.open(box, using: key)
    else { return nil }
    return String(data: decrypted, encoding: .utf8)
}
extension String {
    fileprivate var data: Data? {
        return data(using: .utf8)
    }
    fileprivate var key: SymmetricKey? {
        guard let data else { return nil }
        return SymmetricKey(data: SHA256.hash(data: data))
    }
}
