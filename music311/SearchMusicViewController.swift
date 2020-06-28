//
//  SearchViewController.swift
//  music311
//
//  Created by Bertran on 20.04.2020.
//  Copyright © 2020 Bertran. All rights reserved.
//

import UIKit
import Alamofire


class SearchMusicViewController: UITableViewController {
    
    private var timer : Timer?
    
    var networkService = NetworkService()
    
    var tracks = [
        Track
    ] ()
    
    let searchC = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        setupSearchBar()
        
        
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchC
        navigationItem.hidesSearchBarWhenScrolling = false
        searchC.searchBar.delegate = self
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    private func imagefrompath(trackimagepath: String?) -> UIImage?
    {
        guard let imageurl = trackimagepath else { return nil }
        do
        {
            let data = try Data(contentsOf: URL(fileURLWithPath: imageurl))
            return UIImage(data: data)
        } catch {
            print("изображение не создано")
            return nil
        } // функция не работает. Неправильно получаю изображение из интернета. Разберусь позже, или дождусь объяснения в видеоуроке
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        
        if let image = imagefrompath(trackimagepath: track.artworkUrl100)
        {
            cell.imageView?.image = image
        } else
        {
            cell.imageView?.image = #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon")
        }
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        return cell
        
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
        guard searchText.count > 2 else { return }
        
        
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block:
        { (_) in
            self.networkService.fetchTracks(searchText: searchText)
            { [weak self] (searchResults) in
                // слабая связь с текущим классом, чтобы не засорять память (не создавать утечку памяти). Эти данные будут накапливаться в функции фетчТрэкс, точнее в ее экземплярах, вызываемых при каждом изменении текста поисковой строки. В таких случаях, когда мы обращаемся к текущим объектам трэкс и тэйблвью в блоке кода другого класса, путем передачи обращения к текущему блоку кода из него.
                // проще: объект networkService (класс NetworkService) имеел сильную связь с классом SearchViewController, так как объявлен в нем (в текущем классе), но и класс SearchViewController в виде своего объекта tracks имеел сильную ссылку на класс NetworkService, путем обращения к его методу
                // слабость связи означает : ссылка на экземпляр класса может быть заменена на нил в случае уничтожения экземпляра класса, в котором она создается
                // еще проще: когда свойства классов вызывают взаимно другие классы, происходит цепь связи и свифт не может освободить память, когда область видимости экземпляров классов заканчивается. В нашем случае это приведет к постоянному росту цепей связи
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
            
        })
        
        
    }
    
    
}
