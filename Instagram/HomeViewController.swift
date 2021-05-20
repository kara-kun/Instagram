//
//  HomeViewController.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/14.
//

import UIKit
import Firebase

//TableViewDelegate,TableViewDataSourceプロトコル批准
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    
    //Firebaseのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableViewのデリゲート先を自身(viewController)に設定
        tableView.delegate = self
        tableView.dataSource = self
        
        //----カスタムセルPostTableViewCellを登録する-----
        //nibオブジェクトを作成："PostTableViewCell.xib"ファイルをキャッシュに読込。
        //ちなみにnib：NextstepInterfaceBuilder xib：XML Interface Builderらしい？？
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        //nibオブジェクトをtableViewにidentifier"Cell"をつけて登録
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    
    }
    
    //画面表示時の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print ("DEBUG_print: viewWillAppear")
        
        //ログイン済みか確認-> ログイン済のcurrentUserが存在すれば
        if Auth.auth().currentUser != nil {
            //ーーーーListerを登録して投稿データの更新を監視ーーーーー
            //Firestoreの投稿データを投稿日時date順(降順)に収集するクエリーpostRefを設定
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            //
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                //エラーがあれば、ログを表示して戻る
                if let error = error {
                    print("DEBUG_print: snapshotの取得に失敗。\(error)")
                    return
                }
                //取得したdocumentを元にPostDataを作成->postArray配列に格納
                print(querySnapshot!)
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_print: document取得　\(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                //tableViewの表示を更新
                self.tableView.reloadData()
            }
        }
    }
    
    //画面を消す際の処理
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //listenerを削除して監視を停止
        listener?.remove()
    }
    
    //プロトコルTableViewDataSourceの必須デリゲートメソッド２つを実装
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セルの数＝PostArray配列の要素数
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        //cellに画像を設定(setPostData()メソッドはPostTableVeiwCell.swiftで定義したもの)
        cell.setPostData(postArray[indexPath.row])
        
        //「いいね」ボタンのアクションを定義
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //「コメント」ボタンのアクションを定義
        cell.commentButton.addTarget(self, action: #selector(handleComment(_:forEvent:)), for: .touchUpInside)
        
        //セルを返す
        return cell
    }
    
    //イイネボタンが押された際の処理を実装する
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print ("DEBUG_print: likeボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        //画面に触れた全てのタッチのうち最初のイベントをtouchに代入
        let touch = event.allTouches?.first
        //そのイベントのtableView上の場所を所得（CGPoint）
        let point = touch!.location(in: self.tableView)
        //得られたCGPointからtableView内のどのセルがタッチされたかを割り出し、そのセルのindexPathを得る
        let indexPath = tableView.indexPathForRow(at: point)
        //得られたindexPathから、タッチされたセルの投稿データを取得
        let postData = postArray[indexPath!.row]
        
        //likesを更新
        //ログインしているユーサーのidがあれば
        if let myid = Auth.auth().currentUser?.uid {
            var updateValue: FieldValue
            //自分がいいねを押していれば、likes配列からmyidを取り除くupdateValueを定義
            if postData.isLiked == true {
                updateValue = FieldValue.arrayRemove([myid])
            } else {
            //自分がいいねを押していなければ、likes配列にmyidを追加するupdateValueを定義
                updateValue = FieldValue.arrayUnion([myid])
            }
            
            //Firestore上のデータを書き込む場所を定義
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            //"likes"の更新データを書き込む
            postRef.updateData(["likes": updateValue])
        }
        
    }
    
    @objc func handleComment(_ sender: UIButton, forEvent event: UIEvent) {
        print ("DEBUG_print: commentボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        //画面に触れた全てのタッチのうち最初のイベントをtouchに代入
        let touch = event.allTouches?.first
        //そのイベントのtableView上の場所を所得（CGPoint）
        let point = touch!.location(in: self.tableView)
        //得られたCGPointからtableView内のどのセルがタッチされたかを割り出し、そのセルのindexPathを得る
        let indexPath = tableView.indexPathForRow(at: point)
        //得られたindexPathから、タッチされたセルの投稿データを取得
        let postData = postArray[indexPath!.row]
            print(indexPath!)
            print(postData)
        //---------------commentViewControllerを表示-------------
        //Firestore上のタッチされた画像(セル)に該当するpostデータの場所を定義
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            print (postRef)
        //コメント画面("Comment")のviewControllerをcommentViewControllerへダウンキャストし、インスタンスを定義
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        //commentViewControllerへ取得したFirestoreのpost保存場所を送る
        commentViewController.postRef = postRef
        //投稿画面をmodal viewで表示
        present(commentViewController, animated: true, completion: nil)


    }

}
