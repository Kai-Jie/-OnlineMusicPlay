//
//  SearchViewModel.swift
//  OnlineMusic
//
//  Created by Neo Hsu on 2022/6/24.
//

import Foundation

class SearchViewModel
{
    private let SearchAPI = "https://itunes.apple.com/search"
    
    //需注意同時讀寫問題
    var songs:[Song] = []
    
    func searchMusic(withKey searchKey:String, completion: @escaping (_ result:Bool) -> Void)
    {
        let searchStr:String = SearchAPI + "?term=" + searchKey + "&media=music&entity=song&limit=25"
        guard  let encodeURL = searchStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            completion(false)
            
            return
        }
        
        guard let searchURL = URL(string:encodeURL)
        else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: searchURL,completionHandler:{ [weak self] (data,response,error) in
                if error != nil {
                    completion(false)
                    
                    return
                }
                
                let response = response as! HTTPURLResponse
                
                if response.statusCode  == URLSession.HTTPStatusCode.Success.rawValue
                {
                    if let data = data {
                        self?.processData(data)
                        completion(true)
                        
                        return
                    }
                }
            
                completion(false)
            }
        )
        
        task.resume()
    }
    
    func processData(_ data:Data)
    {
        do
        {
            let decoder = JSONDecoder()
            let response = try decoder.decode(SearchResponse.self, from: data)
            
            songs.removeAll()
            response.results.forEach { result in
                let song = Song(trackId: result.trackId, artistName: result.artistName, trackCensoredName: result.trackCensoredName, previewUrl: result.previewUrl)
                songs.append(song)
            }
            
        }catch
        {
        }
    }
}
