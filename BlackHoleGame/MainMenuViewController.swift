import UIKit
import SnapKit
import SwiftyButton

class MainMenuViewController: UIViewController {
    @IBOutlet var buttonContainer: UIView!
    
    var onePlayerButton: PressableButton!
    var twoPlayerButton: PressableButton!
    var helpButton: PressableButton!
    var connectButton: PressableButton!
    
    override func viewDidLoad() {
        onePlayerButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(onePlayerButton)
        onePlayerButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4.5).offset(-8)
            make.width.lessThanOrEqualTo(onePlayerButton.snp.height).multipliedBy(5)
            make.left.equalToSuperview().offset(8).priority(.high)
            make.right.equalToSuperview().offset(-8).priority(.high)
        }
        onePlayerButton.setTitle("1 PLAYER", for: .normal)
        onePlayerButton.addTarget(self, action: #selector(onePlayerButtonPress), for: .touchUpInside)
        
        twoPlayerButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(twoPlayerButton)
        twoPlayerButton.snp.makeConstraints { (make) in
            make.height.equalTo(onePlayerButton.snp.height)
            make.width.equalTo(onePlayerButton.snp.width)
            make.centerX.equalTo(onePlayerButton.snp.centerX)
            make.top.equalTo(onePlayerButton.snp.bottom).offset(8)
        }
        twoPlayerButton.setTitle("2 PLAYERS", for: .normal)
        twoPlayerButton.addTarget(self, action: #selector(twoPlayerButtonPress), for: .touchUpInside)
        
        helpButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(helpButton)
        helpButton.snp.makeConstraints { (make) in
            make.height.equalTo(onePlayerButton.snp.height)
            make.width.equalTo(onePlayerButton.snp.width)
            make.centerX.equalTo(onePlayerButton.snp.centerX)
            make.top.equalTo(twoPlayerButton.snp.bottom).offset(8)
        }
        helpButton.setTitle("HELP", for: .normal)
        
        connectButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(connectButton)
        connectButton.snp.makeConstraints { (make) in
            make.height.equalTo(onePlayerButton.snp.height)
            make.width.equalTo(onePlayerButton.snp.width)
            make.centerX.equalTo(onePlayerButton.snp.centerX)
            make.top.equalTo(helpButton.snp.bottom).offset(8)
        }
        connectButton.setTitle("CONNECT", for: .normal)
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        if view.bounds.width < view.bounds.height {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
        } else {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)])
        }
    }
    
    override func viewDidLayoutSubviews() {
        onePlayerButton.titleLabel?.updateFontSizeToFit(size: onePlayerButton.bounds.size)
        twoPlayerButton.titleLabel?.updateFontSizeToFit(size: twoPlayerButton.bounds.size)
        helpButton.titleLabel?.updateFontSizeToFit(size: helpButton.bounds.size)
        connectButton.titleLabel?.updateFontSizeToFit(size: connectButton.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        onePlayerButton.titleLabel?.updateFontSizeToFit(size: onePlayerButton.bounds.size)
        twoPlayerButton.titleLabel?.updateFontSizeToFit(size: twoPlayerButton.bounds.size)
        helpButton.titleLabel?.updateFontSizeToFit(size: helpButton.bounds.size)
        connectButton.titleLabel?.updateFontSizeToFit(size: connectButton.bounds.size)
    }
    
    @objc func playButtonPress() {
        performSegue(withIdentifier: "showMapSelector", sender: self)
    }
    
    @IBAction func unwindFromGame(segue: UIStoryboardSegue) {
        
    }
}
