import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/album.dart';
import '../../data/models/photo.dart';
import '../../data/repositories/album_repository.dart';

// Events
abstract class AlbumEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAlbums extends AlbumEvent {}
class FetchAlbumPhotos extends AlbumEvent {
  final int albumId;
  FetchAlbumPhotos(this.albumId);
  @override
  List<Object> get props => [albumId];
}

// States
abstract class AlbumState extends Equatable {
  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}
class AlbumLoading extends AlbumState {}
class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, Photo> albumThumbnails;
  AlbumLoaded(this.albums, this.albumThumbnails);
  @override
  List<Object> get props => [albums, albumThumbnails];
}
class AlbumError extends AlbumState {
  final String message;
  AlbumError(this.message);
  @override
  List<Object> get props => [message];
}

class AlbumPhotosLoading extends AlbumState {}
class AlbumPhotosLoaded extends AlbumState {
  final Album album;
  final List<Photo> photos;
  AlbumPhotosLoaded(this.album, this.photos);
  @override
  List<Object> get props => [album, photos];
}
class AlbumPhotosError extends AlbumState {
  final String message;
  AlbumPhotosError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _albumRepository;
  List<Album>? _albums;
  Map<int, Photo>? _albumThumbnails;

  AlbumBloc(this._albumRepository) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchAlbumPhotos>(_onFetchAlbumPhotos);
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      _albums = await _albumRepository.getAlbums();
      _albumThumbnails = await _albumRepository.getFirstPhotoForAlbums();
      emit(AlbumLoaded(_albums!, _albumThumbnails!));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  Future<void> _onFetchAlbumPhotos(FetchAlbumPhotos event, Emitter<AlbumState> emit) async {
    emit(AlbumPhotosLoading());
    try {
      final album = _albums?.firstWhere((a) => a.id == event.albumId);
      if (album == null) throw Exception('Album not found');
      final photos = await _albumRepository.getPhotosForAlbum(event.albumId);
      emit(AlbumPhotosLoaded(album, photos));
    } catch (e) {
      emit(AlbumPhotosError(e.toString()));
    }
  }
} 