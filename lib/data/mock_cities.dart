class City {
  final String name;
  final String country;
  final String stateOrRegion;
  final double latitude;
  final double longitude;

  const City({
    required this.name,
    required this.country,
    required this.stateOrRegion,
    required this.latitude,
    required this.longitude,
  });
}

const List<City> mockCities = [
  City(name: 'New York', country: 'USA', stateOrRegion: 'New York', latitude: 40.7128, longitude: -74.0060),
  City(name: 'London', country: 'UK', stateOrRegion: 'England', latitude: 51.5074, longitude: -0.1278),
  City(name: 'Tokyo', country: 'Japan', stateOrRegion: 'Tokyo', latitude: 35.6762, longitude: 139.6503),
  City(name: 'Sydney', country: 'Australia', stateOrRegion: 'New South Wales', latitude: -33.8688, longitude: 151.2093),
  City(name: 'Paris', country: 'France', stateOrRegion: 'Île-de-France', latitude: 48.8566, longitude: 2.3522),
  City(name: 'Dubai', country: 'UAE', stateOrRegion: 'Dubai', latitude: 25.2048, longitude: 55.2708),
  City(name: 'Mumbai', country: 'India', stateOrRegion: 'Maharashtra', latitude: 19.0760, longitude: 72.8777),
  City(name: 'Rio de Janeiro', country: 'Brazil', stateOrRegion: 'Rio de Janeiro', latitude: -22.9068, longitude: -43.1729),
  City(name: 'Cape Town', country: 'South Africa', stateOrRegion: 'Western Cape', latitude: -33.9249, longitude: 18.4241),
  City(name: 'Toronto', country: 'Canada', stateOrRegion: 'Ontario', latitude: 43.6510, longitude: -79.3470),
];
