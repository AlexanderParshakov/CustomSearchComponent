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
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var breadcrumbsView: BreadCrumbsView!
    
    @IBAction func onClearClick(_ sender: UIButton) {
        
        for (index, view) in breadcrumbsView.crumbViews.enumerated() {
            if index > 0 {
                guard let currentTitle = view.currentTitle else { return }
                breadcrumbsView.removeCrumb(currentTitle)
            }
        }
    }
    @IBAction func didEndOnExit(_ sender: Any) {
        shrinkAndLoad()
    }
    
    var searchBarTrailingConstraint = NSLayoutConstraint()
    var isSearchBarOpen: Bool = false
    var previousSearch: String = ""
    var hasSearchChanged: Bool {
        return previousSearch != searchBar.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // некоторые команды состоят из одной строки, что чуть медленнее, чем при прямой их записи, но это сделано для дальнейшего расширения (на практике его не будет, но в теории -- думаю, что полезно)
        setupVisibility()
        setupConstraints()
        setupTapRecognizers()
        setupBreadcrumbs()
    }
    func setupVisibility() {
        animationView.isHidden = true
    }
    func setupConstraints() {
        searchBarTrailingConstraint = NSLayoutConstraint(item: self.searchBar!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10)
    }
    func setupTapRecognizers() {
        searchBar.addTarget(self, action: #selector(extendSearchBar), for: .editingDidBegin)
        
        let leftViewTap = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        searchBar.leftView?.addGestureRecognizer(leftViewTap)
        
        let rightViewTap = UITapGestureRecognizer(target: self, action: #selector(extendSearchBar))
        searchBar.rightView?.addGestureRecognizer(rightViewTap)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(shrinkAndLoadWithoutBarAnimation))
        view.addGestureRecognizer(viewTap)
    }
    func setupBreadcrumbs() {
        breadcrumbsView.textFont = UIFont.systemFont(ofSize: 13)
        breadcrumbsView.addCrumb("Приготовление")
        breadcrumbsView.addCrumb("Посуда для чая и кофе")
        breadcrumbsView.addCrumb("Чайники")
        breadcrumbsView.delegate = self
    }
}


// MARK: - Search Bar handles
extension SearchComponentVC: UITextFieldDelegate {
    
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
            }
            prepareToShrink()
            UIView.animate(withDuration: Constants.UISettings.searchBarAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - retrieving data
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
                    self?.previousSearch = (self?.searchBar.text)!
                
                case .failure(let error):
                    print("Error: ", error)
            }
        }
    }
}

// MARK: - correcting UI
extension SearchComponentVC {
    
    func prepareToShrink() {
        self.searchBar.placeholder?.removeAll()
        self.view.removeConstraint(searchBarTrailingConstraint)
        if searchBar.text?.count == 0 {
            searchBar.rightViewMode = .never
        }
        else {
            searchBar.rightViewMode = .always
        }
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


// MARK: - breadcrumbs
extension SearchComponentVC: CrumbListViewDelegate {
    
    func crumbPressed(_ title: String, crumbView: CrumbView, sender: BreadCrumbsView) {
        var cutIndex: Int = breadcrumbsView.crumbViews.count + 1
        
        for (index, view) in breadcrumbsView.crumbViews.enumerated() {
            if view == crumbView {
                cutIndex = index
            }
            if index > cutIndex {
                guard let currentTitle = view.currentTitle else { return }
                breadcrumbsView.removeCrumb(currentTitle)
            }
        }
    }
}
