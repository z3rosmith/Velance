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
    
    var selectedProductCategory = 1
    
    var isFetchingData: Bool = false
    
    
    var pageIndex: Int = 0
    
    
    
    //MARK: - Initialization
    
    init(productManager: ProductManager) {
        self.productManager = productManager
    }
    
    //MARK: - Methods
    
    func fetchProductList(onlyMyVegetarianType: String = "N") {
        
        isFetchingData = true
        
        productManager?.getProducts(
            page: pageIndex,
            productCategoryId: selectedProductCategory,
            onlyMyVegetarianType: onlyMyVegetarianType)
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let productList):
                
                self.productList.append(contentsOf: productList)
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
        pageIndex = 0
    }
}
