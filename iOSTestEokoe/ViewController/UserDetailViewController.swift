//
//  UserDetailViewController.swift
//  iOSTestEokoe
//
//  Created by Fernanda de Lima on 11/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendActionButton(_ sender: Any) {

    }

    @IBAction func backActionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var index = 0
    var name = ""
    var image:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    private func initLayout(){
        sendButton.layer.cornerRadius = 8
        userImageView.layer.cornerRadius = min(userImageView.frame.width, userImageView.frame.height)/2
        userImageView.layer.borderColor = UIColor.gray.cgColor
        userImageView.layer.borderWidth = 2
        
        nameLabel.text = name
        userImageView.image = image
    }
    
    private func loadUser(){
        
        API.get(UserDetail.self, endpoint: .user(index), success: { (userDetail) in
            DispatchQueue.main.async {
                self.emailLabel.text = userDetail.email
                self.locationLabel.text = userDetail.location.city
                self.bioLabel.text = userDetail.bio.full
                self.updateViewConstraints()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

}
