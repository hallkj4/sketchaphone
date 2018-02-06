import UIKit

class LoadingViewController: UIViewController {
    var loading = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.activityIndicatorViewStyle = .gray
        loading.frame = view.frame
        loading.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        loading.center = view.center
        loading.hidesWhenStopped = true
        view.addSubview(loading)
    }
    
    func startLoading() {
        loading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoading () {
        loading.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
