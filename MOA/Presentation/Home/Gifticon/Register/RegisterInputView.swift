//
//  RegisterInputView.swift
//  MOA
//
//  Created by 오원석 on 11/23/24.
//

import UIKit

enum InputType {
    case name
    case expireDate
    case store
    case memo
    
    var title: String {
        switch self {
        case .name: return GIFTICON_REGSITER_NAME_INPUT_TITLE
        case .expireDate: return GIFTICON_REGISTER_EXPIRE_DATE_INPUT_TITLE
        case .store: return GIFTICON_REGISTER_STORE_INPUT_TITLE
        case .memo: return GIFTICON_REGISTER_MEMO_INPUT_TITLE
        }
    }
    
    var hint: String {
        switch self {
        case .name: return GIFTICON_REGISTER_NAME_INPUT_HINT
        case .expireDate: return GIFTICON_REGISTER_EXPIRE_DATE_INPUT_HINT
        case .store: return GIFTICON_REGISTER_STORE_INPUT_HINT
        case .memo: return GIFTICON_REGISTER_MEMO_INPUT_HINT
        }
    }
    
    var isMandatory: Bool {
        self != .memo
    }
    
    var hasIcon: Bool {
        self == .expireDate || self == .store
    }
    
    var icon: UIImage? {
        switch self {
        case .expireDate: return UIImage(named: EXPIRE_DATE_INPUT_ICON)
        case .store: return UIImage(named: STORE_INPUT_ICON)
        default: return nil
        }
    }
}

final class RegisterInputView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: pretendard_medium, size: 13.0)
        label.textColor = .grey70
        return label
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: pretendard_medium, size: 15.0)
        label.textColor = .grey40
        label.text = inputType.hint
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: pretendard_bold, size: 15.0)
        label.textColor = .grey90
        label.isHidden = true
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = !inputType.hasIcon
        imageView.image = inputType.icon
        return imageView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey30
        return view
    }()
    
    private var inputType: InputType
    
    init(
        inputType: InputType
    ) {
        self.inputType = inputType
        super.init(frame: .zero)
        
        if inputType.isMandatory {
            titleLabel.setRangeFontColor(
                text: "\(inputType.title)*",
                startIndex: inputType.title.count,
                endIndex: inputType.title.count + 1,
                color: .pink100
            )
        } else {
            titleLabel.text = inputType.title
        }
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [titleLabel, hintLabel, inputLabel, iconView, lineView].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        hintLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        inputLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(hintLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(hintLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapInput))
        hintLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapInput() {
        MOALogger.logd("\(inputType.title)")
    }
}
