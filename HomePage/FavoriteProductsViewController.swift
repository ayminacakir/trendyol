import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavoriteProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private var favoriteProducts: [ProductSummary] = []
    private var favoriteListener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favoriler"

        setupTableView()
        observeFavoriteProducts() // Gerçek zamanlı dinleme başlat
    }

    deinit {
        favoriteListener?.remove() // Memory leak önleme
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteProductCell.self, forCellReuseIdentifier: "FavoriteProductCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteProductCell", for: indexPath) as! FavoriteProductCell
        let product = favoriteProducts[indexPath.row]
        cell.configure(with: product)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let user = Auth.auth().currentUser else { return }
            let product = favoriteProducts[indexPath.row]
            let db = Firestore.firestore()
            
            db.collection("users").document(user.uid).collection("favorites").document("\(product.id)").delete { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Favoriden silinemedi: \(error.localizedDescription)")
                } else {
                    // Diziden kaldır ve TableView'i güncelle
                    self.favoriteProducts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    //  Real-time Firestore listener
    private func observeFavoriteProducts() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let favRef = db.collection("users").document(user.uid).collection("favorites")
        
        favoriteListener = favRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Favoriler alınamadı: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let productIDs = documents.compactMap { Int($0.documentID) }.reversed()
            
            let group = DispatchGroup()
            var fetchedProducts: [ProductSummary] = []

            for id in productIDs {
                group.enter()
                NetworkManager.shared.fetchProductDetail(id: id) { detail in
                    if let detail = detail {
                        let summary = ProductSummary(
                            id: detail.id,
                            title: detail.title,
                            price: detail.price,
                            image: detail.image,
                            rating: detail.rating
                        )
                        fetchedProducts.append(summary)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.favoriteProducts = fetchedProducts
                self.tableView.reloadData()
            }
        }
    }
}
