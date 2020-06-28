//
//  SearchViewController.swift
//  music311
//
//  Created by Bertran on 05.05.2020.
//  Copyright (c) 2020 Bertran. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    let searchC = UISearchController(searchResultsController: nil)

    private var searchViewModel = SearchViewmodel.init(cells: [])
    private var timer: Timer?
    @IBOutlet weak var table: UITableView!
    
 
    private lazy var footerView = FooterView()
    
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setuptableView()
    setupSearchBar()
    searchBar(searchC.searchBar, textDidChange: "Taylor")
  }
  
    private func setupSearchBar() {
      navigationItem.searchController = searchC
        navigationItem.hidesSearchBarWhenScrolling = false
        searchC.obscuresBackgroundDuringPresentation = false
        searchC.searchBar.delegate = self
    }
    
    private func setuptableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        let nib = UINib(nibName: "TrackCell", bundle:  nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseID)
        table.tableFooterView = footerView
    }
    
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
  
    case .displayTracks(let searchViewModel):
        self.searchViewModel = searchViewModel
        table.reloadData()
        print("View controller .displaTracks")
        footerView.hideLoader()
    case .displayFooterView:
        footerView.showLoader()
    }
  }
  
}

// MARK: TableViewDelegate, TableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseID, for: indexPath) as! TrackCell
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)

    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Введите название песни или трека"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  searchViewModel.cells.count > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        let window = UIApplication.shared.keyWindow
        let trackDetailView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as! TrackDetailView
        trackDetailView.set(viewModel: cellViewModel)
        window?.addSubview(trackDetailView)
    }
    
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print(searchText)
        
        timer?.invalidate()
//          guard searchText.count > 2 else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
        })
      
        
    }
}
