//
//  FoodListViewController.swift


import UIKit
import Combine
import SDWebImage

final class PokemonListViewController: UICollectionViewController {

    private let viewModel: PokemonListViewModel
    private var searchController = UISearchController(searchResultsController: nil)

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Pokemon>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>

    private enum Section: CaseIterable {
        case main
    }

    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: PokemonListViewController.generateLayout())
        self.viewModel.pokemonListSubject.subscribe(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, pokemon) -> UICollectionViewCell in
            
            let cell: PokemonNameCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            
            cell.pokemonNameLabel.text = pokemon.name

            cell.cellTapped = { [unowned self] in
                viewModel.didTapItem(model: pokemon)
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
        collectionView.register(PokemonNameCollectionViewCell.self)
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = .white
        viewModel.loadData()
        configureSearchController()
        collectionView.prefetchDataSource = self
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = localizedString(.searchField)
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func applySnapshot(items: [Pokemon], animatingDifferences: Bool = true) {
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

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchPokemon(with: searchController.searchBar.text)
    }
}

extension PokemonListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchData(for: indexPaths)
    }
}

extension PokemonListViewController: Subscriber {

    /// Subscriber is willing recieve unlimited values upon subscription
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    /// .none, indicating that the subscriber will not adjust its demand
    func receive(_ input: [Pokemon]) -> Subscribers.Demand {
        applySnapshot(items: input)
        return .none
    }

    /// Print the completion event
    func receive(completion: Subscribers.Completion<Failure>) {
        switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
        }
    }
}

extension PokemonListViewController: Localization {
    
    func localizedString(_ key: LocalizationPropertiesKey) -> String {
        return key.localizedString
    }
    
    enum LocalizationPropertiesKey {
        case searchField
        
        var localizedString: String {
            switch self {
                case .searchField: return NSLocalizedString("Search LTK", comment: "Placeholder text in searchbar homescreen")
            }
        }
    }
}
