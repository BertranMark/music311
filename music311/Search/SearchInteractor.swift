//
//  SearchInteractor.swift
//  music311
//
//  Created by Bertran on 05.05.2020.
//  Copyright (c) 2020 Bertran. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

    var networkService = NetworkService()
    
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    switch request {
    
    case .getTracks(let searchTerm):
        print("interactor .getTracks")
        presenter?.presentData(response: .presentFooterView)
        networkService.fetchTracks(searchText: searchTerm) { [weak self] // предотваращем утечку памяти
            (searchResponse) in
            self?.presenter?.presentData(response: .presentTracks(searchResponse: searchResponse))
        }
        
   
    }
    
  }
    
    
  
}
