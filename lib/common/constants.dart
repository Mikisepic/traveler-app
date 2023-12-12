import 'package:flutter_dotenv/flutter_dotenv.dart';

final mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] as String;
final geoapifyApiKey = dotenv.env['GEOAPIFY_API_KEY'] as String;
