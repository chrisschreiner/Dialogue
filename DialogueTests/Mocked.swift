//
//  Mocked.swift
//  Dialogue
//

import Foundation


class MockedPresenter: InteractorOutput_MAIN {
	let _closure: () -> NSURL
	func giveMeTheURL() -> NSURL {
		return _closure()
	}
	init( _closure:() -> NSURL) {
		self._closure = _closure
	}
}





