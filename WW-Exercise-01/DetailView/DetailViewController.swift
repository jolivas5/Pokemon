//
//  DetailViewController.swift

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var collectionDetailView: UICollectionView!
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private let viewModel: DetailViewModel
    
    private enum Section: CaseIterable {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionDetailView) { (collectionView, indexPath, products) -> UICollectionViewCell in
            let cell: ProducDetailCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.productImageView.contentMode = .scaleAspectFill
            cell.productImageView.sd_setImage(with: URL(string: products.image_url ?? ""),
                                       placeholderImage: #imageLiteral(resourceName: "Placeholder-image"),
                                       options: .retryFailed,
                                       context: nil)

            cell.producImageTapped = { [weak self] in
                guard let self = self else { return }
                if let url = URL(string: products.hyperlink ?? "") {
                    UIApplication.shared.open(url)
                }
            }

            return cell
        }

        return dataSource
    }()

    private func setUI() {
        configureImage()
        configureLayout()
        applySnapshot(products: self.viewModel.products.elements)
        collectionDetailView.collectionViewLayout = DetailViewController.generateLayout()
    }
    
    private func configureImage() {
        imageView.sd_setImage(with: URL(string: viewModel.LTK.hero_image ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder-image"), options: .retryFailed)
        avatarImageView.sd_setImage(with: URL(string: viewModel.profile.avatar_url ?? ""), placeholderImage: #imageLiteral(resourceName: "Placeholder-image"), options: .retryFailed)
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2.0
    }
    
    private func configureLayout() {
        collectionDetailView.register(ProducDetailCollectionViewCell.self)
        collectionDetailView.dataSource = dataSource
        collectionDetailView.backgroundColor = .white
    }
    
    private func applySnapshot(products: [Product], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(products, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    static private func generateLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))

        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)

        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                              leading: 4,
                                                              bottom: 4,
                                                              trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
