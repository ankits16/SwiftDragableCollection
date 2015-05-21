//
//  ViewController.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/19/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DECollectionViewDatasource, DECollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: DECollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView!.dragEnableCollectionDatasource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //#MARK: - drag enabled data source
    func optionsArrayForCollectionView(deCollectionView: DECollectionView!) -> NSMutableArray! {
        var optionsArry  = NSMutableArray()
        for (var i = 1; i<=15; i++){
            let optionTitle = "\(i)th image"
            let optionImage = UIImage(named: "\(i).jpg")
            let anOption = Option(title: optionTitle, anImage: optionImage)
            anOption.isPhantom = false
            optionsArry.addObject(anOption)
        }
        
        return NSMutableArray(array: optionsArry)
    }

}

