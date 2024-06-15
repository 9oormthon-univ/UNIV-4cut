import SwiftUI
import UIKit

struct AlertView: UIViewControllerRepresentable {
    var title: String
    var message: String
    var dismissButton: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // dummy view controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButton, style: .default, handler: nil))
        
        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: nil)
        }
    }
}
