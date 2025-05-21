import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../presentation/screens/album_list_screen.dart';
import '../presentation/screens/album_detail_screen.dart';
import '../data/models/album.dart';
import '../presentation/bloc/album_list/album_list_bloc.dart';
import '../data/api/api_client.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AlbumListScreen(),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final album = state.extra as Album;
        final albumListBloc = context.read<AlbumListBloc>();
        final foundAlbum = albumListBloc.getAlbumById(album.id);
        
        if (foundAlbum == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(
              child: Text('Album not found. Please try again.'),
            ),
          );
        }

        return AlbumDetailScreen(album: foundAlbum);
      },
    ),
  ],
); 