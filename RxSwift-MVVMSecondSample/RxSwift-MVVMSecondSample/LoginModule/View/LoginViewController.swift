import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
	
	lazy private var textFieldEmail: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Email"
		textField.borderStyle = .roundedRect
		textField.keyboardType = .emailAddress
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	lazy private var textFieldPassword: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Password"
		textField.borderStyle = .roundedRect
		textField.isSecureTextEntry = true
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	lazy private var loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Login", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
		button.backgroundColor = .red
		button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	var bag = DisposeBag()
	private let viewModel = LoginViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setConstraints()
		createObservables()
	}
	
	
	@objc private func loginButtonPressed() {
		
	}
	
	private func setupViews() {
		title = "Login"
		view.backgroundColor = .white
		view.addSubview(textFieldEmail)
		view.addSubview(textFieldPassword)
		view.addSubview(loginButton)
	}
	
	private func createObservables() {
		textFieldEmail.rx.text.map {$0 ?? ""}.bind(to: viewModel.email).disposed(by: bag)
		textFieldPassword.rx.text.map {$0 ?? ""}.bind(to: viewModel.password).disposed(by: bag)
		
		viewModel.isValidInput.bind(to: loginButton.rx.isEnabled).disposed(by: bag)
		viewModel.isValidInput.subscribe { [weak self] isValid in
			self?.loginButton.backgroundColor = isValid ? .systemGreen : .red
		}.disposed(by: bag)
	}
}

extension LoginViewController {
	private func setConstraints() {
		NSLayoutConstraint.activate([
			textFieldEmail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			textFieldEmail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			textFieldEmail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
		])
		
		NSLayoutConstraint.activate([
			textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 20),
			textFieldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			textFieldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
		])
		
		NSLayoutConstraint.activate([
			loginButton.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 20),
			loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
		])
	}
}
