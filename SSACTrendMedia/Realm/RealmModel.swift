//
//  RealmModel.swift
//  SSACTrendMedia
//
//  Created by Sang hun Lee on 2021/11/02.
//
import Foundation
import RealmSwift


class BoxOffice: Object {
    // 2. 각 컬럼 정립
    // 3. PK키 구성
    
    @Persisted(primaryKey: true) var _id: ObjectId // AutoIncreasement
    @Persisted var movieTitle: String
    @Persisted var ranking: String
    @Persisted var releaseDate: String

    convenience init(movieTitle: String, ranking: String, releaseDate: String) {
        self.init()
        
        self.movieTitle = movieTitle
        self.ranking = ranking
        self.releaseDate = releaseDate
    }
}
