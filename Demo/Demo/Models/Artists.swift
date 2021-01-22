struct Artist: Encodable {
    public let name: String
    public let discography: [String]
}

struct ArtistsMock {
    static let data = [
        Artist(name: "Beatles", discography: [
                "Please Please Me",
                "With The Beatles",
                "A Hard Day’s Night",
                "Beatles For Sale",
                "Help!",
                "Rubber Soul",
                "Revolver",
                "Sgt Pepper’s Lonely Hearts Club Band",
                "The Beatles",
                "Yellow Submarine",
                "Abbey Road",
                "Let It Be"
        ]),
        Artist(name: "The Doors", discography: ["The Doors",
                                                "Strange Days",
                                                "Waiting for the Sun",
                                                "The Soft Parade",
                                                "Absolutely Live",
                                                "Morrison Hotel",
                                                "L.A. Woman",
                                                "Other Voices",
                                                "Full Circle",
                                                "An American Prayer"])
    ]
}
