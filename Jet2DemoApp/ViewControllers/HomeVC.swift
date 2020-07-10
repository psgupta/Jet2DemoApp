//
//  HomeVC.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 08/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class HomeVC: UIViewController {
   
    var shouldLoadMore = false
    var arrArticle:[ArticleModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let arrArticles = fetchDataForEntity(entityName: .ArticleEntity)
        self.arrArticle = arrArticles as! [ArticleModel]
        fetchArticles()
    }
    
}




//MARK: Display
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: strArticleCellIdentifier, for: indexPath) as! ArticleTableViewCell
        let articleObj = self.arrArticle[indexPath.row]
        
        cell.viewOfMediaFile.isHidden = articleObj.mediaObject.image == "" ? true : false
        
        if let url = URL(string: articleObj.mediaObject.image){
            cell.imgViewArticle?.sd_setImage(with: url, completed: nil)
        }
        
        if let urlAvatar = URL(string: articleObj.userObject.avatar){
            cell.imgViewUser?.sd_setImage(with: urlAvatar, completed: nil)
        }
        
        
        cell.lblUserName.text = articleObj.userObject.name+" "+articleObj.userObject.lastname
        cell.lblUserDesignation.text = articleObj.userObject.designation
        cell.txtViewTitle.text = articleObj.content
        cell.btnLikes.setTitle(articleObj.likes+" Likes", for: .normal)
        cell.btnComments.setTitle(articleObj.comments+" Comments", for: .normal)
        return cell
    }
    
    
    
}


//MARK: Fetch
extension HomeVC {
    func fetchArticles() {
        // 1 - Add API URL
        let request = AF.request(strArticleAPIURL)
        // 2 - Ask for response from server
        request.responseJSON { (data) in
            //        print(data)
            let arrResponse = (data.value) as! [[String:Any]]
            saveJSONObjectToCoreDataForEntity(entityName: .ArticleEntity, arrData: arrResponse) { (isSaved, arrData) in
                //            print(arrData as Any)
                self.arrArticle = arrData as! [ArticleModel]
                self.tableView.reloadData()
            }
            
        }
    }
}
