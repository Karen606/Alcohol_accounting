//
//  CorrectionViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 05.11.24.
//

import UIKit

class CorrectionViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var typeTextField: BaseTextField!
    @IBOutlet weak var nameTextField: BasePriceTextField!
    @IBOutlet weak var quantityTextField: BaseTextField!
    @IBOutlet weak var saveButton: BaseButton!
    private let viewModel = CorrectionViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        self.setNaviagtionCloseButton()
        setNavigationTitle(title: "Stock correction")
        titleLabels.forEach({ $0.font = .poppinsRegular(size: 10) })
        saveButton.titleLabel?.font = .montserratSemiBold(size: 15)
        quantityTextField.delegate = self
        typeTextField.text = viewModel.alcoholModel?.type
        nameTextField.text = viewModel.alcoholModel?.name
        quantityTextField.text = "\(viewModel.alcoholModel?.quantity ?? 0)"
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func clickedApply(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension CorrectionViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.alcoholModel?.quantity = Int(textField.text ?? "")
        self.saveButton.isEnabled = textField.text.checkValidation()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
