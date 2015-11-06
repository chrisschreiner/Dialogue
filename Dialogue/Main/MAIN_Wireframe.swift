import Foundation


class MAIN_Wireframe {
	var interactor: MAIN_Interactor
	var presenter: MAIN_Presenter
	var view: MAIN_View
	var preferencesWireframe: PREF_Wireframe?

	func show() {
		view.showWindow(nil)
	}

	init(appModel: AppModel_P) {
		interactor = MAIN_Interactor()
		interactor.pastebufferGateway = PastebufferAPI()
		interactor.apiGist = API_MAIN()

		presenter = MAIN_Presenter()

		view = MAIN_View()
		view.viewLifeCycle = presenter //TODO:Think through; could this be handled by the wireframe?
		view.eventHandler = presenter

		presenter.wireframe = self

		interactor.output = presenter
		interactor.config = appModel

		presenter.interactor = interactor
		presenter.view = view

		show()
	}

	func presentPreferences() {
		preferencesWireframe = PREF_Wireframe(appModel: interactor.config!)
		preferencesWireframe?.show()
	}
}