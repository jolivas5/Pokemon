//
//  ProducDetailCollectionViewCell.swift


import UIKit

class ProducDetailCollectionViewCell: UICollectionViewCell, NibLoadable {

    @IBOutlet weak var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var producImageTapped: (() -> Void)? {
        didSet {
            productImageView.isUserInteractionEnabled = true
            productImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(imageViewTapped)))
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @objc private func imageViewTapped() {
        producImageTapped?()
    }
}
