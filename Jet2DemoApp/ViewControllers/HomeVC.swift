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
    var arrArticle:[ArticleViewModel] = []
    var currentPageIndexOfArticle = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        let arrArticles = fetchDataForEntity(entityName: .ArticleEntity) as! [ArticleModel]
        for article in arrArticles{
            self.arrArticle.append(ArticleViewModel.init(with: article))
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.arrArticle.count == 0{
            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            activityIndicator.startAnimating()
            
            tableView.backgroundView = activityIndicator
        }else{
            tableView.backgroundView = nil
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrArticle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: strArticleCellIdentifier, for: indexPath) as! ArticleTableViewCell
        let articleViewModalObj = self.arrArticle[indexPath.row]
        
        cell.articleCellDidSet(articleViewModalObj, cell)
        
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
                    for article in arrData{
                        self.arrArticle.append(ArticleViewModel.init(with:(article as! ArticleModel)))
                    }
                    self.shouldLoadMore = arrData.count == 0 ? false : true
                }
                
                self.showBottomRefreshController(willShowLoader: false)
                self.tableView.reloadData()
            }
            
        }
    }
}
