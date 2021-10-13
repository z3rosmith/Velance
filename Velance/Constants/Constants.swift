import Foundation
import UIKit

struct StoryboardName {
    
    static let main             = "Main"
    static let login            = "Login"
    static let userRegister     = "UserRegister"
    static let productReview    = "ProductReview"
}

struct StoryboardID {
    
    static let mainVC                       = "MainViewController"
    static let homeVC                       = "RecordViewController"
    static let shoppingVC                   = "ShoppingViewController"
    
    // User Register
    static let idPasswordInputVC            = "IdPasswordInputViewController"
    static let chooseTypeVC                 = "ChooseTypeViewController"
    static let inputUserInfoForRegister     = "InputUserInfoForRegister"

    // Product Review
    static let productReviewListContainerVC = "ProductReviewListContainerViewController"
    static let productReviewListVC          = "ProductReviewListViewController"
    
    // Shopping
    static let recipeDetailVC               = "RecipeDetailViewController"
}

struct Colors {
    
    static let appDefaultColor              = "AppDefaultColor"
    static let appBackgroundColor           = "AppBackgroundColor"
    static let appTintColor                 = "AppTintColor"
    static let buttonSelectedColor          = "ButtonSelectedColor"
    
    //Tab Bar Colors
    static let tabBarSelectedColor          = "TabBarSelectedColor"
    static let tabBarUnselectedColor        = "TabBarUnselectedColor"
    
    // Button Colors
    static let ovalButtonGradientLeft       = "OvalButtonGradientLeft"
    static let ovalButtonGradientRight      = "OvalButtonGradientRight"
    static let loginScreenButtonColor       = "LoginButtonColor"
}

struct CellID {
    
    static let similarTasteTableViewCell            = "similarTasteTVC"
    static let popularProductTableViewCell          = "popularProductTVC"
    
    static let shoppingItemCollectionViewCell   = "shoppingItemCVC"
    static let recipeCollectionViewCell         = "recipeCVC"
    
    // Product Review
    static let productForSimilarTasteCVC        = "ProductForSimilarTasteCVC"
    static let popularProductCVC                = "PopularProductCVC"
}

struct XIB_ID {
    
    // Product Review
    static let productForSimilarTasteCVC        = "ProductForSimilarTasteCVC"
    static let popularProductCVC                = "PopularProductCVC"
    
    static let shoppingItemCollectionViewCell   = "ShoppingItemCollectionViewCell"
    static let recipeCollectionViewCell         = "RecipeCollectionViewCell"
}

struct Images {
    
    // MealView Images
    
    static let mealViewImageBreakfast           = "breakfast"
    static let mealViewImageLunch               = "lunch"
    static let mealViewImageDinner              = "dinner"
    
    // Tab Bar Icons
    static let homeTabBarIcon_selected         = "home_selected"
    static let homeTabBarIcon_unselected       = "home_unselected"
    static let shopTabBarIcon_selected         = "shopping_selected"
    static let shopTabBarIcon_unselected       = "shopping_unselected"
    
    // Vegan Types
    static let vegan                = "vegan"
    static let ovo                  = "ovo"
    static let lacto                = "lacto"
    static let lacto_ovo            = "lactoovo"
    static let pesco                = "pesco"
    static let veganTypesUnselected = [vegan, ovo, lacto, lacto_ovo, pesco]
    
    static let vegan_selected       = "vegan_selected"
    static let ovo_selected         = "ovo_selected"
    static let lacto_selected       = "lacto_selected"
    static let lacto_ovo_selected   = "lactoovo_selected"
    static let pesco_selected       = "pesco_selected"
    static let veganTypesSelected   = [vegan_selected, ovo_selected, lacto_selected, lacto_ovo_selected, pesco_selected]
    
    // Buttons
    static let circleButtonSelected     = "CircleButtonSelected"
    static let ovalButtonSelected       = "OvalButtonSelected"
    
    
    // Stars
    static let starFilled               = "StarFilled"
    static let starUnfilled             = "StarUnfilled"
}

struct LayoutConstants {
    static var tabContainerViewHeight: CGFloat       = 0.0
}

