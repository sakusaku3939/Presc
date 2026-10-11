import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    private let hostAppBundleIdentifier = "com.sakusaku3939.presc"

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        let providers = (extensionContext?.inputItems as? [NSExtensionItem] ?? [])
            .flatMap { $0.attachments ?? [] }
            .filter { $0.hasItemConformingToTypeIdentifier(UTType.text.identifier) }
        guard !providers.isEmpty else {
            dismissWithError(message: "No text was shared.")
            return
        }

        let group = DispatchGroup()
        var texts = [Int: String]()
        var loadError: Error?
        for (index, provider) in providers.enumerated() {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { item, error in
                DispatchQueue.main.async {
                    if let text = item as? String {
                        texts[index] = text
                    } else if let error = error {
                        loadError = error
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard loadError == nil, texts.count == providers.count else {
                self.dismissWithError(message: loadError?.localizedDescription ?? "Could not read shared text.")
                return
            }
            let text = texts.keys.sorted().compactMap { texts[$0] }.joined(separator: "\n")
            let sharedFiles: [[String: Any]] = [["value": text, "type": 0, "mimeType": "text/plain"]]
            do {
                let data = try JSONSerialization.data(withJSONObject: sharedFiles)
                guard let defaults = UserDefaults(suiteName: "group.\(self.hostAppBundleIdentifier)") else {
                    self.dismissWithError(message: "Could not access the shared app group.")
                    return
                }
                defaults.set(data, forKey: "SharingKey")
                defaults.removeObject(forKey: "SharingMessageKey")
                defaults.synchronize()
                self.redirectToHostApp()
            } catch {
                self.dismissWithError(message: error.localizedDescription)
            }
        }
    }

    private func redirectToHostApp() {
        guard let url = URL(string: "SharingMedia-\(hostAppBundleIdentifier)://share") else { return }
        var responder: UIResponder? = self
        let selector = NSSelectorFromString("openURL:")
        while let current = responder {
            if current.responds(to: selector) {
                _ = current.perform(selector, with: url)
                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                return
            }
            responder = current.next
        }
        dismissWithError(message: "Could not open Presc.")
    }

    private func dismissWithError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        })
        present(alert, animated: true)
    }
}
