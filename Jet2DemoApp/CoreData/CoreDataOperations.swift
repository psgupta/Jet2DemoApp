//
//  CoreDataOperations.swift
//  Jet2DemoApp
//
//  Created by Prasanna Gupta on 09/07/20.
//  Copyright © 2020 Prasanna Gupta. All rights reserved.


import Foundation
import CoreData


typealias CoreDataOperationsCompletion = (_ isSavedSuccess:Bool,_ arrSavedData:[Any]?) ->Void
private var completionBlockCoreData:CoreDataOperationsCompletion?



//MARK: Set Up Core Data
fileprivate var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: "Jet2DemoApp", withExtension: "momd") else {
        fatalError("Unable to Find Data Model")
    }
    
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Unable to Load Data Model")
    }
    
    return managedObjectModel
}()

fileprivate var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let documentsPathURL = URL(fileURLWithPath: documentsPath)
    let strDBFileName = "Jet2DemoApp.sqlite"
    let url = documentsPathURL.appendingPathComponent(strDBFileName)
    let options = [NSMigratePersistentStoresAutomaticallyOption : true,NSInferMappingModelAutomaticallyOption : true]
    do {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
    } catch {
        print("<<<Catch exception>>>")
    }
    
    return coordinator
}()



fileprivate var managedObjectContext: NSManagedObjectContext = {
    let coordinator = persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
}()


//MARK: Process Core Data Save
fileprivate func saveArticleToCoreData(_ arrArticle: [[String:Any]],entity:NSEntityDescription,managedContext:NSManagedObjectContext) {
    for articleObj in arrArticle {
        let article = Article(entity: entity, insertInto: managedContext)
        article.setValue(articleObj["id"], forKey: "articleId")
        article.setValue((articleObj["comments"] as! NSNumber).stringValue, forKey: "comments")
        article.setValue(articleObj["content"], forKey: "content")
        article.setValue((articleObj["likes"] as! NSNumber).stringValue, forKey: "likes")
        article.setValue(articleObj["createdAt"], forKey: "createdAt")
        
        let arrMedia = articleObj["media"] as! [[String:Any]]
        let managedObjectMedia = getMediaFileManagedObject(arrMedia, managedContext: managedContext)
        article.setValue(managedObjectMedia.first, forKey: "articleMedia")
        
        
        let arrUser = articleObj["user"] as! [[String:Any]]
        let managedObjectUser = getUserManagedObject(arrUser, managedContext: managedContext)
        article.setValue(managedObjectUser.first, forKey: "articleUser")
    }
    
    //Now we have set all the values. The next step is to save them inside the Core Data
    do {
        try managedContext.save()
        let arrArticles = fetchDataForEntity(entityName: .ArticleEntity)
        if let block = completionBlockCoreData{ block(true,arrArticles) }
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
        if let block = completionBlockCoreData{ block(false,nil) }

    }
}


fileprivate func getMediaFileManagedObject(_ arrMedia: [[String:Any]],
                                     managedContext:NSManagedObjectContext)->[Media] {
    var arrManagedObject:[Media] = []
    for mediaObj in arrMedia {
        let entityMediaObj = NSEntityDescription.entity(forEntityName: EntityTitle.MediaEntity.rawValue, in: managedContext)!

        let media = Media(entity: entityMediaObj, insertInto: managedContext)
        media.setValue(mediaObj["title"], forKey: "title")
        media.setValue(mediaObj["createdAt"], forKey: "createdAt")
        media.setValue(mediaObj["id"], forKey: "mediaId")
        media.setValue(mediaObj["blogId"], forKey: "blogId")
        media.setValue(mediaObj["image"], forKey: "image")
        media.setValue(mediaObj["url"], forKey: "url")
        arrManagedObject.append(media)
    }
    
    return arrManagedObject
}


fileprivate func getUserManagedObject(_ arrUsers: [[String:Any]],
                                    managedContext:NSManagedObjectContext)->[User]  {
    var arrManagedObject:[User] = []

    for userObj in arrUsers {
        let entityUserObj = NSEntityDescription.entity(forEntityName: EntityTitle.UserEntity.rawValue, in: managedContext)!

        let user = User(entity: entityUserObj, insertInto: managedContext)
        user.setValue(userObj["id"], forKey: "userId")
        user.setValue(userObj["name"], forKey: "name")
        user.setValue(userObj["about"], forKey: "about")
        user.setValue(userObj["avatar"], forKey: "avatar")
        user.setValue(userObj["blogId"], forKey: "blogId")
        user.setValue(userObj["city"], forKey: "city")
        user.setValue(userObj["designation"], forKey: "designation")
        user.setValue(userObj["createdAt"], forKey: "createdAt")
        user.setValue(userObj["lastname"], forKey: "lastname")
        arrManagedObject.append(user)
    }
  
    return arrManagedObject
}


//MARK: SAVE
func saveJSONObjectToCoreDataForEntity(entityName:EntityTitle,arrData:[[String:Any]],completion:CoreDataOperationsCompletion?){
    if arrData.count==0{return}
    completionBlockCoreData = completion

    let entityObj = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: managedObjectContext)!
    
    switch entityName {
    case .ArticleEntity:
        clearCoreDataStoreForEntityName(EntityTitle.ArticleEntity.rawValue) { (success, nil) in
            saveArticleToCoreData(arrData, entity: entityObj, managedContext: managedObjectContext)
        }
        break
    case .MediaEntity:
        break
    case .UserEntity:
        break
    }
    
}








//MARK: RESET Core Data
fileprivate func clearCoreDataStoreForEntityName(_ entityName:String,completion:CoreDataOperationsCompletion) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
        try managedObjectContext.execute(deleteRequest)
        try managedObjectContext.save()
        completion(true,nil)
    } catch {
        print(error)
        completion(false,nil)
    }
}








//MARK: FETCH
fileprivate func getUserModelObject(_ userManagedObj: User?) -> UserModel{

    return UserModel.init(blogId: userManagedObj?.blogId ?? "",
                          userId: userManagedObj?.userId ?? "",
                          about: userManagedObj?.about ?? "",
                          avatar: userManagedObj?.avatar ?? "",
                          city: userManagedObj?.city ?? "",
                          designation: userManagedObj?.designation ?? "",
                          name: userManagedObj?.name ?? "",
                          lastname: userManagedObj?.lastname ?? "",
                          createdAt: userManagedObj?.createdAt ?? "")
}

fileprivate func getMediaModelObject(_ mediaManagedObj: Media?) -> MediaModel{
    
    return MediaModel.init(blogId: mediaManagedObj?.blogId ?? "",
                           mediaId: mediaManagedObj?.mediaId ?? "",
                           createdAt: mediaManagedObj?.createdAt ?? "",
                           image: mediaManagedObj?.image ?? "",
                           title: mediaManagedObj?.title ?? "",
                           url: mediaManagedObj?.url ?? "")
}

fileprivate func getArticleModelObject(_ arrArticleManagedObj: [Article]?) -> [ArticleModel]?{
    
    guard let arrArticleManagedObj = arrArticleManagedObj else{
        return nil
    }
    
    var arrArticleModelObject:[ArticleModel] = []
    
    for articleManagedObj in arrArticleManagedObj{
        let articleMedia = getMediaModelObject(articleManagedObj.articleMedia)
        let articleUser = getUserModelObject(articleManagedObj.articleUser)
        
      let article =  ArticleModel.init(comments: articleManagedObj.comments ?? "",
                          likes: articleManagedObj.likes ?? "",
                          articleId: articleManagedObj.articleId ?? "",
                          content: articleManagedObj.content ?? "",
                          createdAt: articleManagedObj.createdAt ?? "",
                          mediaObject: articleMedia,
                          userObject: articleUser)
        arrArticleModelObject.append(article)
    }
    
    return arrArticleModelObject
}

    
func fetchDataForEntity(entityName:EntityTitle)-> [Any]? {

    //Prepare the request of type NSFetchRequest  for the entity
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)

    do {
        let result = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        switch entityName {
        case .ArticleEntity:
           return getArticleModelObject(result as? [Article])
        case .MediaEntity:
            break
        case .UserEntity:
            break
        }
    } catch {
        //print("<<<Failed>>>")
    }

    return nil
}
