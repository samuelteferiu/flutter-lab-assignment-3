import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:labassignment3/app/router.dart';
import 'package:labassignment3/data/api/api_client.dart';
import 'package:labassignment3/presentation/bloc/album_list/album_list_bloc.dart';
import 'package:labassignment3/presentation/bloc/album_list/album_list_event.dart';
import 'package:labassignment3/presentation/screens/album_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(Dio());
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AlbumListBloc(apiClient)..add(LoadAlbums()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Album App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
