import UIKit
import SnapKit
import SwiftyButton

class MainMenuViewController: UIViewController {
    @IBOutlet var buttonContainer: UIView!
    
    var playButton: PressableButton!
    var helpButton: PressableButton!
    var connectButton: PressableButton!
    
    override func viewDidLoad() {
        playButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4).offset(-8)
            make.width.lessThanOrEqualTo(playButton.snp.height).multipliedBy(5)
            make.left.equalToSuperview().offset(8).priority(.high)
            make.right.equalToSuperview().offset(-8).priority(.high)
        }
        playButton.setTitle("PLAY", for: .normal)
        playButton.addTarget(self, action: #selector(playButtonPress), for: .touchUpInside)
        
        helpButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(helpButton)
        helpButton.snp.makeConstraints { (make) in
            make.height.equalTo(playButton.snp.height)
            make.width.equalTo(playButton.snp.width)
            make.centerX.equalTo(playButton.snp.centerX)
            make.top.equalTo(playButton.snp.bottom).offset(8)
        }
        helpButton.setTitle("HELP", for: .normal)
        
        connectButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(connectButton)
        connectButton.snp.makeConstraints { (make) in
            make.height.equalTo(playButton.snp.height)
            make.width.equalTo(playButton.snp.width)
            make.centerX.equalTo(playButton.snp.centerX)
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
        playButton.titleLabel?.updateFontSizeToFit(size: playButton.bounds.size)
        helpButton.titleLabel?.updateFontSizeToFit(size: helpButton.bounds.size)
        connectButton.titleLabel?.updateFontSizeToFit(size: connectButton.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playButton.titleLabel?.updateFontSizeToFit(size: playButton.bounds.size)
        helpButton.titleLabel?.updateFontSizeToFit(size: helpButton.bounds.size)
        connectButton.titleLabel?.updateFontSizeToFit(size: connectButton.bounds.size)
    }
    
    @objc func playButtonPress() {
        performSegue(withIdentifier: "showMapSelector", sender: self)
    }
}
