import Foundation


class Wireframe_MAIN {
    var interactor: Interactor_MAIN
    var presenter: Presenter_MAIN?
    var view: View_MAIN?
    var preferencesWireframe: Wireframe_PREFERENCES?

    init(config: Config_P) {
        interactor = Interactor_MAIN()
        interactor.pastebufferGateway = PastebufferAPI()
        interactor.apiDatamanager = API_MAIN()

        presenter = Presenter_MAIN()
        presenter?.wireframe = self
        view = View_MAIN()
        view?.viewLifeCycle = presenter //TODO:Think through; could this be handled by the wireframe?
        view?.eventHandler = presenter

        interactor.output = presenter //no functions yet
        interactor.config = config

        presenter?.interactor = interactor
        presenter?.view = view
    }

    func presentPreferences() {
        preferencesWireframe = Wireframe_PREFERENCES(config: interactor.config!)
        preferencesWireframe?.show()
    }
}