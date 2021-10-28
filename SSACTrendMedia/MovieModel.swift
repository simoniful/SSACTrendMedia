import Foundation

struct TvShow {
    let title: String
    let releaseDate: String
    let genre: String
    let region: String
    let overview: String
    let rate: Double
    let starring: String
    let backdropImage: String
}

struct TrendInfo {
    let title: String
    let releaseDate: String
    let genres: Array<Int>
    let region: String
    let overview: String
    let rate: Double
    let originalTitle: String
    let backdropImage: String
    let posterImage: String
    let mediaId: Int
}

struct MovieModel {
    var titleData: String
    var imageData: String
    var linkData: String
    var userRatingData: String
    var subtitleData: String
    var pubData: String
}

struct BoxOfficeModel {
    var title: String
    var ranking: String
    var releaseDate: String
}

struct GenreModel {
    var id: Int
    var name: String
}

struct CastModel {
    var name: String
    var profile: String
    var character: String
}

struct CrewModel {
    var name: String
    var profile: String
    var job: String
}
