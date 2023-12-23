import 'package:flutter_dotenv/flutter_dotenv.dart';

final String mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] as String;
final String geoapifyApiKey = dotenv.env['GEOAPIFY_API_KEY'] as String;
final List<String> geoapifyPlacesCategories = [
  'accomodation',
  'activity',
  'commercial',
  'catering',
  'education',
  'childcare',
  'entertainment',
  'healthcare',
  'leisure',
  'heritage',
  'man_made',
  'natural',
  'national_park',
  'office',
  'parking',
  'pet',
  'rental',
  'service',
  'tourism',
  'religion',
  'camping',
  'amenity',
  'beach',
  'adult',
  'building',
  'ski',
  'sport',
  'public',
  'administrative'
];
final List<String> geoapifyPlacesConditions = [
  'internet_access',
  'wheelchair',
  'dogs',
  'no_fee',
  'vegetarian',
  'vegan'
];
