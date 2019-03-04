import UIKit
import SnapKit
import SwiftyButton

class MapSelectorViewController : UIViewController {
    var playerCount: Int!
    
    var mapContainer: UIView!
    var map1Button: FlatButton!
    var map2Button: FlatButton!
    var map3Button: FlatButton!
    var backButton: PressableButton!
    
    var constraintRelativeToHeight: Constraint!
    var constraintRelativeToWidth: Constraint!
    
    override func viewDidLoad() {
        mapContainer = UIView(frame: .zero)
        view.addSubview(mapContainer)
        mapContainer.backgroundColor = .black
        mapContainer.snp.makeConstraints { (make) in
            make.height.equalTo(mapContainer.snp.width)
            make.left.greaterThanOrEqualToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.top.greaterThanOrEqualToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8).priority(.high)
            make.right.equalToSuperview().offset(-8).priority(.high)
            make.top.equalToSuperview().offset(8).priority(.high)
            make.bottom.equalToSuperview().offset(-8).priority(.high)
            make.center.equalToSuperview()
        }
        
        map1Button = FlatButton(frame: .zero)
        mapContainer.addSubview(map1Button)
        map1Button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2).offset(-16)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
            make.top.equalToSuperview().offset(8)
        }
        map1Button.addTarget(self, action: #selector(map1ButtonPress), for: .touchUpInside)
        map1Button.setImage(UIImage(named: "map6"), for: .normal)
        map1Button.contentMode = .scaleAspectFit
        
        map2Button = FlatButton(frame: .zero)
        mapContainer.addSubview(map2Button)
        map2Button.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(2).offset(-16)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
            make.top.equalTo(map1Button.snp.bottom).offset(8)
            make.left.equalTo(8)
        }
        map2Button.addTarget(self, action: #selector(map2ButtonPress), for: .touchUpInside)
        
        map3Button = FlatButton(frame: .zero)
        mapContainer.addSubview(map3Button)
        map3Button.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(2).offset(-16)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
            make.top.equalTo(map1Button.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        map3Button.addTarget(self, action: #selector(map3ButtonPress), for: .touchUpInside)
        
        backButton = PressableButton(frame: .zero)
        view.addSubview(backButton)
        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(24)
            make.left.equalTo(8)
            make.width.equalTo(UIScreen.main.nativeBounds.width / UIScreen.main.nativeScale / 5)
            make.height.equalTo(backButton.snp.width).dividedBy(1.5)
        }
        
//        updateBackButtonConstraints()
    }
    
    @objc func backButtonPress() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func map1ButtonPress() {
        showGame(map: 6)
    }
    
    @objc func map2ButtonPress() {
        showGame(map: 7)
    }
    
    @objc func map3ButtonPress() {
        showGame(map: 5)
    }
    
    func showGame(map: Int) {
        if playerCount == 1 {
            performSegue(withIdentifier: "showAIGame", sender: map)
        } else {
            performSegue(withIdentifier: "show2PlayerGame", sender: map)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameViewControllerBase, let map = sender as? Int {
            vc.boardSize = map
        }
    }
    
    override func viewDidLayoutSubviews() {
        backButton.updateTitleOffsets()
        backButton.titleLabel?.updateFontSizeToFit(size: backButton.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] (_) in
            self.backButton.updateTitleOffsets()
            self.backButton.titleLabel?.updateFontSizeToFit(size: self.backButton.bounds.size)
        }, completion: nil)
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        if view.bounds.width < view.bounds.height {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
        } else {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)])
        }
    }
}
