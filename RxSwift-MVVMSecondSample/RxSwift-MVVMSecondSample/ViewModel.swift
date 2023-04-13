import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class ViewModel {
	var users = BehaviorSubject(value: [SectionModel(model: "", items: [UserModelDTO]())])
	
	func fetchUsers() {
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let responseData = try JSONDecoder().decode([UserModelDTO].self, from: data)
					let sectionUser = SectionModel(model: "First", items: [UserModelDTO(
						userID: 111,
						id: 222,
						title: "test",
						body: "test test")])
					let secondSection = SectionModel(model: "Second", items: responseData)
					self.users.on(.next([sectionUser, secondSection]))
				} catch {
					print(error.localizedDescription )
				}
			}
		}
		task.resume()
	}
	
	func addUser(newUser: UserModelDTO) {
		guard var sections = try? users.value() else { return }
		var currentSection = sections[0]
		currentSection.items.append(UserModelDTO(userID: 12, id: 23, title: "testADD", body: "testADD"))
		sections[0] = currentSection
		self.users.onNext(sections)
	}
	
	func deleteUser(indexPath: IndexPath) {
		guard var sections = try? users.value() else { return }
		var currentSection = sections[indexPath.section]
		currentSection.items.remove(at: indexPath.row)
		sections[indexPath.section] = currentSection
		self.users.onNext(sections)
	}
	
	func editUser(title: String, indexPath: IndexPath) {
		guard var sections = try? users.value() else { return }
		var currentSection = sections[indexPath.section]
		currentSection.items[indexPath.row].title = title
		sections[indexPath.section] = currentSection
		self.users.onNext(sections)
	}
}
