







import UIKit

class SplashVC: UIViewController {
    // MARK: - Properties
    private let splashView = SplashView()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToLoginScreen()
    }

    // MARK: - Navigation
    private func navigateToLoginScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            let loginVC = LoginVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            self?.present(loginVC, animated: true, completion: nil)
        }
    }
}
