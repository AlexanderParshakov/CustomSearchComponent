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
        if hasSearchChanged {
            shrinkAndLoad()
            previousSearch = searchBar.text!
        }
    }
    
    var searchBarTrailingConstraint = NSLayoutConstraint()
    var isSearchBarOpen: Bool = false
    var previousSearch: String = ""
    var hasSearchChanged: Bool {
        return previousSearch != searchBar.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisibility()
        setupConstraints()
        setupTapRecognizers()
    }
    
    func setupVisibility() {
        animationView.isHidden = true
    }
    func setupConstraints() {
        searchBarTrailingConstraint = NSLayoutConstraint(item: self.searchBar!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10)
    }
    func setupTapRecognizers() {
        searchBar.addTarget(self, action: #selector(extendSearchBar), for: .editingDidBegin)
        
        let leftViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        searchBar.leftView?.addGestureRecognizer(leftViewTapRecognizer)
        
        let rightViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        searchBar.rightView?.addGestureRecognizer(rightViewTapRecognizer)
        
        let viewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(shrinkAndLoadWithoutBarAnimation))
        view.addGestureRecognizer(viewTapRecognizer)
    }
}


// searchBar management
extension SearchComponentVC {
    
    @objc func extendSearchBar() {
        defer {
            isSearchBarOpen = true
        }
        self.searchBar.becomeFirstResponder()
        prepareToExtend()
        UIView.animate(withDuration: Constants.UISettings.searchBarAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func shrinkAndLoadWithoutBarAnimation() {
        if isSearchBarOpen {
            defer {
                isSearchBarOpen = false
            }
            if hasSearchChanged {
                loadData()
                previousSearch = searchBar.text!
            }
            prepareToShrink()
            searchBar.resignFirstResponder()
            self.view.layoutIfNeeded()
        }
    }
    func shrinkAndLoad() {
        if isSearchBarOpen {
            defer {
                isSearchBarOpen = false
            }
            if hasSearchChanged {
                loadData()
                previousSearch = searchBar.text!
            }
            prepareToShrink()
            UIView.animate(withDuration: Constants.UISettings.searchBarAnimationDuration) {
                self.view.layoutIfNeeded()
            }
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
    func prepareToShrink() {
        self.searchBar.placeholder?.removeAll()
        self.view.removeConstraint(searchBarTrailingConstraint)
        searchBar.rightViewMode = .always
    }
    func prepareToExtend() {
        self.view.addConstraint(searchBarTrailingConstraint)
        self.searchBar.placeholder = Constants.ControlLiterals.searchBarPlaceholder
    }
    func switchResultVisibility() {
        resultLabel.isHidden = !resultLabel.isHidden
        animationView.isHidden = !animationView.isHidden
    }
}



