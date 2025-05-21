import '../api/api_client.dart';
import '../models/album.dart';
import '../models/photo.dart';

class AlbumRepository {
  final ApiClient _apiClient;
  List<Album>? _albumsCache;
  List<Photo>? _photosCache;

  AlbumRepository(this._apiClient);

  Future<List<Album>> getAlbums() async {
    _albumsCache ??= await _apiClient.getAlbums();
    return _albumsCache!;
  }

  Future<List<Photo>> getPhotos() async {
    _photosCache ??= await _apiClient.getPhotos();
    return _photosCache!;
  }

  Future<Map<int, Photo>> getFirstPhotoForAlbums() async {
    final photos = await getPhotos();
    final Map<int, Photo> albumPhotoMap = {};
    for (final photo in photos) {
      if (!albumPhotoMap.containsKey(photo.albumId)) {
        albumPhotoMap[photo.albumId] = photo;
      }
    }
    return albumPhotoMap;
  }

  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    final photos = await getPhotos();
    return photos.where((photo) => photo.albumId == albumId).toList();
  }
} 