//
//  OpenWithTutorialViewController.swift
//  GiniVision
//
//  Created by Enrique del Pozo Gómez on 10/20/17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import UIKit

typealias OpenWithTutorialStep = (title: String, subtitle: String, image: UIImage?)

final public class OpenWithTutorialViewController: UICollectionViewController {
    let cellIdentifier = "cellIdentifier"
    let headerIdentifier = "headerIdentifier"
    
    lazy private(set) var items: [OpenWithTutorialStep] = [
        (NSLocalizedString("ginivision.help.openWithTutorial.step1.title", bundle: Bundle(for: GiniVision.self), comment: "first step title for open with tutorial"),
         NSLocalizedString("ginivision.help.openWithTutorial.step1.subTitle", bundle: Bundle(for: GiniVision.self), comment: "first step subtitle for open with tutorial"),
         UIImageNamedPreferred(named: "openWithTutorialStep1")),
        (NSLocalizedString("ginivision.help.openWithTutorial.step2.title", bundle: Bundle(for: GiniVision.self), comment: "second step title for open with tutorial"),
         String(format: NSLocalizedString("ginivision.help.openWithTutorial.step2.subTitle", bundle: Bundle(for: GiniVision.self), comment: "second step subtitle for open with tutorial"), Bundle.main.appName, Bundle.main.appName),
            UIImageNamedPreferred(named: "openWithTutorialStep2")),
        (NSLocalizedString("ginivision.help.openWithTutorial.step3.title", bundle: Bundle(for: GiniVision.self), comment: "third step title for open with tutorial"),
         String(format: NSLocalizedString("ginivision.help.openWithTutorial.step3.subTitle", bundle: Bundle(for: GiniVision.self), comment: "third step subtitle for open with tutorial"), Bundle.main.appName, Bundle.main.appName, Bundle.main.appName),
            UIImageNamedPreferred(named: "openWithTutorialStep3"))
    ]
    
    lazy var headerTitle: String = {
        let localizedString = NSLocalizedString("ginivision.help.openWithTutorial.collectionHeader", bundle: Bundle(for: GiniVision.self), comment: "intoduction header for further steps")
        return String(format: localizedString, Bundle.main.appName)
    }()
    
    fileprivate var stepsCollectionLayout: OpenWithTutorialCollectionFlowLayout {
        return self.collectionView?.collectionViewLayout as! OpenWithTutorialCollectionFlowLayout
    }
    
    public init() {
        super.init(collectionViewLayout: OpenWithTutorialCollectionFlowLayout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init() should be called instead")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ginivision.help.openWithTutorial.title", bundle: Bundle(for: GiniVision.self), comment: "title shown when the view controller is within a view controller")
        self.view.backgroundColor = Colors.Gini.pearl
        self.collectionView!.backgroundColor = nil
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false

        self.collectionView!.register(OpenWithTutorialCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView!.register(OpenWithTutorialCollectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        stepsCollectionLayout.minimumLineSpacing = 1
        stepsCollectionLayout.minimumInteritemSpacing = 1
        stepsCollectionLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        stepsCollectionLayout.estimatedItemSize = estimatedCellSize(widthParentSize: view.frame.size)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.stepsCollectionLayout.estimatedItemSize = self.estimatedCellSize(widthParentSize: size)
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }
    
    private func estimatedCellSize(widthParentSize size: CGSize) -> CGSize {
        if size.width > size.height && UIDevice.current.isIpad {
            let width:CGFloat = round(UIScreen.main.bounds.width / CGFloat(self.items.count) - CGFloat(self.stepsCollectionLayout.minimumInteritemSpacing * CGFloat(self.items.count - 1)))
            return CGSize(width: width, height: UIScreen.main.bounds.height)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 550)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OpenWithTutorialCollectionCell
        cell.fillWith(item: items[indexPath.row], at: indexPath.row)
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! OpenWithTutorialCollectionHeader
        header.headerTitle.text = headerTitle
        return header
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension OpenWithTutorialViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = collectionView.frame.width > collectionView.frame.height ? 0 : 130
        
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
