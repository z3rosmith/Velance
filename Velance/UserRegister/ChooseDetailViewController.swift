//
//  ChooseDetailViewController.swift
//  Velance
//
//  Created by Kevin Kim on 2021/09/11.
//

import UIKit

class ChooseDetailViewController: UIViewController {
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet var genderButtons: [UIButton]!
    
    private var selectedGenderIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func pressedPreviousButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func heightSliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        heightLabel.text = String(value) + "cm"
    }
    
    @IBAction func weightSliderValueChange(_ sender: UISlider) {
        let value = Int(sender.value)
        weightLabel.text = String(value) + "kg"
        
    }
    
    @IBAction func pressedGenderButton(_ sender: UIButton) {
        
        genderButtons[selectedGenderIndex].backgroundColor = UIColor(named: Color.appTintColor)
        selectedGenderIndex = sender.tag
        genderButtons[selectedGenderIndex].backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7254901961, blue: 0.2235294118, alpha: 1)
        
    }
    
}

//MARK: - UI Configuration

extension ChooseDetailViewController {
    
    private func configure() {
        
        configureGenderButtons()
    }
    
    private func configureGenderButtons() {
        
        genderButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
}
