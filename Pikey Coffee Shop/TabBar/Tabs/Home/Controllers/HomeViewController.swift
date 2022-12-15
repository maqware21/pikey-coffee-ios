//
//  HomeViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 06/06/2022.
//

import UIKit
import BetterSegmentedControl


class HomeViewController: TabItemViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: BetterSegmentedControl!
    internal var viewModel = HomeViewModel()
    
    internal var categoryData: CategoryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        //tableView config
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeHeadlineCell", bundle: .main), forCellReuseIdentifier: "homeCell")
        tableView.register(UINib(nibName: "HomeFeedCell", bundle: .main), forCellReuseIdentifier: "homeFeedCell")
        tableView.contentInset.bottom = 48
        
        //segment config
        segment.segments = LabelSegment.segments(withTitles: ["Deliver to", "Home"],
                                                 normalTextColor: .white,
                                                 selectedTextColor: .black)
        segment.setIndex(1)

        self.loadData(page: 1)
    }
    
    func onClickAddressOptoin() {
        let controller = DeliveryView(frame: .zero)
        let vc = PickeySheet(view: controller)
        vc.delegate = self
        let navigation = UINavigationController(rootViewController: vc)
        navigation.navigationBar.isHidden = true
        navigation.modalTransitionStyle = .coverVertical
        navigation.modalPresentationStyle = .overFullScreen
        present(navigation, animated: true)
    }
    
    @IBAction func onSegmentValueChanged(_ sender: BetterSegmentedControl!) {
        if sender.index == 0 {
            onClickAddressOptoin()
        }
    }
    
    func loadData(page: Int) {
        self.showLoader()
        viewModel.getCategories(for: page)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return  //indexPath.section == 0 ?
                //headlineCell(tableView, cellForRowAt: indexPath) :
                feedCell(tableView, cellForRowAt: indexPath)
    }
    
    func feedCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeFeedCell", for: indexPath) as! HomeFeedCell
        cell.category = categoryData?.data?[indexPath.row]
        
        if (categoryData?.data?.count ?? 0) - indexPath.row == CategoryConstants.perPageCount/2 && categoryData?.pagination?.totalPages ?? 0 > categoryData?.pagination?.currentPage ?? 0 {
            self.loadData(page: (categoryData?.pagination?.currentPage ?? 0) + 1)
        }
        
        return cell
    }
    
    func headlineCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeHeadlineCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = categoryData?.data?[indexPath.row].id {
            if let controller = UIStoryboard(name: "Product", bundle: .main).instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController {
                controller.categoryID = id
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            self.view.displayNotice(with: "This category has no data")
        }
    }
}

extension HomeViewController: HomeDelegate, PickeySheetDelegate {
    func categoryUpdate(with categoryData: CategoryData?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let categoryData {
                if categoryData.pagination?.currentPage != 1 {
                    self.categoryData?.data?.append(contentsOf: categoryData.data ?? [])
                    self.categoryData?.pagination = categoryData.pagination
                } else {
                    self.categoryData = categoryData
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func sheetClosed() {
        segment.setIndex(1)
    }
    
}
