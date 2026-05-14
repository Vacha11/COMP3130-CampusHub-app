import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campushub/providers/favourite_provider.dart';
import '../fakes/favourite_fakes.dart';

Widget wrapWithFavProvider({required Widget child}) {
  return ChangeNotifierProvider(
    create: (_) => FavouriteProvider.test(
      favouriteService: FakeFavouriteService(),
      initialFavourites: [],
    ),
    child: MaterialApp(home: child),
  );
}