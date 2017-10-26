//
//  ViewController.swift
//  FlowerPower
//
//  Created by Ivan Matkovic on 25/10/2017.
//  Copyright © 2017 Ivan Matkovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - User Actions
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        self.openGallery()
    }
    
    var model: Flowers!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = Flowers()
    }
    
    // MARK: - Methods
    private func setup() {
        self.resultLabel.isHidden = true
        self.selectedImageView.image = #imageLiteral(resourceName: "open photos")
        self.selectImageButton.setTitle("", for: .normal)
    }
    
    private func openGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    private func recognizeFlower(_ data: CVPixelBuffer) -> String {
       
        guard let prediction = try? model.prediction(data: data) else {
            return "I don't know"
        }
        
        prediction.prob.printEachPair(.highToLow)
        
        return "I think that is \(prediction.classLabel)"
    }
    
}
// MARK: - Extensions
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Can't get image from controler")
            return
        }
        
        selectedImageView.image = image
        
        let data = image.scaleImage(newSize: CGSize(width: 227, height: 227))
        
        guard let buffer = data?.buffer() else {
            print("Can't get buffer from image")
            return
        }
        
        dismiss(animated: true) { [weak self] in
            self?.resultLabel.text = self?.recognizeFlower(buffer)
            self?.resultLabel.isHidden = false
        }
        
    }
}
