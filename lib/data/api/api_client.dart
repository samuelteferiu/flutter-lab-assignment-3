import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/album.dart';
import '../models/photo.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/albums')
  Future<List<Album>> getAlbums();

  @GET('/photos')
  Future<List<Photo>> getPhotos();
} 