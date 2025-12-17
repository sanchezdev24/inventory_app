import 'package:get_it/get_it.dart';

import 'core/network/http_client.dart';
import 'core/network/network_info.dart';
import 'core/platform/native_storage_channel.dart';
import 'features/api_products/data/datasources/product_remote_datasource.dart';
import 'features/api_products/data/repositories/product_repository_impl.dart';
import 'features/api_products/domain/repositories/product_repository.dart';
import 'features/api_products/domain/usecases/get_products.dart';
import 'features/api_products/presentation/cubit/api_products_cubit.dart';
import 'features/saved_items/data/repositories/saved_item_repository_impl.dart';
import 'features/saved_items/domain/repositories/saved_item_repository.dart';
import 'features/saved_items/domain/usecases/saved_item_usecases.dart';
import 'features/saved_items/presentation/cubit/saved_items_cubit.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // ==================== Core ====================

  // Network
  sl.registerLazySingleton<HttpClient>(() => HttpClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Platform - Method Channels
  sl.registerLazySingleton<NativeStorageChannel>(() => NativeStorageChannel());

  // ==================== Features ====================

  // === API Products ===

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Cubits
  sl.registerFactory(
        () => ApiProductsCubit(getProducts: sl()),
  );

  // === Saved Items (Native Storage) ===

  // Repositories
  sl.registerLazySingleton<SavedItemRepository>(
        () => SavedItemRepositoryImpl(nativeChannel: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSavedItems(sl()));
  sl.registerLazySingleton(() => GetSavedItemById(sl()));
  sl.registerLazySingleton(() => SaveItem(sl()));
  sl.registerLazySingleton(() => UpdateItem(sl()));
  sl.registerLazySingleton(() => DeleteItem(sl()));

  // Cubits
  sl.registerFactory(
        () => SavedItemsCubit(
      getSavedItems: sl(),
      getSavedItemById: sl(),
      saveItem: sl(),
      updateItem: sl(),
      deleteItem: sl(),
    ),
  );

  // === Splash ===
  sl.registerFactory(() => SplashCubit());
}