import UIKit
import SnapKit
import SwiftyButton

class MapSelectorViewController : UIViewController {
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
        
        map2Button = FlatButton(frame: .zero)
        mapContainer.addSubview(map2Button)
        map2Button.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(2).offset(-16)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
            make.top.equalTo(map1Button.snp.bottom).offset(8)
            make.left.equalTo(8)
        }
        
        map3Button = FlatButton(frame: .zero)
        mapContainer.addSubview(map3Button)
        map3Button.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(2).offset(-16)
            make.width.equalToSuperview().dividedBy(2).offset(-16)
            make.top.equalTo(map1Button.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        
        backButton = PressableButton(frame: .zero)
        view.addSubview(backButton)
        backButton.setTitle("BACK", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(8)
            make.height.equalTo(backButton.width).dividedBy(1.5)
            constraintRelativeToHeight = make.width.equalTo(view.snp.height).dividedBy(7).constraint
            constraintRelativeToWidth = make.width.equalTo(view.snp.width).dividedBy(7).constraint
        }
        
        updateBackButtonConstraints()
    }
    
    @objc func backButtonPress() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateBackButtonConstraints() {
        if traitCollection.horizontalSizeClass == .regular &&
            traitCollection.verticalSizeClass == .compact {
            constraintRelativeToWidth.deactivate()
            constraintRelativeToHeight.activate()
        } else {
            constraintRelativeToWidth.activate()
            constraintRelativeToHeight.deactivate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backButton.titleLabel?.updateFontSizeToFit(size: backButton.bounds.size)
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        if view.bounds.width < view.bounds.height {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
        } else {
            return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)])
    }
}
