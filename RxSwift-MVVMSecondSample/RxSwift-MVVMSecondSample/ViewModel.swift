import Foundation
import RxCocoa
import RxSwift

class ViewModel {
	var users = BehaviorSubject(value: [UserModelDTO]())
	
	func fetchUsers() {
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let responseData = try JSONDecoder().decode([UserModelDTO].self, from: data)
					self.users.on(.next(responseData))
				} catch {
					print(error.localizedDescription )
				}
			}
		}
		task.resume()
	}
	
	func addUser(newUser: UserModelDTO) {
		guard var users = try? users.value() else { return }
		users.insert(newUser, at: 0)
		self.users.on(.next(users)) 
	}
	
	func deleteUser(index: Int) {
		guard var users = try? users.value() else { return }
		users.remove(at: index)
		self.users.on(.next(users))
	}
	
	func editUser(title: String, index: Int) {
		guard var users = try? users.value() else { return }
		users[index].title = title
		self.users.on(.next(users))
	}
}
