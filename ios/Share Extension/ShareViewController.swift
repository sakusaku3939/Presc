import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    let hostAppBundleIdentifier = "com.sakusaku3939.presc"
    let sharedKey = "ShareKey2"
    var sharedText: [String] = []
    let textContentType = kUTTypeText as String

    override func isContentValid() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad();
    }

    override func didSelectPost() {
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            if let contents = content.attachments {
                for (index, attachment) in (contents).enumerated() {
                    if attachment.hasItemConformingToTypeIdentifier(textContentType) {
                        handleText(content: content, attachment: attachment, index: index)
                    } else {
                        let msg = "Not found intent handler for " + attachment.registeredTypeIdentifiers.description
                        self.dismissWithError(message: msg)
                    }
                }
            }
        }
        super.didSelectPost();
    }

    private func handleText(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? String, let this = self {
                this.sharedText.append(item)
                if index == (content.attachments?.count)! - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    this.redirectToHostApp(type: .text)
                }
            } else {
                self?.dismissWithError()
            }
        }
    }
    
    private func dismissWithError(message: String = "Error loading data") {
        print("[ERROR] \(message)")
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func redirectToHostApp(type: RedirectType) {
        let url = URL(string: "ShareMedia://dataUrl=\(sharedKey)#\(type)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
    }
    enum RedirectType {
        case media
        case text
        case file
    }
}
