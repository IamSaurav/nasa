//
//  ViewController.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import UIKit
import Foundation
import WebKit
import CoreGraphics

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favouriteBgView: UIView!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    lazy var webView = WKWebView()
    let datePicker = UIDatePicker()
    var viewModel: PlanatoryPodManagable?
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    func setupUI() {
        // To select pickture of the day for a Date
        setupDatePicker()
        // To show loading indocator while downloading image
        setupActivityIndicator()
        // Show/Hide controls based on tap on image view
        addTapGestureRecognizer()
    }
    
    func setupDatePicker() {
        dateTextField.text = selectedDate.toString()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDoneButtonTap))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.onCancelButtonTap))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        dateTextField.tintColor = .clear
        dateTextField.layer.cornerRadius = 5
        dateTextField.layer.masksToBounds = true
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.isUserInteractionEnabled = true
        iconView.tintColor = .systemTeal
        iconView.image = UIImage.init(systemName: "arrow.down.circle")
        let iconContainerView: UIView = UIView(frame:CGRect(x: 10, y: 0, width: 30, height: 30))
        dateTextField.delegate = self
        iconContainerView.addSubview(iconView)
        dateTextField.leftView = iconContainerView
        dateTextField.leftViewMode = .always
    }
    
    func setupActivityIndicator() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func addTapGestureRecognizer() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            self.toggleControls(fadeOut: true)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        self.view.addGestureRecognizer(gesture)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
    
    @objc func onDoneButtonTap() {
        selectedDate = datePicker.date
        dateTextField.text = selectedDate.toString()
        self.view.endEditing(true)
        setupViewModel()
    }
    
    @objc func onCancelButtonTap() {
        self.view.endEditing(true)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        toggleControls(fadeOut: !self.favouriteButton.isHidden)
    }
    
    func setupViewModel() {
        viewModel = PlanatoryPodViewModel()
        spinner.startAnimating()
        viewModel?.getPictureOfDay(date: selectedDate.toString(), successful: { _ in
            self.populateData()
        }, failed: { errorMessage in
            self.spinner.stopAnimating()
            self.alert(message: errorMessage)
        })
    }
    
    func populateData() {
        self.titleLabel.text = viewModel?.plantoryPod.title
        self.explanationLabel.text = viewModel?.plantoryPod.explanation
        self.updateFavouriteButtonState()
        if viewModel?.plantoryPod.media_type == "video" {
            guard let urlString = viewModel?.plantoryPod.url, let url = URL.init(string: urlString) else {return}
            webView.frame = CGRect.init(x: 0, y: 120, width: view.bounds.width, height: view.bounds.height/2)
            view.addSubview(webView)
            imageView.isHidden = true
            webView.isHidden = false
            webView.load(URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20))
            self.spinner.stopAnimating()
        }else {
            webView.isHidden = true
            imageView.isHidden = false
            guard let urlString = viewModel?.plantoryPod.url, let url = NSURL(string: urlString) else { return }
            ImageCache.shared.load(url: url) { url, image in
                self.imageView.image = image
                self.spinner.stopAnimating()
            }
        }
    }
    
    func toggleControls(fadeOut: Bool) {
        if fadeOut {
            self.favouriteBgView.fadeOut()
            self.dateTextField.fadeOut()
            self.titleLabel.fadeOut()
            self.favouriteButton.fadeOut()
            self.explanationLabel.fadeOut()
        }else{
            self.favouriteBgView.fadeIn()
            self.dateTextField.fadeIn()
            self.titleLabel.fadeIn()
            self.favouriteButton.fadeIn()
            self.explanationLabel.fadeIn()
        }
    }
    
    @IBAction func onFavouriteButtonTap(_ sender: UIButton) {
        let isFavourite = viewModel?.plantoryPod.isFavourite == true
        viewModel?.plantoryPod.isFavourite = !isFavourite
        updateFavouriteButtonState()
        if let pod = viewModel?.plantoryPod {
            viewModel?.updatePod(pod: pod)
        }
    }
    
    func updateFavouriteButtonState() {
        let image = viewModel?.plantoryPod.isFavourite == true ? "heart.fill" : "heart"
        favouriteButton.setImage(UIImage.init(systemName: image), for: .normal)
    }
    
    @IBAction func onFavouriteListButtonTap() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        let favViewController = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        favViewController.viewModel = FavouritesViewModel()
        let navController = UINavigationController()
        navController.setViewControllers([favViewController], animated: true)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true)
        favViewController.showFavouritePod = { pod in
            self.toggleControls(fadeOut: false)
            self.selectedDate = self.toDate(date: pod.date)
            self.viewModel?.plantoryPod = pod
            self.populateData()
        }
    }
    
    func toDate(date: String?) -> Date {
        guard let date = date else { return Date() }
        let dateformatter = DateFormatter()
        dateformatter.timeZone = .init(identifier: "UTC")
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.date(from: date) ?? Date()
    }
    
    func alert(message: String) {
        let alertController = UIAlertController.init(title: "NASA", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}


extension UIView {
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 1, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
}
