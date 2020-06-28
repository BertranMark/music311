//
//  NetworkService.swift
//  music311
//
//  Created by Bertran on 25.04.2020.
//  Copyright © 2020 Bertran. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService
{
    func fetchTracks(searchText: String, complition: @escaping (SearchResponse?) -> Void)
    {                                   // смотри комент ниже
        let url = "https://itunes.apple.com/search"
        let paramets = [
            "term"  : "\(searchText)",
            "limit" : "10",
            "media" : "music"
        ]
        AF.request(
            url,
            method:     .get,
            parameters: paramets,
            encoding:   URLEncoding.default,
            headers:    nil, interceptor: nil, requestModifier: nil
        ).responseData
            { (dataResponse) in
                // результаты запроса приходят асинхронно, то есть в другом потоке, из синхронного потока его уже вынесла библиотека Аламофаер, чтобы загрузка не стопорила интерфейс. Поэтому приходят не сразу, в связи с этим их использование вынесено в убегающую функцию - в этом блоке кода обработка результатов произойдет тогда, когда они будут получены. В этом смысл организовывать обработку результа убегующей функцией. Описывается функция, то есть, что именно нужно сделать с резульатом - в другом модуле, в классе SearchViewController, в котором описывается работа окна поиска треков (после применения архитектуры КлинСвифт - в классе интерактор)
                
                if let error = dataResponse.error
                {
                    print("Ошибка \(error.localizedDescription)")
                    complition(nil)
                }
                
                guard let data = dataResponse.data else {return }
                
                let decoder = JSONDecoder()
                do
                {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                   
                    complition(objects)
                    
                } catch let jsonError
                {
                    print("Ошибка JSON ", jsonError)
                    complition(nil)
                }
                
        }
    }
    
}
