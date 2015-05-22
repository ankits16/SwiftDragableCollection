//
//  ViewController.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/19/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DECollectionViewDatasource, DECollectionViewDelegate {

    @IBOutlet weak var collectionView: DragableCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.dragEnableCollectionDatasource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK:- Dragable collection view data source
    
    func optionsArrayforCollectionView() -> NSArray {
        var tempOptionsArr =  NSMutableArray()
        
        for (var i = 1; i<=15; i++){
            let anOption = Option()
            anOption.optionImage = UIImage(named: "\(i).jpg")
            anOption.optionTitle = "\(i)"
            tempOptionsArr.addObject(anOption)
        }
        
        return NSArray(array: tempOptionsArr)
    }
    
    // MARK:- Dragable collection view delegate
    
    func beginEditing(collectionView: DragableCollectionView?, gestureRecognizer: UILongPressGestureRecognizer?) {
        
    }

}

