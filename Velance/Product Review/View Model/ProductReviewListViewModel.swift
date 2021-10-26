import Foundation

protocol ProductReviewListDelegate: AnyObject {
    func didFetchProductList()
    func failedFetchingProductList(with error: NetworkError)
}

class ProductReviewListViewModel {
    
    //MARK: - Properties
    
    private var productManager: ProductManager?
    weak var delegate: ProductReviewListDelegate?
    
    var productList: [ProductListResponseDTO] = []
    
    var selectedProductCategory = 1 {
        didSet {
            resetValues()
            fetchProductList()
        }
    }
    
    var isFetchingData: Bool = false
    var cursor: Int = 0
    
    //MARK: - Initialization
    
    init(productManager: ProductManager) {
        self.productManager = productManager
    }
    
    //MARK: - Methods
    
    //MARK: - 제품 목록 가져오기
    func fetchProductList(onlyMyVegetarianType: String = "N") {
        showProgressBar()
        isFetchingData = true
        
        productManager?.getProducts(
            page: cursor,
            productCategoryId: selectedProductCategory,
            onlyMyVegetarianType: onlyMyVegetarianType)
        { [weak self] result in
            dismissProgressBar()
            guard let self = self else { return }
            switch result {
            case .success(let productList):
                if productList.isEmpty {
                    self.delegate?.didFetchProductList()
                    return
                }
                self.cursor = productList.last?.productId ?? 0
                self.productList.append(contentsOf: productList)
                self.isFetchingData = false
                self.delegate?.didFetchProductList()
            case .failure(let error):
                self.isFetchingData = false
                self.delegate?.failedFetchingProductList(with: error)
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
        isFetchingData = false
        cursor = 0
    }
}
