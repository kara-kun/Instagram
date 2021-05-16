//
//  PostData.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/16.
//

import UIKit
import Firebase

class PostData: NSObject {
    //投稿者のid
    var id: String
    //投稿者の名前
    var name: String?
    //キャプション
    var caption: String?
    //日付
    var date: Date?
    //「いいね」した人のID（配列）
    var likes: [String] = []
    //自分が「いいね」したかどうかのフラグ
    var isLiked: Bool = false
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
        //Timestampはfirebaseの日時形式
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかを確認（含まれていれば）
            if self.likes.firstIndex(of: myid) != nil {
                //「いいね」を押していると判定
                self.isLiked = true
            }
        }
    }
}
