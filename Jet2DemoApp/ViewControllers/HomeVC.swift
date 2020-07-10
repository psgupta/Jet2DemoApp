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
   
    var shouldLoadMore = true
    var arrArticle:[ArticleModel] = []
    var currentPageIndexOfArticle = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let arrArticles = fetchDataForEntity(entityName: .ArticleEntity)
        self.arrArticle = arrArticles as! [ArticleModel]
        fetchArticles(for: currentPageIndexOfArticle)
    }
    
    
    //MARK: LOAD MORE
        func showBottomRefreshController(willShowLoader:Bool)  {
            
            if willShowLoader{
                addFooterViewToRefreshTable()
            }else{
                removeFooteViewFromTableView()
            }
        }
        
        func addFooterViewToRefreshTable(){
            let refresh = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
            refresh.startAnimating()
            self.tableView.tableFooterView = refresh
        }
        
        func removeFooteViewFromTableView(){
            self.tableView.tableFooterView = nil
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if scrollView.tag == kTAG_TABLEVIEW && self.arrArticle.count>=kMAXPAGELIMIT {
                // UITableView only moves in one direction, y axis
                let currentOffset = scrollView.contentOffset.y
                let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
                
                // Change 10.0 to adjust the distance from bottom
                if maximumOffset - currentOffset <= 10.0 && shouldLoadMore{
                    currentPageIndexOfArticle+=1
                    shouldLoadMore = false
                    self.fetchArticles(for: currentPageIndexOfArticle)
                }
            }
        }

}




//MARK: Display
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrArticle.count
    }
    
    fileprivate func displayNumber(_ number: Float, _ strNumberToDisplay: inout String, _ articleObj: ArticleModel) {
        if number>1000{
            let roundOffValue = String(format: "%.1f", number/1000)
            strNumberToDisplay = "\(roundOffValue)K"
        }else{
            strNumberToDisplay = articleObj.likes
        }
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
        
        var likesToDisplay = ""
        let likes =  Float(articleObj.likes) ?? 0
        displayNumber(likes, &likesToDisplay, articleObj)
        cell.btnLikes.setTitle(likesToDisplay+" Likes", for: .normal)
        
        var commentsToDisplay = ""
        let comments =  Float(articleObj.comments) ?? 0
        displayNumber(comments, &commentsToDisplay, articleObj)
        cell.btnComments.setTitle(commentsToDisplay+" Comments", for: .normal)
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: Fetch
extension HomeVC {
    func fetchArticles(for pageNumber:Int) {

        if pageNumber > 1{
            showBottomRefreshController(willShowLoader: true)
        }
        
        
        let strArticleAPIURL = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=\(pageNumber)&limit=\(kMAXPAGELIMIT)"
        // 1 - Add API URL
        let request = AF.request(strArticleAPIURL)
        // 2 - Ask for response from server
        request.responseJSON { (data) in
            let arrResponse = (data.value) as! [[String:Any]]
            saveJSONObjectToCoreDataForEntity(entityName: .ArticleEntity, arrData: arrResponse) { (isSaved, arrData) in
                if pageNumber == 1{
                    self.arrArticle.removeAll()
                }
                
                if let arrData = arrData{
                    self.arrArticle.append(contentsOf: (arrData as! [ArticleModel]))
                    self.shouldLoadMore = arrData.count == 0 ? false : true
                }
                
                self.showBottomRefreshController(willShowLoader: false)

                self.tableView.reloadData()
            }
            
        }
    }
}
