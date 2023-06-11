//
//  DatePickerCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 11/06/2023.
//

import UIKit

class DatePickerCell: UITableViewCell {
    
    @IBOutlet weak var dateField: UITextField!
    var datePicker = UIDatePicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        dateField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm aa"
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
}
