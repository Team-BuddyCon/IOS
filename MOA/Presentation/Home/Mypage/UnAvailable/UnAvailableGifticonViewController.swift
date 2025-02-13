//
//  UnAvailableGifticonViewController.swift
//  MOA
//
//  Created by 오원석 on 1/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class UnAvailableGifticonViewController: BaseViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey90
        label.font = UIFont(name: pretendard_bold, size: 18.0)
        return label
    }()
    
    private lazy var gifticonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24.0
        layout.minimumInteritemSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        let width = Double(UIScreen.getWidthByDivision(division: 2, exclude: 56))
        layout.itemSize = CGSize(width: width, height: width * 234 / 159.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GifticonCell.self, forCellWithReuseIdentifier: GifticonCell.identifier)
        collectionView.register(GifticonSkeletonCell.self, forCellWithReuseIdentifier: GifticonSkeletonCell.identifier)
        return collectionView
    }()
    
    private var isFirstEntry = true
    let viewModel = UnAvailableGifticonViewModel(gifticonService: GifticonService.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MOALogger.logd()
        setupLayout()
        setupData()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MOALogger.logd()
        
        if !isFirstEntry {
            viewModel.refresh()
        }
        isFirstEntry = false
    }
}

private extension UnAvailableGifticonViewController {
    func setupLayout() {
        setupTopBarWithBackButton(title: UNAVAILABLE_GIFTIFON_TITLE)
        
        view.addSubview(titleLabel)
        view.addSubview(gifticonCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        gifticonCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupData() {
        viewModel.fetch()
        viewModel.fetchGifticonCount()
    }
    
    func bind() {
        viewModel.gifticons
            .bind(to: gifticonCollectionView.rx.items) { collectionView, row, gifticon in
                if gifticon.gifticonId == Int.min {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GifticonSkeletonCell.identifier,
                        for: IndexPath(row: row, section: 0)
                    ) as? GifticonSkeletonCell else {
                        return UICollectionViewCell()
                    }
                    return cell
                }
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifticonCell.identifier, for: IndexPath(row: row, section: 0)) as? GifticonCell else {
                    return UICollectionViewCell()
                }
                
                cell.setData(
                    dday: gifticon.expireDate.toDday(),
                    imageURL: gifticon.imageUrl,
                    storeType: gifticon.gifticonStore,
                    title: gifticon.name,
                    date: gifticon.expireDate,
                    used: true
                )
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.gifticons
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                gifticonCollectionView.reloadData()
                gifticonCollectionView.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        gifticonCollectionView.rx.contentOffset
            .map { _ in self.gifticonCollectionView }
            .bind(to: self.rx.scrollOffset)
            .disposed(by: disposeBag)
        
        gifticonCollectionView.rx.modelSelected(UnAvailableGifticon.self)
            .subscribe(onNext: { [weak self] gifticon in
                guard let self = self else { return }
                MOALogger.logd("\(gifticon.gifticonId)")
                
                let detailVC = GifticonDetailViewController(gifticonId: String(gifticon.gifticonId))
                navigationController?.pushViewController(detailVC, animated: true)
            }).disposed(by: disposeBag)
        
        viewModel.count
            .bind(to: self.rx.bindCount)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UnAvailableGifticonViewController {
    var scrollOffset: Binder<UICollectionView> {
        return Binder<UICollectionView>(self.base) { viewController, collectionView in
            let contentOffsetY = collectionView.contentOffset.y
            let scrollViewHeight = collectionView.bounds.size.height
            let contentHeight = collectionView.contentSize.height
            let height = CGFloat(UIScreen.getWidthByDivision(division: 2, exclude: 20 + 16 + 20))
            
            // 스크롤 할 필요 없는 데이터의 양일 때는 페이징 처리하지 않음
            if contentHeight <= scrollViewHeight {
                return
            }
            
            if contentOffsetY + scrollViewHeight + height >= contentHeight,
               !viewController.viewModel.isScrollEnded,
               !viewController.viewModel.isLoading {
                MOALogger.logd()
                viewController.viewModel.isLoading = true
                viewController.viewModel.fetchMore()
            }
        }
    }
    
    var bindCount: Binder<Int> {
        return Binder<Int>(self.base) { viewController, count in
            viewController.titleLabel.text = String(format: UNAVAILABLE_GIFTICON_COUNT_TITLE_FORMAT, count)
        }
    }
}
