//
//  HomeVC.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 08/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import UIKit
import Alamofire

class HomeVC: UIViewController {

    let strArticleAPIURL = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=1&limit=10"
    let strArticleCellIdentifier = "articleCell"
    override func viewDidLoad(){
        super.viewDidLoad()
        
       fetchArticles()
    }


}


extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: strArticleCellIdentifier, for: indexPath) as! ArticleTableViewCell
        
        if indexPath.row == 1{
            cell.viewOfMediaFile.isHidden = true
            cell.viewOfTitle.isHidden = false
        }else if indexPath.row == 2{
            cell.viewOfTitle.isHidden = true
            cell.viewOfMediaFile.isHidden = false
        }else{
            cell.viewOfTitle.isHidden = false
            cell.viewOfMediaFile.isHidden = false
        }
        
        return cell
    }
    
    
    
}

extension HomeVC {
  func fetchArticles() {
    // 1 - Add API URL
    let request = AF.request(strArticleAPIURL)
    // 2 - Ask for response from server
    request.responseJSON { (data) in
      print(data)
    }
  }
}
