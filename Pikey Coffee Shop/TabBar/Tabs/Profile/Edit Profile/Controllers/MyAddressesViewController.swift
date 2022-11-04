//
//  MyAddressesViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/06/2022.
//

import UIKit

class MyAddressesViewController: EditProfileBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "MyAddressCell", bundle: .main), forCellReuseIdentifier: "myAddressCell")
        // Do any additional setup after loading the view.
    }

    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAddAddress() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension MyAddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAddressCell", for: indexPath) as! MyAddressCell
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

}
