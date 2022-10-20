class Restaurant {
  Restaurant({
    this.id = '',
    this.name = '',
    this.address = '',
    this.cuisine = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.imageUrl = '',
    this.rating = 0.0,
    this.distance = 0.0,
  });

  final String id;
  final String name;
  final String address;
  final String cuisine;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final double rating;
  final double distance;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'cuisine': cuisine,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }

  static Restaurant fromMap(final data) {
    return Restaurant(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      cuisine: data['cuisine'],
      latitude: data['latitude'] is int
          ? data['latitude'].toDouble()
          : data['latitude'],
      longitude: data['longitude'] is int
          ? data['longitude'].toDouble()
          : data['longitude'],
      imageUrl: data['imageUrl'],
      rating:
          data['rating'] is int ? data['rating'].toDouble() : data['rating'],
    );
  }

  static Restaurant fromJson(final data, final double distance) {
    return Restaurant(
      id: data['id_source'],
      name: data['name'],
      address: data['address'],
      cuisine: data['cuisine'],
      latitude: double.parse(data['lat']),
      longitude: double.parse(data['lon']),
      imageUrl: data['image_url'],
      rating:
          data['rating'] is int ? data['rating'].toDouble() : data['rating'],
      distance: distance,
    );
  }
}
