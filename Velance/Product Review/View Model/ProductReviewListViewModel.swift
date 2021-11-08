import Foundation

protocol ProductReviewListDelegate: AnyObject {
    func didFetchProductList()
    func failedFetchingProductList(with error: NetworkError)
    func didFetchSimilarTasteProductList()
    func failedFetchingSimilarTasteProductList(with error: NetworkError)
}

extension ProductReviewListDelegate {
    func didFetchProductList() {}
    func failedFetchingProductList(with error: NetworkError) {}
    func didFetchSimilarTasteProductList() {}
    func failedFetchingSimilarTasteProductList(with error: NetworkError) {}
}

class ProductReviewListViewModel {
    
    //MARK: - Properties
    
    private var productManager: ProductManager?
    weak var delegate: ProductReviewListDelegate?
    
    var productList: [ProductListResponseDTO] = []                  // 인기있는 제품
    var similarTasteProductList: [SimilarTasteProductDTO] = []      // 입맛이 비슷한 사용자 제품 추천
    
    var selectedProductCategory = 1 {
        didSet {
            resetValues()
            fetchProductList()
        }
    }

    var isFetchingData: Bool = false
    var cursor: Int = 0
    
    // 알러지유발식품 제외
    var onlyMyAllergyType: String = "N" {
        didSet { fetchProductList() }
    }
    
    // 내 채식유형이 먹은 제품들
    var onlyMyVegetarianType: String = "N" {
        didSet { fetchProductList() }
    }

    
    //MARK: - Initialization
    
    init(productManager: ProductManager) {
        self.productManager = productManager
    }
    
    //MARK: - Methods
    
    func reverse() {
        self.productList.reverse()
        delegate?.didFetchProductList()
    }
    
    //MARK: - 제품 목록 가져오기
    func fetchProductList() {
    
        isFetchingData = true
        
        productManager?.getProducts(
            page: cursor,
            productCategoryId: selectedProductCategory,
            onlyMyVegetarianType: onlyMyVegetarianType,
            onlyMyAllergyType: onlyMyAllergyType
        ) { [weak self] result in
            dismissProgressBar()
            guard let self = self else { return }
            switch result {
            case .success(let productList):
                if productList.isEmpty {
                    self.delegate?.didFetchProductList()
                    return
                }
                self.cursor += 1
                self.productList.append(contentsOf: productList)
                self.isFetchingData = false
                self.delegate?.didFetchProductList()
            case .failure(let error):
                self.isFetchingData = false
                self.delegate?.failedFetchingProductList(with: error)
            }
        }
    }
    
    func fetchSimilarTasteProductList() {
        similarTasteProductList.removeAll()
        productManager?.getSimilarTasteProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let similarTasteProductList):
                if similarTasteProductList.isEmpty {
                    self.delegate?.didFetchSimilarTasteProductList()
                    return
                }
                self.similarTasteProductList.append(contentsOf: similarTasteProductList)
                self.delegate?.didFetchSimilarTasteProductList()
            case .failure(let error):
                self.delegate?.failedFetchingSimilarTasteProductList(with: error)
            }
        }
    }
    
    //MARK: - 제품 검색하기
    func fetchSearchList(productName: String) {
        showProgressBar()
        isFetchingData = true
        
        productManager?.searchProducts(
            page: cursor,
            name: productName
        ) { [weak self] result in
            guard let self = self else { return }
            dismissProgressBar()
            switch result {
            case .success(let searchList):
                if searchList.isEmpty {
                    self.delegate?.didFetchProductList()
                    return
                }
                self.cursor = searchList.last?.productId ?? 0
                self.productList.append(contentsOf: searchList)
                self.isFetchingData = false
                self.delegate?.didFetchProductList()
            case .failure(let error):
                self.isFetchingData = false
                self.delegate?.failedFetchingProductList(with: error)
            }
        }
    }
    
    
    func resetValues() {
        productList.removeAll()
        similarTasteProductList.removeAll()
        isFetchingData = false
        cursor = 0
    }
}
