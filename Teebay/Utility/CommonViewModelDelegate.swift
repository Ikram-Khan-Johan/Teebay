//
//  CommonViewModelDelegate.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//


protocol CommonViewModelDelegate: AnyObject {
    func dataLoaded()
    func showSpinner()
    func hideSpinner()
    func failedWithError(code: Int, message: String)
}