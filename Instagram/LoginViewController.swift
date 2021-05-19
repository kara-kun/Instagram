//
//  LoginViewController.swift
//  Instagram
//
//  Created by 唐津 哲也 on 2021/05/14.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //ログインボタンを押された時に呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        //オプショナルバインディング：メアドとパスワードの入力が両方がnilでないことを確認(nilならそもそも何もしない)
        if let address = mailAddressTextField.text , let password = passwordTextField.text {
            //メアド、パスワードいずれかの入力が空文字の場合-> HUDで警告メッセージ(withStatus:String)を表示し、returnもどる
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            //ーーーーー全ての項目が入力されていれば、ログイン作業開始：
            //HUDで処理中を表示
            SVProgressHUD.show()
            //第一引数authResult=認証結果情報、　第二引数error＝エラー発生時のエラー情報
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                //エラーがあれば(エラーがなくなる＝nilになるまで)
                if let error = error {
                    //エラー内容を表示しreturn
                    print ("DEBUG_print: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ログインに失敗しました")
                    return
                }
                //エラーがなくなればログイン成功
                print ("DEBUG_print: ログインに成功しました")
                //HUDを閉じる
                SVProgressHUD.dismiss()
                //ログイン画面Modal viewを閉じる
                self.dismiss(animated: true, completion: nil)
            //ここまでクロージャーTrailingClosure
            }
        }
    }
    
    //アカウント作成ボタンを押した時に呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        //mailAddress password displayName全て入力されていること(nilではないこと)
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            //メアド、パスワード、displayNameいずれかの入力が空欄(空文字)の場合
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                //メッセージ表示の後、HUDにエラーメッセージを表示し、戻るreturn
                print("DEBUG_print: 何かが空文字です")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            //ーーーーーーーーーーーーー新規アカウント作成ーーーーーーーーーーーーーーー
            //HUDにて状況を表示
            SVProgressHUD.show()
            //このクロージャーの書き方はTrailingClosure(後置クロージャー)
            //メアド、パスワードにて新規ユーザーを作成createUser
            //第一引数authResult=認証結果情報、　第二引数error＝エラー発生時のエラー情報
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                //errorパラメーターのオプショナルバインディング：errorがなくなる=nilになるまで繰り返す
                if let error = error {
                    //error内容をprint表示して、そのままreturn、以降の処理はなし
                    print("DEBUG_print: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "新規ユーザー登録に失敗しました")
                    return
                }
                //エラーがなくなる＝アカウント作成->ログイン
                print("DEBUG_print: 新規ユーザー登録に成功しました")
                
                //Authインスタンスのuserを作成
                let user = Auth.auth().currentUser
                if let user = user {
                    //changeRequestメソッドのインスタンスchangeRequestを作成
                    let changeRequest = user.createProfileChangeRequest()
                    //その中にあるdisplayNameプロパティに、入力されたdisplayNameを代入
                    changeRequest.displayName = displayName
                    //????Commits any pending changes.???
                    changeRequest.commitChanges { error in
                        //プロフィール更新（）で、もしエラーがあれば、エラー内容を表示して、何もせずにreturn
                        if let error = error {
                            print("DEBUG_print: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました")
                            return
                        }
                        print("DEBUG_print: [displayName = \(user.displayName!)]の設定に成功しました")
                        //HUDを閉じる
                        SVProgressHUD.dismiss()
                        //ログイン画面のmodal Viewを閉じる
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            //↑ここまでcreateUserメソッドのTrailingClosure
            
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
