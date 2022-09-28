//
//  EnumLocalizations.swift
//  UI
//
//  Created by p h on 07.09.2022.
//

import Foundation
import UIKit

enum L10n {
    static let searchBarPlaceholder = "searchBarPlaceholder".localized
    static let beerLeft = "beerLeft".localized
    static let tapToSell = "tapToSell".localized
    static let currentIncomeButton = "currentIncomeButton".localized
    static let newDayButton = "newDayButton".localized
    static let currency = "currency".localized
    static let currentIncomeLabel = "currentIncomeLabel".localized
    static let newDayLabel = "newDayLabel".localized
    static let saveButton = "saveButton".localized
    static let brandPlaceholder = "brandPlaceholder".localized
    static let countryPlaceholder = "countryPlaceholder".localized
    static let pricePlaceholder = "pricePlaceholder".localized
    static let amountPlaceholder = "amountPlaceholder".localized
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
