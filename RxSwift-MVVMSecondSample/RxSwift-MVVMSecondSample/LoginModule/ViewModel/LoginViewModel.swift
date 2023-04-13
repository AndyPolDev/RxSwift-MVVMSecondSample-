import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
	var email: BehaviorSubject<String> = BehaviorSubject(value: "")
	var password: BehaviorSubject<String> = BehaviorSubject(value: "")
	
	var isValidEmail: Observable<Bool> {
		email.map {$0.isValidEmail()}
	}
	
	var isValidPassword: Observable<Bool> {
		password.map { password in
			return password.count < 6 ? false : true
		}
	}
	
	var isValidInput: Observable<Bool> {
		return Observable.combineLatest(isValidEmail, isValidPassword).map {$0 && $1}
	}
	
}
