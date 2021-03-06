//
//  AlbumsPickerViewController.swift
//  GiniVision
//
//  Created by Enrique del Pozo Gómez on 2/26/18.
//

import Foundation

protocol AlbumsPickerViewControllerDelegate: class {
    func albumsPicker(_ viewController: AlbumsPickerViewController,
                      didSelectAlbum album: Album)
}

final class AlbumsPickerViewController: UIViewController {
    
    weak var delegate: AlbumsPickerViewControllerDelegate?
    fileprivate let galleryManager: GalleryManagerProtocol
    fileprivate let giniConfiguration: GiniConfiguration
    
    // MARK: - Views

    lazy var albumsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = Colors.Gini.dynamicPearl
        } else {
            tableView.backgroundColor = Colors.Gini.pearl
        }
        
        tableView.register(AlbumsPickerTableViewCell.self,
                           forCellReuseIdentifier: AlbumsPickerTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Initializers

    init(galleryManager: GalleryManagerProtocol,
         giniConfiguration: GiniConfiguration = GiniConfiguration.shared) {
        self.galleryManager = galleryManager
        self.giniConfiguration = giniConfiguration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        title = .localized(resource: GalleryStrings.albumsTitle)
        view.addSubview(albumsTableView)
        Constraints.pin(view: albumsTableView, toSuperView: view)
    }
    
    func reloadAlbums() {
        albumsTableView.reloadData()
    }
    
}

// MARK: UITableViewDataSource

extension AlbumsPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleryManager.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            AlbumsPickerTableViewCell.identifier) as? AlbumsPickerTableViewCell
        let album = galleryManager.albums[indexPath.row]
        cell?.setUp(with: album,
                    giniConfiguration: giniConfiguration,
                    galleryManager: galleryManager)
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: UITableViewDelegate

extension AlbumsPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.albumsPicker(self, didSelectAlbum: galleryManager.albums[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AlbumsPickerTableViewCell.height
    }
}
