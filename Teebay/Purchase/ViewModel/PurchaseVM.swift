//
//  PurchaseVM.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 18/6/25.
//



protocol PurchaseVMDelegate: CommonViewModelDelegate {
    
}

class PurchaseVM {
    
    private let apiService = ApiService.shared
    weak var delegate: PurchaseVMDelegate?
    
    init(_ delegate: PurchaseVMDelegate) {
        self.delegate = delegate
    }
    
    deinit {
        print("DEBUG_PRINT => Line \(#line) in method: \(#function) @ \(String(describing: Self.self))")
    }
    
    func postRental(rental: RentalRequestMdoel) {
        self.delegate?.showSpinner()
        Task {

            do {
                try await apiService.transaction.postRental(rental)
                print("Rental created successfully")
                self.delegate?.dataLoaded()
            } catch {
                print("Error creating rental: \(error)")
                self.delegate?.failedWithError(code: 0, message: "\(error.localizedDescription)")
            }
            
            self.delegate?.hideSpinner()
        }

        
    }
    
}
