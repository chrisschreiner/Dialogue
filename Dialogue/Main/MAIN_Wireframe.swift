import Foundation


class MAIN_Wireframe {
    var interactor: MAIN_Interactor
    var presenter: MAIN_Presenter
    var view: MAIN_View
    var preferencesWireframe: PREF_Wireframe?

    init(config: Config_P) {
        interactor = MAIN_Interactor()
        interactor.pastebufferGateway = PastebufferAPI()
        interactor.apiGist = API_MAIN()

        presenter = MAIN_Presenter()

        view = MAIN_View()
        view.viewLifeCycle = presenter //TODO:Think through; could this be handled by the wireframe?
        view.eventHandler = presenter

        presenter.wireframe = self

        interactor.output = presenter
        interactor.config = config

        presenter.interactor = interactor
        presenter.view = view
    }

    func presentPreferences() {
        preferencesWireframe = PREF_Wireframe(config: interactor.config!)
        preferencesWireframe?.show()
    }
}