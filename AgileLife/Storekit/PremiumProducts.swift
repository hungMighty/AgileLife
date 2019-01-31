import Foundation

public struct PremiumProducts {
    
    public static let PSM1 = "com.teaFox.AgileCheetah.PSM1"
    private static let productIdentifiers: Set<ProductIdentifier> = [PremiumProducts.PSM1]
    public static let store = IAPHelper(productIds: PremiumProducts.productIdentifiers)
    
    static func getQuestionTemplate(productID: String) -> QuestionTemplate {
        switch productID {
        case PSM1:
            return .psm1
        default:
            return .easy
        }
    }
    
}

