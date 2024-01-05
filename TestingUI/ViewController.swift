import UIKit

class YourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        CoreDataManager.shared.fetchPhotos()
    }
}
