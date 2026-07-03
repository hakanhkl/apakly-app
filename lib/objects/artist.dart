class Artist {
  String? id;
  String? name;
  String? genre;
  String? profileImageUri;
  String? headerImageUri;
  int? numberOfSongs;
  String? profession;
  String? sentence;
  String? biography;

  Artist({
    this.id,
    this.name,
    this.genre,
    this.profileImageUri,
    this.headerImageUri,
    this.numberOfSongs,
    this.profession,
    this.sentence,
    this.biography,
  });

  factory Artist.fromJson(Map<String, dynamic>json) {
    return Artist(
      id: json['_id'],
      name: json['artistName'],
      genre: json['genre'],
      profileImageUri: json['profileImage'],
      sentence: json['sentence'],
      profession: json['profession'],
      biography: json['biography'],
    );
  }
}
