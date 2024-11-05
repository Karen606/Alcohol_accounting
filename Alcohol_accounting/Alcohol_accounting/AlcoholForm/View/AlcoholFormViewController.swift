//
//  AlcoholFormViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 04.11.24.
//

import UIKit
import Combine
import DropDown

class AlcoholFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var volumeTextField: BasePriceTextField!
    @IBOutlet weak var quantityTextField: BaseTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var typeBgView: UIView!
    @IBOutlet weak var contentView: ShadowView!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    private let viewModel = AlcoholFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let typeDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        titleLabels.forEach({ $0.font = .poppinsRegular(size: 10) })
        cancelButton.titleLabel?.font = .montserratMedium(size: 15)
        saveButton.titleLabel?.font = .montserratSemiBold(size: 15)
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.baseDark.cgColor
        typeButton.layer.cornerRadius = 6
        typeButton.layer.borderWidth = 1
        typeButton.layer.borderColor = UIColor.border.cgColor
        typeButton.titleLabel?.font = .poppinsRegular(size: 16)
        nameTextField.delegate = self
        volumeTextField.baseDelegate = self
        quantityTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setBlackNavigationColor()
    }
    
    func subscribe() {
        viewModel.$alcoholModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alcoholModel in
                guard let self = self else { return }
                self.saveButton.isEnabled = (alcoholModel.name.checkValidation() && alcoholModel.quantity != nil && alcoholModel.type.checkValidation() && alcoholModel.volume != nil)
            }
            .store(in: &cancellables)
        
        viewModel.$alcoholTypes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] types in
                guard let self = self else { return }
                self.typeDropDown.dataSource = types
            }
            .store(in: &cancellables)
    }
    
    func setupDropDown() {
        typeDropDown.backgroundColor = .white
        typeDropDown.dataSource = [""]
        typeDropDown.anchorView = stackView
        typeDropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .montserratMedium(size: 16) ?? .systemFont(ofSize: 16)
        typeDropDown.addShadow()
        
        typeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.typeButton.setTitle(item, for: .normal)
            self.viewModel.alcoholModel.type = item
        }
    }
    
    override func viewDidLayoutSubviews() {
        typeDropDown.width = typeButton.bounds.width
        typeDropDown.bottomOffset = CGPoint(x: typeBgView.frame.minX, y: typeBgView.frame.maxY + 2)
    }
    
    func clear() {
        viewModel.clear()
        nameTextField.text = nil
        volumeTextField.text = nil
        quantityTextField.text = nil
        typeButton.setTitle(nil, for: .normal)
    }

    @IBAction func chooseType(_ sender: UIButton) {
        typeDropDown.show()
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.clear()
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.clear()
            }
        }
    }
    
    deinit {
        clear()
    }
}


extension AlcoholFormViewController: UITextFieldDelegate, PriceTextFielddDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.alcoholModel.name = textField.text
        case volumeTextField:
            viewModel.alcoholModel.volume = Double(textField.text ?? "")
        case quantityTextField:
            viewModel.alcoholModel.quantity = Int(textField.text ?? "")
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == volumeTextField {
            return volumeTextField.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        } else if textField == quantityTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
