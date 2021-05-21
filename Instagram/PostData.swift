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
    //コメント
    var comment:[String?] = []
    
    //FireStore　Databaseからとってきたデータの各パラメータ初期化
    init(document: QueryDocumentSnapshot) {
        //ドキュメントidの定義
        self.id = document.documentID
        //Firestoreから取得したデータdocumentを辞書形式で格納
        let postDic = document.data()
        //nameはpostDic内の"name"キーに対応する文字列
        self.name = postDic["name"] as? String
        //captionはpostDic内の"caption"キーに対応する文字列
        self.caption = postDic["caption"] as? String
        //Timestampはfirebaseの日時形式
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        //likesはもし存在すれば、postDic内の"likes"キーに対応するid -> 文字列型へダウンキャスト
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
