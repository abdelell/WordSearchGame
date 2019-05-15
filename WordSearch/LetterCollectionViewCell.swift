//
//  LetterCollectionViewCell.swift
//  WordSearch
//
//  Created by macbook on 5/12/19.
//  Copyright © 2019 Abdel. All rights reserved.
//

import UIKit

class LetterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        letterLabel.layer.cornerRadius = 10
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                letterLabel.backgroundColor = .blue
            } else {
                letterLabel.backgroundColor = .clear
            }
        }
    }
}
