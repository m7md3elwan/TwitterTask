//
//  TwitterClientPlaceHolders.swift
//  TwitterClient
//
//  Created by Mohamed Mostafa on 11/19/17.
//  Copyright © 2017 Elwan. All rights reserved.
//

import Foundation
import HGPlaceholders
import Localize_Swift

extension PlaceholdersProvider {
    
    public static func twitterPlaceHolders() -> PlaceholdersProvider {
        
        var commonStyle = PlaceholderStyle()
        commonStyle.backgroundColor = .white
        commonStyle.actionTitleColor = .white
        commonStyle.titleColor = .black
        commonStyle.isAnimated = false
        
        var loadingData: PlaceholderData = .loading
        loadingData.image = #imageLiteral(resourceName: "twitterLogo")
        loadingData.action = nil
        loadingData.title = "loadingDataTitle".localized()
        loadingData.subtitle = "loadingDataSubtitle".localized()
        loadingData.showsLoading = true
        let loading = Placeholder(data: loadingData, style: commonStyle, key: .loadingKey)
        
        var errorData: PlaceholderData = .error
        errorData.image = #imageLiteral(resourceName: "twitterLogo")
        errorData.action = "retry".localized()
        errorData.title = "errorDataTitle".localized()
        errorData.subtitle = "errorDataSubtitle".localized()
        let error = Placeholder(data: errorData, style: commonStyle, key: .errorKey)
        
        var noResultsData: PlaceholderData = .noResults
        noResultsData.image = #imageLiteral(resourceName: "twitterLogo")
        noResultsData.action = nil
        noResultsData.title = "noResultsDataTitle".localized()
        noResultsData.subtitle = "noResultsDataSubtitle".localized()
        let noResults = Placeholder(data: noResultsData, style: commonStyle, key: .noResultsKey)
        
        var noConnectionData: PlaceholderData = .noConnection
        noConnectionData.image = #imageLiteral(resourceName: "twitterLogo")
        noConnectionData.action = "retry".localized()
        noConnectionData.title = "noConnectionDataTitle".localized()
        noConnectionData.subtitle = "noConnectionDataSubtitle".localized()
        let noConnection = Placeholder(data: noConnectionData, style: commonStyle, key: .noConnectionKey)
        
        let placeholdersProvider = PlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        
        var noSearchResultsData: PlaceholderData = .noResults
        noSearchResultsData.image = #imageLiteral(resourceName: "twitterLogo")
        noSearchResultsData.action = nil
        noSearchResultsData.title = "noSearchResultsDataTitle".localized()
        noSearchResultsData.subtitle = "noSearchResultsDataSubTitle".localized()
        let noSearchResults = Placeholder(data: noResultsData, style: commonStyle, key:PlaceholderKey.custom(key: "noSearchResults"))
        placeholdersProvider.add(placeholders: noSearchResults)
        
        
        return placeholdersProvider
    }
}
