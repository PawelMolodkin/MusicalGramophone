//
//  MGAlbumViewController.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 21/08/2019.
//

import UIKit

class MGAlbumViewController: UIViewController, UITableViewDelegate, CALayerDelegate {

    let dataSource = MGAlbumDataSource()

    lazy var viewModel : MGAlbumViewModel = {
        let viewModel = MGAlbumViewModel(id: "424663", dataSource: dataSource)
        return viewModel
    }()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var backView: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    private var gradient: CAGradientLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlbum()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.dataSource.data.addAndNotify(observer: self) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        addGradient()
        self.view.bringSubviewToFront(topImageView)
        self.tableView.register(UINib(nibName: "MGDescriptionCell", bundle: nil), forCellReuseIdentifier: "MGDescriptionCell")
        tableView.contentInset = UIEdgeInsets.init(top: imageView.frame.size.width, left: 0, bottom: 0, right: 0)
        viewModel.imageView = self.imageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func loadAlbum() {
        self.viewModel.loadAlbum(success: {
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
            }
        }) {
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                let alert = UIAlertController(title: "Ошибка сети", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        self.indicatorView.startAnimating()
                        self.loadAlbum()
                    case .cancel:
                        print("cancel")

                    case .destructive:
                        print("destructive")
                    @unknown default: break
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func addGradient() {
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.1, 0.85, 1]
        gradient.delegate = self
        backView.layer.mask = gradient
        backView.addSubview(tableView)
    }

    // MARK: Layout methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutImageView()
        tableView.contentInset = UIEdgeInsets(top: imageView.frame.size.width / 3, left: 0, bottom: 0, right: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = self.view.bounds
    }

    func layoutImageView() {
        var frame = imageView.frame
        frame.size.width = self.view.frame.size.width / 2
        frame.size.height = frame.size.width
        frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2
        imageView.frame = frame
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        showPlayerViewController(indexPath: indexPath)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80.0
        }
        return 44.0
    }

    func showPlayerViewController(indexPath:IndexPath) {
        viewModel.showPlayerViewController(ownerViewController: self, count: indexPath.row - 1)
    }
    
    // MARK: StatusBar methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
