//
//  HomeViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 06/06/2022.
//

import UIKit

class HomeViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeHeadlineCell", bundle: .main), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName: "HomeFeedCell", bundle: .main), forCellReuseIdentifier: "homeFeedCell")
        tableView.contentInset.bottom = 48
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickAddressOptoin() {
        let controller = DeliveryView(frame: .zero)
        let vc = PickeySheet(view: controller)
        let navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.modalTransitionStyle = .coverVertical
        navigation.modalPresentationStyle = .overFullScreen
        present(navigation, animated: true)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        label.text = "Nearby Cafes"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        label.backgroundColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return  indexPath.section == 0 ?
                headlineCell(tableView, cellForRowAt: indexPath) :
                feedCell(tableView, cellForRowAt: indexPath)
    }
    
    func feedCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell", for: indexPath) as! HomeFeedCell
        return cell
    }
    
    func headlineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeHeadlineCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let controller = UIStoryboard(name: "Product", bundle: .main).instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
