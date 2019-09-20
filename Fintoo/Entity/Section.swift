//
//  Section.swift
//  TableViewDropDown
//
//  Created by BriefOS on 5/3/17.
//  Copyright © 2017 BriefOS. All rights reserved.
//

import Foundation

class Section {
    var genre: String!
    var movies: [Dictionary<String,String>]!
    var expanded: Bool!
    
    init(genre: String, movies: [Dictionary<String,String>]!, expanded: Bool) {
        self.genre = genre
        self.movies = movies
        self.expanded = expanded
    }
}
