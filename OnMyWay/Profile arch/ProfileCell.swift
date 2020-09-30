//
//  ProfileCell.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 9/30/20.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    
    var viewModel: ProfileViewModel?{
        didSet{configureUI()}
    }
    
    private lazy var tellFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "Tell a friend "
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0500845000 "
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "tariq.almazyad@gmail.com "
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
    }
    
    func configureUI(){
        guard let viewModel = viewModel else { return  }
        switch viewModel {
        case .section_1:
            addSubview(phoneNumberLabel)
            phoneNumberLabel.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            accessoryType = .disclosureIndicator
        case .section_2:
            addSubview(emailLabel)
            emailLabel.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            accessoryType = .disclosureIndicator
        case .section_3:
            accessoryType = .detailButton
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



enum ProfileViewModel: Int, CaseIterable {
    case section_1
    case section_2
    case section_3
    
    var numberOfCells: Int {
        switch self {
        case .section_1: return 1
        case .section_2: return 1
        case .section_3: return 2
        }
    }
    
    var sectionTitle: String {
        switch self {
        
        case .section_1: return "Phone Number"
        case .section_2: return "Email"
        case .section_3: return "Report"
        }
    }
    
}
