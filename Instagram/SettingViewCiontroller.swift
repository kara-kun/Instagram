//
//  SettingViewCiontroller.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/14.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    //表示名変更ボタンの処理
    @IBAction func handleChangeButton(_ sender: Any) {
        //textFirldに入力されていることを確認
        if let displayName = displayNameTextField.text {
            //表示名が入力されていなければ、HUDでエラーメッセージを表示
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            //-----------表示名を設定する-----------
            //現在のユーサー情報を取得
            let user = Auth.auth().currentUser
            if let user = user {
                //createProfileChangeRequestインスタンスを設定
                let changeRequest = user.createProfileChangeRequest()
                //入力された表示名をdchangeRequestのdisplayNameプロパティに代入
                changeRequest.displayName = displayName
                //表示名変更を実行
                changeRequest.commitChanges { error in
                    //もしエラーが起きれば、HUDでエラーメッセージを表示してreturn
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
                        print("DEBUG_print: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_print: [displayName = \(user.displayName!)]の設定に成功しました ")
                    //HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を\(user.displayName!)に変更しました")
                    
                }
                //↑ここまでクロージャー
            }
        }
        self.view.endEditing(true)
    }
        
    //ログアウトボタンの処理
    @IBAction func handleLogoutButton(_ sender: Any) {
        //ログアウトする
        try! Auth.auth().signOut()
        //ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        //ホーム画面を選択している状態に戻すindex=0
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //現在ログインしているユーザー情報を取得
        let user = Auth.auth().currentUser
        //そのユーザー情報から表示名を取得し、displayNameTextFieldに表示
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
