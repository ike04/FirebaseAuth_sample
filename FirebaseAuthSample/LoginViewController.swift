//
//  ViewController.swift
//  FirebaseAuthSample
//
//  Created by 池田一成 on 2020/11/28.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!{
        didSet {
            userNameTextField.placeholder = "ユーザー名"
            userNameTextField.clearButtonMode = .always
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = "メールアドレス"
            emailTextField.clearButtonMode = .always
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet {
            passwordTextField.placeholder = "パスワード"
            passwordTextField.clearButtonMode = .always
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.setTitle("ログイン", for: .normal)
            loginButton.setTitleColor(UIColor.white, for: .normal)
            loginButton.backgroundColor = UIColor.systemBlue
            loginButton.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTappedLoginButton(_ sender: Any) {
        let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let name = userNameTextField.text ?? ""
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                if let user = result?.user {
                    let req = user.createProfileChangeRequest()
                    req.displayName = name
                    req.commitChanges() { [weak self] error in
                        guard let self = self else { return }
                        if error == nil {
                            user.sendEmailVerification() { [weak self] error in
                                guard let self = self else { return }
                                if error == nil {
                                    // 仮登録完了画面へ遷移する処理
                                }
                                self.showErrorIfNeeded(error)
                            }
                        }
                        self.showErrorIfNeeded(error)
                    }
                }
                self.showErrorIfNeeded(error)
            }
    }
    
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
        
        let message = "エラーが起きました" // ここは後述しますが、とりあえず固定文字列
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

