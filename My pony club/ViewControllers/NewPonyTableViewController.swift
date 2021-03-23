//
//  NewPonyTableViewController.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 21.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit

class NewPonyTableViewController: UITableViewController {
    
    var currentPony: Pony?
    var imageIsChanged = false
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var ponyImage: UIImageView!
    @IBOutlet var ponyName: UITextField!
    @IBOutlet var ponyLocation: UITextField!
    @IBOutlet var ponyType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        ponyName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    // MARK: Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
             
            let photo = UIAlertAction(title: "Photo", style: .default) {_ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    func savePony() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = ponyImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPony = Pony(name: ponyName.text!,
                           location: ponyLocation.text!,
                           type: ponyType.text!,
                           imageData: imageData)
        if currentPony != nil {
            try! realm.write {
                currentPony?.name = newPony.name
                currentPony?.location = newPony.location
                currentPony?.type = newPony.type
                currentPony?.imageData = newPony.imageData
            }
        } else {
            StorageManager.saveObject(newPony)
        }
    }
    
    private func setupEditScreen() {
        if currentPony != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPony?.imageData, let image = UIImage(data: data) else { return }
            
            ponyImage.image = image
            ponyImage.contentMode = .scaleAspectFill
            ponyName.text = currentPony?.name
            ponyLocation.text = currentPony?.location
            ponyType.text = currentPony?.type
        }
    }
    
    private func setupNavigationBar() {
        if let topIteam =  navigationController?.navigationBar.topItem {
            topIteam.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPony?.name
        saveButton.isEnabled = true
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
// MARK:  Text field delegate
extension NewPonyTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по тапу
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if ponyName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
// MARK: Work with image

extension NewPonyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
            
            
            
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        ponyImage.image = info[.editedImage] as? UIImage
        ponyImage.contentMode = .scaleToFill
        ponyImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
