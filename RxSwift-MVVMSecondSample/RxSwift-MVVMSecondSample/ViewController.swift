import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UIScrollViewDelegate {
	
	private var viewModel = ViewModel()
	private var bag = DisposeBag()
	lazy private var tableView: UITableView  = {
		let tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
		tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		viewModel.fetchUsers()
		bindTableView()
	}
	
	private func setupViews() {
		title = "Users"
		addBarButtonItem()
		view.addSubview(tableView)
	}
	
	private func addBarButtonItem() {
		let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addBarButtonPressed))
		self.navigationItem.rightBarButtonItem = addButton
	}
	
	private func showAlert(indexPath: Int) {
		let alert = UIAlertController(title: "Note", message: "Edit Note", preferredStyle: .alert)
		alert.addTextField { textField in
		}
		alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
			let textField = alert.textFields![0] as UITextField
			self.viewModel.editUser(title: textField.text!, index: indexPath)
		}))
		DispatchQueue.main.async {
			self.present(alert, animated: true)
		}
	}
	
	private func bindTableView() {
		tableView.rx.setDelegate(self).disposed(by: bag)
		viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row, item, cell) in
			cell.textLabel?.text = item.title
			cell.detailTextLabel?.text = "\(item.id)"
		}.disposed(by: bag)
		
		tableView.rx.itemSelected.subscribe { indexPath in
			self.showAlert(indexPath: indexPath.row)
		}.disposed(by: bag)
		
		tableView.rx.itemDeleted.subscribe { [weak self] indexPath in
			guard let self = self else { return }
			self.viewModel.deleteUser(index: indexPath.row)
		}.disposed(by: bag)
	}
	
	@objc private func addBarButtonPressed() {
		let user = UserModelDTO(userID: 12, id: 23, title: "test test", body: "test test test")
		self.viewModel.addUser(newUser: user)
	}
}

