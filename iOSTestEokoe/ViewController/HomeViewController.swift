//
//  ViewController.swift
//  iOSTestEokoe
//
//  Created by Fernanda de Lima on 11/09/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var indActivity: UIActivityIndicatorView!
    
    var users:Users = Users()
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    private func loadUsers(){
        indActivity.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        start += API.page * 20
        
        API.get(Users.self, endpoint: .users(start), success: { (users) in
            self.users.results.append(contentsOf: users.results)
            API.page += 1
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.indActivity.stopAnimating()
                self.userTableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.results.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (users.results.count - 1){
            loadUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userIdentifier") as! UserViewCell
        cell.nameLabel.text = "\(users.results[indexPath.row].name.first) \(users.results[indexPath.row].name.last)"
        cell.descriptionLabel.text = users.results[indexPath.row].bio.mini
        
        if let url = URL(string: self.users.results[indexPath.row].picture.medium){
            let data = try? Data(contentsOf:url)
            cell.userImageView.image = UIImage(data: data!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetail = storyboard?.instantiateViewController(withIdentifier: "userDetailViewController") as! UserDetailViewController
        userDetail.index = self.users.results[indexPath.row].id
        userDetail.name = "\(users.results[indexPath.row].name.first) \(users.results[indexPath.row].name.last)"
        
        if let url = URL(string: self.users.results[indexPath.row].picture.medium){
            let data = try? Data(contentsOf:url)
            userDetail.image = UIImage(data: data!)!
        }
        
        self.navigationController?.pushViewController(userDetail, animated: true)
        
    }
    
    
}
