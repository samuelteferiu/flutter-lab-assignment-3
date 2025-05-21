import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labassignment3/data/api/api_client.dart';
import 'package:labassignment3/data/models/album.dart';
import 'package:labassignment3/presentation/bloc/album_list/album_list_event.dart';
import 'package:labassignment3/presentation/bloc/album_list/album_list_state.dart';

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  final ApiClient _apiClient;
  List<Album>? _albums;

  AlbumListBloc(this._apiClient) : super(AlbumListInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
  }

  Future<void> _onLoadAlbums(
    LoadAlbums event,
    Emitter<AlbumListState> emit,
  ) async {
    try {
      emit(AlbumListLoading());
      _albums = await _apiClient.getAlbums();
      emit(AlbumListLoaded(_albums!));
    } catch (e) {
      emit(AlbumListError(e.toString()));
    }
  }

  Album? getAlbumById(int id) {
    return _albums?.firstWhere((album) => album.id == id);
  }
} 