class PREF_Interactor {
	var appModel: AppModel_P
	var apiGateway: PREF_API_P?
	var output: PREF_InteractorOutput?
	
	init(appModel:AppModel_P) {
		self.appModel = appModel
	}
}


extension PREF_Interactor: PREF_InteractorInput {
	func setSecretGists(isSecret: Bool) {
		//config?.secretGists = isSecret
		
		appModel.userDefaults[.secretGists] = isSecret
		
	}

	func setGistServiceIndex(index: Int) {
		appModel.activeGistServiceIndex = index
	}

	func setShortenServiceIndex(index: Int) {
		appModel.activeShortenServiceIndex = index
	}
}
