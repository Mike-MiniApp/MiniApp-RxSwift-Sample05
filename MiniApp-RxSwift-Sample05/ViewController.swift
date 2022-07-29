//
//  ViewController.swift
//  MiniApp-RxSwift-Sample05
//
//  Created by 近藤米功 on 2022/07/29.
//

/*
 機能まとめ
 ・メールアドレスはgmail.com
 ・パスワードは5文字以上
 ・パスワードと確認パスワードが一致
 */

import UIKit
import RxSwift
import RxCocoa
import RxRelay


class ViewController: UIViewController {

    // MARK: UI Parts
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var password1TextField: UITextField!
    @IBOutlet private weak var password2TextField: UITextField!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var errorTextView: UITextView!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let input = Observable.combineLatest(emailTextField.rx.text.map{$0 ?? ""}, password1TextField.rx.text.map{$0 ?? ""}, password2TextField.rx.text.map{$0 ?? ""})

        input.map { email, password1, password2 in
            return email.isValidEmail && password1.isValidPassword && password2.isValidPassword && password1 == password2
        }
        .bind(to: signupButton.rx.isEnabled)
        .disposed(by: disposeBag)

        input.map { email, password1, password2 in
            var message: [String] = []
            if email.isEmpty{
                message.append("メールアドレスを入力してください")
            }else if !email.isValidEmail{
                message.append("メールアドレスの形式が正しくありません")
            }

            if password1.isEmpty{
                message.append("パスワードを入力してください")
            }else if !password1.isValidPassword{
                message.append("パスワードの形式が正しくありません")
            }

            if password2.isEmpty{
                message.append("確認用のパスワードを入力してください")
            }else if !password2.isValidPassword{
                message.append("確認用の形式が正しくありません")
            }

            if !password1.isEmpty && !password2.isEmpty && password1 != password2{
                message.append("パスワードと確認用のパスワードの一致していません")
            }

            return message.map({"・\($0)"}).joined(separator: "\n")
        }.bind(to: errorTextView.rx.text)
            .disposed(by: disposeBag)
    }
}

private extension String{
    var isValidEmail: Bool{
        self.contains("@gmail.com")
    }

    var isValidPassword: Bool{
        self.count > 5
    }
}

