//
//  DateFormat.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

enum DateFormat: String {
    case dateFormat = "yyyyMMdd"
    case dateAndTimeFormat = "dd.MM.yyyy HH:mm:ss"
    case dashDateFormat = "yyyy-MM-dd"
    case dotDateFormat = "dd.MM.yyyy"
    case dotTimeFormat = "HH:mm"
    case dotDateAndTimeFormat = "dd.MM.yyyy HH:mm"
    case textDateFormat = "d MMMM yyyy"
    case iso8601Format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}
