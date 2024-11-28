//
//  BottomSheetViewController.swift
//  MOA
//
//  Created by 오원석 on 11/9/24.
//

import UIKit
import SnapKit

final class BottomSheetViewController: BaseViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    var delegate: BottomSheetDelegate?
    private let sheetType: BottomSheetType
    private var sortType: SortType?
    private var date: Date = Date()
    
    init(
        sheetType: BottomSheetType,
        sortType: SortType? = nil,
        date: Date = Date()
    ) {
        self.sheetType = sheetType
        self.sortType = sortType
        self.date = date
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        startAnimation()
    }
}

private extension BottomSheetViewController {
    func setupLayout() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        switch sheetType {
        case .Sort:
            setupSortBottomSheet()
        case .Date:
            setupDateBottomSheet()
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(sheetType.rawValue)
            $0.bottom.equalToSuperview().offset(sheetType.rawValue)
        }
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        view.addGestureRecognizer(dismissTapGesture)
    }
    
    func setupSortBottomSheet() {
        let sheetView = SortBottomSheetView(type: sortType ?? .EXPIRE_DATE)
        contentView.addSubview(sheetView)
        
        sheetView.sortType
            .emit(onNext: { [weak self] type in
                self?.delegate?.selectSortType(type: type)
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupDateBottomSheet() {
        let sheetView = ExpireDateSheetView(date: date)
        contentView.addSubview(sheetView)
        
        sheetView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let date = sheetView.datePicker.date
                self?.delegate?.selectDate(date: date)
            }).disposed(by: disposeBag)
    }
    
    // TODO : 추후 애니메이션 정상 동작하도록 변경
    func startAnimation() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut]
        ) { [weak self] in
            guard let self = self else {
                MOALogger.loge()
                return
            }
            contentView.snp.updateConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(self.sheetType.rawValue)
                $0.bottom.equalToSuperview().offset(0)
            }
            contentView.layoutIfNeeded()
        }
    }
}

extension BottomSheetViewController {
    @objc func tapDismiss() {
        MOALogger.logd()
        dismiss(animated: true)
    }
}
