import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApplicationConstants {
  static final String mapboxAccessToken =
      dotenv.env['MAPBOX_ACCESS_TOKEN'] as String;
  static final String geoapifyApiKey = dotenv.env['GEOAPIFY_API_KEY'] as String;
  static const List<String> geoapifyPlacesCategories = [
    'accommodation',
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
  static const List<String> geoapifyPlacesConditions = [
    'internet_access',
    'wheelchair',
    'dogs',
    'no_fee',
    'vegetarian',
    'vegan'
  ];
}
