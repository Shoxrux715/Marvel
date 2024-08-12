//
//  FavComics+CoreDataProperties.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 29/07/24.
//
//

import Foundation
import CoreData


extension FavComics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavComics> {
        return NSFetchRequest<FavComics>(entityName: "FavComics")
    }

    @NSManaged public var id: Int32
    @NSManaged public var url: URL?
    @NSManaged public var isFavourite: Bool

}

extension FavComics : Identifiable {

}
