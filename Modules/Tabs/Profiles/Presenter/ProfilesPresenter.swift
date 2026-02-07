//
//  ProfilesPresenter.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 24/01/2026.
//

import Foundation

final class ProfilesPresenter: ProfilesPresenterProtocol {
    weak var view: ProfilesViewProtocol?
    let interactor: ProfilesInteractorProtocol
    let router: ProfilesRouterProtocol
    
    init(view: ProfilesViewProtocol,
         interactor: ProfilesInteractorProtocol,
         router: ProfilesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        let user = interactor.fetchUser()
        let menu = interactor.fetchMenuItems()
        
        view?.displayUser(user)
        view?.displayMenu(menu)
    }
    
    func didSelectMenuItem(_ item: ProfilesMenuItem) {
        router.navigate(to: item.type)
    }
}
