import UIKit
import SnapKit
import SwiftyButton

class MapSelectorViewController : UIViewController {
    var mapContainer: UIView!
    var map1Button: FlatButton!
    var map2Button: FlatButton!
    var map3Button: FlatButton!
    var backButton: PressableButton!
    
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
        
    }
}
