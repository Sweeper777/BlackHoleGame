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
        helpButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(helpButton)
        helpButton.snp.makeConstraints { (make) in
            make.height.equalTo(playButton.snp.height)
            make.width.equalTo(playButton.snp.width)
            make.centerX.equalTo(playButton.snp.centerX)
            make.top.equalTo(playButton.snp.bottom).offset(8)
        }
        connectButton = PressableButton(frame: .zero)
        buttonContainer.addSubview(connectButton)
        connectButton.snp.makeConstraints { (make) in
            make.height.equalTo(playButton.snp.height)
            make.width.equalTo(playButton.snp.width)
            make.centerX.equalTo(playButton.snp.centerX)
            make.top.equalTo(helpButton.snp.bottom).offset(8)
        }
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        if view.bounds.width < view.bounds.height {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
        } else {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playButton.titleLabel?.updateFontSizeToFit(size: playButton.bounds.size)
    }
}
