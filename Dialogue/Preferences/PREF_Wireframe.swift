import Cocoa


class PREF_Wireframe {
    var interactor: PREF_Interactor
	var presenter: PREF_Presenter
    var window: PREF_View

    init(appModel: AppModel_P) {
		interactor = PREF_Interactor(appModel:appModel)
        interactor.apiGateway = PREF_API_P()
		
        window = PREF_View()

        presenter = PREF_Presenter()
        interactor.output = presenter
        presenter.view = window
        presenter.interactor = interactor
        window.eventHandler = presenter
        window.viewLifeCycle = presenter
    }

    func show() {
        //TODO:setup window with default values
        //TODO:find a place to do this

        window.showWindow(nil)
    }
}
