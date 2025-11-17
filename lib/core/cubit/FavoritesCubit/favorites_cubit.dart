import 'package:bloc/bloc.dart';
import 'package:depi_app/core/utils/FavoriteService.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final String userId;

  FavoritesCubit(this.userId) : super(FavoritesState(favorites: <String>{}));

  /// تحميل الفيفوريت لأول مرة
  Future<void> loadFavorites() async {
    emit(FavoritesState(favorites: <String>{}, loading: true));

    final favIds = await FavoriteService().getAllFavorites(userId);

    emit(FavoritesState(favorites: favIds.toSet(), loading: false));
  }

  /// عكس حالة الفيفوريت
  Future<void> toggleFavorite(String productId) async {
    final current = {...state.favorites};

    if (current.contains(productId)) {
      current.remove(productId);
      await FavoriteService().removeFromFavorite(userId, productId);
    } else {
      current.add(productId);
      await FavoriteService().addToFavorite(userId, productId);
    }

    emit(FavoritesState(favorites: current));
  }

  /// حذف منتج من الفيفوريت
  Future<void> removeFavorite(String productId) async {
    final current = {...state.favorites};

    current.remove(productId);
    await FavoriteService().removeFromFavorite(userId, productId);

    emit(FavoritesState(favorites: current, loading: false));
  }

  bool isFavorite(String id) => state.favorites.contains(id);
}

