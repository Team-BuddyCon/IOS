//
//  GifticonService.swift
//  MOA
//
//  Created by 오원석 on 11/11/24.
//

import Foundation
import RxSwift

protocol GifticonServiceProtocol {
    func fetchAvailableGifticon(
        pageNumber: Int,
        rowCount: Int,
        storeCateogry: StoreCategory?,
        storeType: StoreType?,
        sortType: SortType
    ) -> Observable<Result<AvailableGifticonResponse, URLError>>
    
    func fetchCreateGifticon(
        image: Data,
        name: String,
        expireDate: String,
        store: String,
        memo: String?
    ) -> Observable<Result<CreateGifticonResponse, URLError>>
    
    func fetchDetailGifticon(
        gifticonId: Int
    ) -> Observable<Result<DetailGifticonResponse, URLError>>
    
    func fetchDeleteGifticon(
        gifticonId: Int
    ) -> Observable<Result<GifticonResponse, URLError>>
    
    func fetchUpdateGifticon(
        gifticonId: Int,
        name: String,
        expireDate: String,
        store: String,
        memo: String?
    ) -> Observable<Result<GifticonResponse, URLError>>
    
    func fetchUpdateUsedGifticon(
        gifticonId: Int,
        used: Bool
    ) -> Observable<Result<GifticonResponse, URLError>>
    
    func fetchUnAvailableGifticon(
        pageNumber: Int,
        rowCount: Int
    ) -> Observable<Result<UnAvailableGifticonResponse, URLError>>
    
    func fetchGifticonCount(
        used: Bool,
        storeCateogry: StoreCategory?,
        storeType: StoreType?,
        remainingDays: Int?
    ) -> Observable<Result<GifticonCountResponse, URLError>>
}


final class GifticonService: GifticonServiceProtocol {
    static let shared = GifticonService()
    private init() {}
    
    func fetchAvailableGifticon(
        pageNumber: Int,
        rowCount: Int = 20,
        storeCateogry: StoreCategory?,
        storeType: StoreType?,
        sortType: SortType
    ) -> Observable<Result<AvailableGifticonResponse, URLError>> {
        let request = AvailableGifticonRequest(
            pageNumber: pageNumber,
            rowCount: rowCount,
            storeCategory: storeCateogry,
            storeType: storeType,
            sortType: sortType
        )
        
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchCreateGifticon(
        image: Data,
        name: String,
        expireDate: String,
        store: String,
        memo: String?
    ) -> Observable<Result<CreateGifticonResponse, URLError>> {
        let request = CreateGifticonRequest(
            image: image,
            name: name,
            expireDate: expireDate,
            store: store,
            memo: memo
        )
        
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchDetailGifticon(
        gifticonId: Int
    ) -> Observable<Result<DetailGifticonResponse, URLError>> {
        let request = DetailGifticonRequest(gifticonId: gifticonId)
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchDeleteGifticon(
        gifticonId: Int
    ) -> Observable<Result<GifticonResponse, URLError>> {
        let request = DeleteGifticonRequest(gifticonId: gifticonId)
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchUpdateGifticon(
        gifticonId: Int,
        name: String,
        expireDate: String,
        store: String,
        memo: String?
    ) -> Observable<Result<GifticonResponse, URLError>> {
        let request = UpdateGifticonRequest(
            gifticonId: gifticonId,
            name: name,
            expireDate: expireDate,
            store: store,
            memo: memo
        )
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchUpdateUsedGifticon(
        gifticonId: Int,
        used: Bool
    ) -> Observable<Result<GifticonResponse, URLError>> {
        let request = UpdateUsedGifticonRequest(
            gifticonId: gifticonId,
            used: used
        )
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchUnAvailableGifticon(
        pageNumber: Int,
        rowCount: Int
    ) -> Observable<Result<UnAvailableGifticonResponse, URLError>> {
        let request = UnAvailableGifticonRequest(
            pageNumber: pageNumber,
            rowCount: rowCount
        )
        return NetworkManager.shared.request(request: request)
    }
    
    func fetchGifticonCount(
        used: Bool,
        storeCateogry: StoreCategory?,
        storeType: StoreType?,
        remainingDays: Int?
    ) -> Observable<Result<GifticonCountResponse, URLError>> {
        let request = GifticonCountRequest(
            used: used,
            storeCategory: storeCateogry,
            storeType: storeType,
            remainingDays: remainingDays
        )
        return NetworkManager.shared.request(request: request)
    }
}
