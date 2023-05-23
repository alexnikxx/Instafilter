//
//  FilterImageViewController.swift
//  Instafilter
//
//  Created by Aleksandra Nikiforova on 22/03/23.
//

import CoreImage
import UIKit

class FilterImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    private let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let image: UIImageView = {
        let image = UIImage(named: "")
        let img = UIImageView(image: image)
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let intensityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Intensity: "
        lbl.textColor = UIColor.tintColor
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let slider: UISlider = {
        let sldr = UISlider()
        sldr.tintColor = UIColor.tintColor
        
        sldr.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        
        sldr.translatesAutoresizingMaskIntoConstraints = false
        return sldr
    }()
    
    private let filterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Change filter", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "ButtonGreen")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 5
        btn.configuration = .borderless()
        
        btn.addTarget(self, action: #selector(changeFilter(_:)), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "ButtonGreen")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 5
        btn.configuration = .borderless()
                
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)

        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PhotoEditor"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        view.backgroundColor = UIColor(named: "BackColor")
        setupConstraints()
    }
    
    private func setupConstraints() {
        filterView.addSubview(image)
        view.addSubview(filterView)
        
        let viewIntensity = UIView()
        viewIntensity.translatesAutoresizingMaskIntoConstraints = false
        viewIntensity.addSubview(intensityLabel)
        viewIntensity.addSubview(slider)
        view.addSubview(viewIntensity)
        
        let viewButtons = UIView()
        viewButtons.translatesAutoresizingMaskIntoConstraints = false
        viewButtons.addSubview(filterButton)
        viewButtons.addSubview(saveButton)
        view.addSubview(viewButtons)
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterView.bottomAnchor.constraint(equalTo: viewIntensity.topAnchor, constant: -16),
            
            image.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 8),
            image.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 8),
            image.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -8),
            image.bottomAnchor.constraint(equalTo: filterView.bottomAnchor, constant: -8),
            
            viewIntensity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewIntensity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewIntensity.bottomAnchor.constraint(equalTo: viewButtons.topAnchor, constant: -16),

            intensityLabel.topAnchor.constraint(equalTo: viewIntensity.topAnchor),
            intensityLabel.leadingAnchor.constraint(equalTo: viewIntensity.leadingAnchor),
            intensityLabel.trailingAnchor.constraint(equalTo: slider.leadingAnchor, constant: -16),
            intensityLabel.bottomAnchor.constraint(equalTo: viewIntensity.bottomAnchor),
            
            slider.topAnchor.constraint(equalTo: viewIntensity.topAnchor),
            slider.trailingAnchor.constraint(equalTo: viewIntensity.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: viewIntensity.bottomAnchor),
            
            viewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            filterButton.topAnchor.constraint(equalTo: viewButtons.topAnchor),
            filterButton.leadingAnchor.constraint(equalTo: viewButtons.leadingAnchor),
            filterButton.bottomAnchor.constraint(equalTo: viewButtons.bottomAnchor),

            saveButton.topAnchor.constraint(equalTo: viewButtons.topAnchor),
            saveButton.leadingAnchor.constraint(greaterThanOrEqualTo: filterButton.trailingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: viewButtons.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: viewButtons.bottomAnchor)
        ])
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @objc func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: setFilter))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    @objc func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func save() {
        guard let image = image.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func intensityChanged() {
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(slider.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(slider.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(slider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            image.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

