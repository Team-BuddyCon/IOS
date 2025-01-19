//
//  MapBottomView.swift
//  MOA
//
//  Created by 오원석 on 1/17/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

enum BottomSheetState {
    case Collapsed
    case PartiallyExpanded
    case Expanded
    
    var height: Double {
        switch self {
        case .Collapsed:
            return Double(UIScreen.main.bounds.height) / 852.0 * 116.0
        case .PartiallyExpanded:
            return Double(UIScreen.main.bounds.height) / 852.0 * 201.0
        case .Expanded:
            return Double(UIScreen.main.bounds.height) - UIApplication.shared.topBarHeight - UIApplication.shared.safeAreaTopHeight - 64.0
        }
    }
}

final class MapBottomSheet: UIView {
    var state: BehaviorRelay<BottomSheetState> = BehaviorRelay(value: BottomSheetState.Collapsed)
    var sheetHeight: BehaviorRelay<Double> = BehaviorRelay(value: BottomSheetState.Collapsed.height)
    var isDrag: Bool = false
    
    var gifticonCount: Int = 0 {
        didSet {
            countLabel.text = String(format: MAP_BOTTOM_SHEET_GIFTICON_COUNT_FORMAT, gifticonCount)
        }
    }
    
    var imminentCount: Int = 0 {
        didSet {
            imminentCountLabel.text = String(format: MAP_BOTTOM_SHEET_IMMINENT_GIFTICON_COUNT_FORMAT, imminentCount)
        }
    }
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey40
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: pretendard_bold, size: 16.0)
        label.textColor = .grey90
        label.text = MAP_BOTTOM_SHEET_TITLE
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: pretendard_bold, size: 24.0)
        label.textColor = .grey90
        return label
    }()
    
    private let imminentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: pretendard_bold, size: 12.0)
        label.textColor = .pink100
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ALL_STORE))
        return imageView
    }()
    
    let panGesture: UIPanGestureRecognizer
    
    init(state: BottomSheetState = .Collapsed) {
        self.panGesture = UIPanGestureRecognizer()
        self.state.accept(state)
        super.init(frame: .zero)
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 24
        backgroundColor = .white
        
        [
            lineView,
            titleLabel,
            countLabel,
            imminentCountLabel,
            iconImageView
        ].forEach {
            addSubview($0)
        }
        
        lineView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(4)
            $0.width.equalTo(32)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.top).inset(4)
            $0.leading.equalToSuperview().inset(15)
            $0.bottom.equalTo(countLabel.snp.top)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(15)
            $0.bottom.equalTo(iconImageView.snp.bottom).inset(4)
        }
        
        imminentCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(countLabel.snp.bottom).inset(4)
            $0.leading.equalTo(countLabel.snp.trailing).offset(8)
        }
    }
    
    private func bind() {
        addGestureRecognizer(panGesture)
    }
    
    func setSheetHeight(offset: Double) {
        isDrag = true
        let height = sheetHeight.value
        if height < BottomSheetState.Expanded.height + 16.0 && height > 0 {
            sheetHeight.accept(height - offset)
        }
    }
    
    func endSheetGesture(offset: Double) {
        let height = sheetHeight.value
        var currentState = BottomSheetState.Collapsed
        if height > BottomSheetState.Expanded.height {
            currentState = BottomSheetState.Expanded
        } else if height > BottomSheetState.PartiallyExpanded.height {
            currentState = BottomSheetState.PartiallyExpanded
        } else {
            currentState = BottomSheetState.Collapsed
        }
        
        switch currentState {
        case .Collapsed:
            if height < BottomSheetState.Collapsed.height {
                currentState = .Collapsed
            } else {
                if offset < 0 {
                    currentState = .PartiallyExpanded
                }
            }
        case .PartiallyExpanded:
            if offset > 0 {
                currentState = .PartiallyExpanded
            } else {
                currentState = .Expanded
            }
        default:
            break
        }
        
        sheetHeight.accept(currentState.height)
        state.accept(currentState)
    }
}

extension Reactive where Base: MapBottomSheet {
    var bindToStoreType: Binder<StoreType> {
        return Binder<StoreType>(self.base) { sheet, storeType in
            if storeType == .ALL || storeType == .OTHERS {
                sheet.iconImageView.image = UIImage(named: ALL_STORE)
            } else {
                sheet.iconImageView.image = storeType.image
            }
        }
    }
}
