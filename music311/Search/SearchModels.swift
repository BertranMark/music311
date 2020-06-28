//
//  SearchModels.swift
//  music311
//
//  Created by Bertran on 05.05.2020.
//  Copyright (c) 2020 Bertran. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
       
        case getTracks(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
        
        case presentTracks(searchResponse: SearchResponse?)
        case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFooterView
        case displayTracks(searchViewModel: SearchViewmodel)
      }
    }
  }
  
}

struct SearchViewmodel {
    struct Cell: TrackCellViewModel {
       
        
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
