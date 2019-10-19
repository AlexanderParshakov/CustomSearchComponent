//
//  ViewController.swift
//  SearchComponent
//
//  Created by Alexander Parshakov on 18.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    @IBAction func didEndOnExit(_ sender: Any) {
        shrinkAndLoad()
    }
    
    var searchBarTrailingConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupConstraints()
        setupTapRecognizers()
    }
    
    func setupScreen() {
        searchBar.addTarget(self, action: #selector(extendSearchBar), for: .allTouchEvents)
        animationView.isHidden = true
    }
    func setupConstraints() {
        searchBarTrailingConstraint = NSLayoutConstraint(item: self.searchBar!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10)
    }
    func setupTapRecognizers() {
        let viewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        viewTapRecognizer.numberOfTapsRequired = 1
        searchBar.leftView?.addGestureRecognizer(viewTapRecognizer)
        //        let viewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(shrinkAndLoadWithoutBarAnimation))
        //        viewTapRecognizer.numberOfTapsRequired = 1
        //        view.addGestureRecognizer(viewTapRecognizer)
    }
    @objc func extendSearchBar() {
        self.searchBar.becomeFirstResponder()
        self.view.addConstraint(searchBarTrailingConstraint)
        self.searchBar.placeholder = Constants.searchBarPlaceholder
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func shrinkAndLoadWithoutBarAnimation() {
        loadData()
        searchBar.resignFirstResponder()
        clearSearchBar()
        self.view.layoutIfNeeded()
    }
    func shrinkAndLoad() {
        loadData()
        clearSearchBar()
        addRightPadding()
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    func clearSearchBar() {
        self.searchBar.placeholder?.removeAll()
        self.view.removeConstraint(searchBarTrailingConstraint)
    }
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: searchBar.frame.height))
        searchBar.rightView = paddingView
        searchBar.rightViewMode = .unlessEditing
    }
    func switchResultVisibility() {
        resultLabel.isHidden = !resultLabel.isHidden
        animationView.isHidden = !animationView.isHidden
    }
    
}


extension ViewController {
    
    func loadData() {
        switchResultVisibility()
        AnimationHandler.startLottieAnimation(aniView: animationView)
        let params = ["SearchString": searchBar.text!]
        NetworkManager.getNumberOfItems(parameters: params) {
            [weak self] (result) in
            switch result {
                
            case .success(let data):
                self?.switchResultVisibility()
                self?.animationView.stop()
                self?.resultLabel.text = String(JSON(data)["data"]["listProducts"].count)
                
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    
}



