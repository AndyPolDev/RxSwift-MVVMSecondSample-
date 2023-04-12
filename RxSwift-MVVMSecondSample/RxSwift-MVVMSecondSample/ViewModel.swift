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
}
