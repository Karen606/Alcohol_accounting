//
//  SettingsViewController.swift
//  Alcohol_accounting
//
//  Created by Karen Khachatryan on 04.11.24.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var darkModeSwith: BaseSwitch!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var notificationsSwitch: BaseSwitch!
    @IBOutlet var settingsButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        darkModeSwith.layer.cornerRadius = darkModeSwith.frame.height / 2
        notificationsSwitch.layer.cornerRadius = notificationsSwitch.frame.height / 2
        titleLabels.forEach({ $0.font = .montserratMedium(size: 22) })
        settingsButton.forEach({ $0.titleLabel?.font = .montserratSemiBold(size: 22) })
        darkModeSwith.isOn = false
        notificationsSwitch.isOn = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        darkModeSwith.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        notificationsSwitch.isOn = NotificationManager.shared.isNotificationEnabled()
    }
    
    @IBAction func clickedDarkModel(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }
    
    @IBAction func clickedNotifications(_ sender: BaseSwitch) {
        if sender.isOn {
            NotificationManager.shared.requestNotificationPermission(completion: { granted in
                sender.isOn = granted
                sender.setOn(granted, animated: true)
                UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
            })
        } else {
            print("Notifications disabled")
            sender.isOn = false
            UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
        }
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
