//
//  LoginViewController.swift
//  ChatApp-IOS
//
//  Created by TWBKG on 12/5/2562 BE.
//  Copyright © 2562 TWBKG. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        enableView(isEnable: false)
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            
            if error != nil {
                
                print("sing in error ", error!)
                SVProgressHUD.showError(withStatus: "Sign in fail!")
                self.enableView(isEnable: true)
                
            }
            else {
                
                SVProgressHUD.dismiss()
                
//                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//                let targetViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//                self.present(targetViewController, animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
            
        }
        
        
    }
    
    func enableView(isEnable : Bool) {
        buttonLogin.isEnabled = isEnable
        passwordTextField.isEnabled = isEnable
        emailTextField.isEnabled = isEnable
    }
}
