//
//  LTKListCollectionViewCell.swift


import UIKit

final class LTKListCollectionViewCell: UICollectionViewCell, NibLoadable {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var title: UILabel!

    var imageTapped: (() -> Void)? {
        didSet {
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(imageViewTapped)))
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @objc private func imageViewTapped() {
        imageTapped?()
    }
}
