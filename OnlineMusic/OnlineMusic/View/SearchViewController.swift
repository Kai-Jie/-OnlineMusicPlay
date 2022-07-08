//
//  SearchViewController.swift
//  OnlineMusic
//
//  Created by Neo Hsu on 2022/6/24.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController ,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var musicPlayer:AVPlayer?
    let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        
        guard let searchKey = self.searchBar.text
        else { return }
        
        if searchKey.isEmpty { return }
        
        self.showMessage("Searching")
        self.searchViewModel.searchMusic(withKey:searchKey, completion: { result in
            DispatchQueue.main.async {
                if result == true
                {
                    self.hideMessage()
                    self.resultsTableView.reloadData()
                }else
                {
                    self.showMessage("No Data")
                }
            }
        })
        
    }
    
    func showMessage(_ message:String)
    {
        self.messageLabel.isHidden = false
        self.messageLabel.text = message
    }
    
    func hideMessage()
    {
        self.messageLabel.isHidden = true
        self.messageLabel.text = ""
    }
    
// MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let musicCell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        guard let previewURL = URL(string:musicCell.previewURL)
        else { return }
          
        musicPlayer = AVPlayer(url: previewURL)
        musicPlayer?.play()
    }
    
// MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.resultsTableView.dequeueReusableCell(withIdentifier: "SongCell", for:indexPath) as! SearchTableViewCell
        
        let song = searchViewModel.songs[indexPath.row]
        
        cell.trackID = song.trackId
        cell.previewURL = song.previewUrl
        
        cell.textLabel?.text = "\(song.trackCensoredName)"
        cell.detailTextLabel?.text = "\(song.artistName)"
        
        return cell
    }

}

