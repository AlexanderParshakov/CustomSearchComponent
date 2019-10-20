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

class SearchComponentVC: UIViewController {
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    @IBAction func didEndOnExit(_ sender: Any) {
        shrinkAndLoad()
    }
    
    var searchBarTrailingConstraint = NSLayoutConstraint()
    var isSearchBarOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupConstraints()
        setupTapRecognizers()
    }
    
    func setupScreen() {
        searchBar.addTarget(self, action: #selector(extendSearchBar), for: .editingDidBegin)
        animationView.isHidden = true
    }
    func setupConstraints() {
        searchBarTrailingConstraint = NSLayoutConstraint(item: self.searchBar!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10)
    }
    func setupTapRecognizers() {
        let leftViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        leftViewTapRecognizer.numberOfTapsRequired = 1
        searchBar.leftView?.addGestureRecognizer(leftViewTapRecognizer)
        let rightViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        rightViewTapRecognizer.numberOfTapsRequired = 1
        searchBar.rightView?.addGestureRecognizer(rightViewTapRecognizer)
        searchBar.rightView?.isUserInteractionEnabled = true
        let viewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(shrinkAndLoadWithoutBarAnimation))
        viewTapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(viewTapRecognizer)
    }
}


// searchBar management
extension SearchComponentVC {
    
    @objc func extendSearchBar() {
        self.searchBar.becomeFirstResponder()
        self.view.addConstraint(searchBarTrailingConstraint)
        self.searchBar.placeholder = Constants.searchBarPlaceholder
        UIView.animate(withDuration: Constants.animationDuration) {
            self.view.layoutIfNeeded()
        }
        isSearchBarOpen = true
    }
    @objc func shrinkAndLoadWithoutBarAnimation() {
        if isSearchBarOpen {
            loadData()
            clearSearchBar()
            searchBar.resignFirstResponder()
            searchBar.rightViewMode = .always
            self.view.layoutIfNeeded()
            isSearchBarOpen = false
        }
    }
    func shrinkAndLoad() {
        if isSearchBarOpen{
            loadData()
            clearSearchBar()
            searchBar.rightViewMode = .always
            UIView.animate(withDuration: Constants.animationDuration) {
                self.view.layoutIfNeeded()
            }
            isSearchBarOpen = false
        }
    }
}

// retrieving data
extension SearchComponentVC {
    
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

// correcting UI
extension SearchComponentVC {
    func clearSearchBar() {
        self.searchBar.placeholder?.removeAll()
        self.view.removeConstraint(searchBarTrailingConstraint)
    }
    func switchResultVisibility() {
        resultLabel.isHidden = !resultLabel.isHidden
        animationView.isHidden = !animationView.isHidden
    }
}



