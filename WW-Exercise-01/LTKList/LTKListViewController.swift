//
//  FoodListViewController.swift


import UIKit
import Combine
import SDWebImage

final class LTKListViewController: UICollectionViewController {

    private let viewModel: LTKListViewModel
    private var searchController = UISearchController(searchResultsController: nil)

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, LTK>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LTK>

    private enum Section: CaseIterable {
        case main
    }

    init(viewModel: LTKListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: LTKListViewController.generateLayout())
        self.viewModel.ltkEntitySubject.subscribe(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, ltk) -> UICollectionViewCell in
            let cell: LTKListCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.title.text = ltk.caption
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.sd_setImage(with: URL(string: ltk.hero_image ?? ""),
                                       placeholderImage: #imageLiteral(resourceName: "Placeholder-image"),
                                       options: .retryFailed,
                                       context: nil)

            cell.imageTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.didTapItem(model: ltk)
            }

            return cell
        }

        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI() {
        collectionView.register(LTKListCollectionViewCell.self)
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .white
        viewModel.loadData()
        configureSearchController()
        collectionView.prefetchDataSource = self
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search LTK", comment: "Placeholder text in searchbar homescreen")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func applySnapshot(items: [LTK], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(items, toSection: $0) }
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

extension LTKListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchFoodList(for: searchController.searchBar.text)
    }
}

extension LTKListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchData(for: indexPaths)
    }
}

extension LTKListViewController: Subscriber {

    /// Subscriber is willing recieve unlimited values upon subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    /// .none, indicating that the subscriber will not adjust its demand
    func receive(_ input: [LTK]) -> Subscribers.Demand {
        applySnapshot(items: input)

        return .none
    }

    /// Print the completion event
    func receive(completion: Subscribers.Completion<APIFailure>) {
        switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
        }
        
    }
}

protocol Localization {
    associatedtype Key
    func localizedString(_ key: Key) -> String
}

extension LTKListViewController: Localization {
    func localizedString(_ key: LocalizationPropertiesKey) -> String {
        return key.localizedString
    }
    enum LocalizationPropertiesKey {
        case fieldLabel, defaultValue, isRequired, isReadOnly
        
        var localizedString: String {
            switch self {
                case .fieldLabel: return NSLocalizedString("Field Label", comment: "Label name of a field property.")
                case .defaultValue: return NSLocalizedString("Default Value", comment: "Label name of a field property.")
                case .isRequired: return NSLocalizedString("Required", comment: "Label name of a field property.")
                case .isReadOnly: return NSLocalizedString("Read Only", comment: "Label name of a field property.")
            }
        }
    }
}
