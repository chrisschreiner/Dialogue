class PREF_Interactor {
	var config: Config_P?
	var apiGateway: PREF_API_P?
	var output: PREF_InteractorOutput?
}


extension PREF_Interactor: PREF_InteractorInput {
	func setSecretGists(isSecret: Bool) {
		config?.secretGists = isSecret
	}

	func setGistServiceIndex(index: Int) {
		config?.activeGistServiceIndex = index
	}

	func setShortenServiceIndex(index: Int) {
		config?.activeShortenServiceIndex = index
	}
}
