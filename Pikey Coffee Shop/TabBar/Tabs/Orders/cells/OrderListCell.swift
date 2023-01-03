//
//  OrderListCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 08/06/2022.
//

import UIKit

protocol OrderCellDelegate: AnyObject {
    func presentOnCell(id: Int?)
}

class OrderListCell: UITableViewCell {

    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var cancelButton: UIView!
    weak var delegate: OrderCellDelegate?
    
    var order: Order? {
        didSet {
            guard let order else { return }
            orderImage.kf.setImage(with: URL(string: order.items?.first?.product?.images?.first?.path ?? ""))
            orderTitle.text = order.items?.first?.product?.name
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy - hh:mmaa"
            
            if let date = dateFormatterGet.date(from: order.deliveryDate ?? "") {
                orderDate.text = dateFormatterPrint.string(from: date)
            } else {
                orderDate.text = ""
            }
            
            orderStatus.text = order.statusInText
            orderName.text = order.items?.first?.product?.name
            orderPrice.text = String(format: "$%.2f", order.totalPrice ?? 0)
            
            if order.statusInText == "Cancelled" {
                cancelButton.isHidden = true
            } else {
                cancelButton.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickButton() {
        delegate?.presentOnCell(id: order?.id)
    }
}
