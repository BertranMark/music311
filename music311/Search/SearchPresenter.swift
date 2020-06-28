//
//  SearchPresenter.swift
//  music311
//
//  Created by Bertran on 05.05.2020.
//  Copyright (c) 2020 Bertran. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
  
    switch response {
    case .presentFooterView:
        viewController?.displayData(viewModel: .displayFooterView)
    case .presentTracks(let searchResults):
        print("Presenter. PresentTracks")
        
        let cells = searchResults?.results.map({ (track) in
           
            cellViewModel(from: track)
        }) ?? []
        let searchViewModel = SearchViewmodel.init(cells: cells)
        viewController?.displayData(viewModel: .displayTracks(searchViewModel: searchViewModel))
    
    }
  }
    
    private func cellViewModel(from track: Track) -> SearchViewmodel.Cell {
        
        return SearchViewmodel.Cell.init(
            iconUrlString:  track.artworkUrl100,
            trackName:      track.trackName,
            collectionName: track.collectionName ?? "",
            artistName:     track.artistName,
            previewUrl:     track.previewUrl)
    }
  
}
