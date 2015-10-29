class Interactor_PREFERENCES {
    var localDatamanager: LocalDatamanager_P?
    var apiDatamanager: APIDataManager_PREFERENCES?
    var output: InteractorOutput_PREFERENCES?

}


extension Interactor_PREFERENCES: InteractorInput_PREFERENCES {
    func setInitialValues() {
        precondition(localDatamanager != nil)
        precondition(output != nil)

        output?.populateGistsServicePopupMenu(GistService.popupMenuList())
        output?.populateShortenServicePopupMenu(ShortenService.popupMenuList())
        output?.setActiveGistService(localDatamanager?.activeGistService ?? 0)
        output?.setActiveShortenService(localDatamanager?.activeShortenService ?? 0)
        output?.setUseSecretGists(localDatamanager?.secretGists ?? true)
    }

    func setSecretGists(isSecret: Bool) {
        localDatamanager?.secretGists = isSecret
    }

    func setGistServiceIndex(index: Int) {
        localDatamanager?.activeGistService = index
    }

    func setShortenServiceIndex(index: Int) {
        localDatamanager?.activeShortenService = index
    }
}


class APIDataManager_PREFERENCES {
    // Use this class when calling external API, like web-services
    // Doesn't seem to be much to do here for Preferences
}