import Cocoa


class PREF_Wireframe {
    var interactor: PREF_Interactor
	var presenter: PREF_Presenter
    var window: PREF_View

    init(config: Config_P) {
        interactor = PREF_Interactor()
        interactor.apiGateway = PREF_API_P()
        interactor.config = config

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
