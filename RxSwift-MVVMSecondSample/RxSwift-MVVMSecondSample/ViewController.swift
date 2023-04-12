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
		view.addSubview(tableView)
	}
	
	private func bindTableView() {
		tableView.rx.setDelegate(self).disposed(by: bag)
		viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row, item, cell) in
			cell.textLabel?.text = item.title
			cell.detailTextLabel?.text = "\(item.id)"
			
			
		}.disposed(by: bag)
	}
}

