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

    override func viewDidLoad(){
        super.viewDidLoad()
        
       fetchArticles()
    }


}

extension HomeVC {
  func fetchArticles() {
    // 1 - Add API URL
    let request = AF.request("https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=1&limit=10")
    // 2 - Ask for response from server
    request.responseJSON { (data) in
      print(data)
    }
  }
}
