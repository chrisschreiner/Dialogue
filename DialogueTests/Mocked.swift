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

//TODO: Generify this
class MockedPastebufferService: PB_Gateway {
	let _closure:() -> GistData
	func getContents() -> GistData {
		return _closure()
	}
	init( _closure:() -> GistData) {
		self._closure = _closure
	}
}



