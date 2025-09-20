
    import Foundation
    import StoreKit

    @MainActor
    class StoreKitManager: ObservableObject {
        @Published var products: [Product] = []
        @Published var purchasedProducts: Set<String> = []
        @Published var purchaseCompleted = false
        
        private let productIDs = ["1_year_subscription_soundhaven", "1_month_subscription_soundhaven", "1_week_subscription_soundhaven"]
        
        init() {
            Task {
                await fetchProducts()
                if products.isEmpty {
                    try? await Task.sleep(nanoseconds: 2_000_000_000) // wait 2s
                    await fetchProducts()
                }
                await updatePurchasedProducts()
            }
        }
        
        
        @Published var isLoading = true
        @Published var loadingError: Error? = nil
        
        /// Fetch available IAP products
        func fetchProducts() async {
            isLoading = true
               loadingError = nil
               do {
                   products = try await Product.products(for: productIDs)
                   
                   // Sort the products so that the longest duration appears first (1 Year → 1 Month → 1 Week)
                   products.sort { first, second in
                       let firstIndex = productIDs.firstIndex(of: first.id) ?? 0
                       let secondIndex = productIDs.firstIndex(of: second.id) ?? 0
                       return firstIndex < secondIndex  // Ensures "1_year" appears before "1_month" and "1_week"
                   }
            } catch {
                print("Failed to fetch products: \(error)")
                loadingError = error
            }
            isLoading = false
        }
        
        /// Purchase a specific product
        func purchase(product: Product) async {
            do {
                let result = try await product.purchase()
                
                switch result {
                case .success(let verification):
                    if case .verified(let transaction) = verification {
                        await transaction.finish()
                        await updatePurchasedProducts()
                        DispatchQueue.main.async {
                             self.purchaseCompleted = true
                         }
                    }
                case .userCancelled:
                    print("❌ Purchase cancelled")
                default:
                    print("⚠️ Purchase failed")
                }
            } catch {
                print("❌ Purchase error: \(error)")
            }
        }
        
        /// Restore previous purchases
        func restorePurchases() async {
            for await verification in Transaction.currentEntitlements {
                if case .verified(let transaction) = verification {
                    purchasedProducts.insert(transaction.productID)
                }
            }
        }
        
        /// Check purchased items (useful for subscriptions)
        func updatePurchasedProducts() async {
            for await verification in Transaction.currentEntitlements {
                if case .verified(let transaction) = verification {
                    purchasedProducts.insert(transaction.productID)
                }
            }
        }
        
        /// Check if a user has an active subscription
        func hasActiveSubscription() -> Bool {
            return purchasedProducts.contains(where: { productID in
                productID == "1_year_subscription_soundhaven" ||
                productID == "1_month_subscription_soundhaven" ||
                productID == "1_week_subscription_soundhaven"
            })
        }
    }
