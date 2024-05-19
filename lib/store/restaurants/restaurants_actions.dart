import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/service/restaurant_manager.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/tools/toast_helper_web.dart';

class FetchRestaurantsAction extends ReduxAction<AppState>{
  FetchRestaurantsAction();

  @override
  Future<AppState?> reduce() async{
    List<Restaurant>? restaurants = await RestaurantManager().findRestaurants();
    dispatch(FetchRestaurantsSuccessAction(restaurants));
    return null;
  }
}

class InitNewPlaceAction extends ReduxAction<AppState>{
  InitNewPlaceAction(this.payload);
  final Restaurant payload;

  @override
  Future<AppState?> reduce() async{
    return state.copyWith(restaurantsState: state.restaurantsState.copyWith(currentRestaurant: payload));
  }
}

class SaveOrUpdatePlaceAction extends ReduxAction<AppState>{
  SaveOrUpdatePlaceAction(this.payload);
  final Restaurant payload;

  @override
  Future<AppState?> reduce() async{
    Restaurant restaurant = await RestaurantManager().saveOrUpdatePlace(payload);
    dispatch(SaveRestaurantSuccessAction(restaurant));
    dispatch(FetchRestaurantsAction());
    return null;
  }
}

class FetchRestaurantsSuccessAction extends ReduxAction<AppState>{
  FetchRestaurantsSuccessAction(this.payload);
  final List<Restaurant> payload;

  @override
  Future<AppState?> reduce() async{
    return state.copyWith(restaurantsState: state.restaurantsState.copyWith(restaurants: payload));
  }
}

class SaveRestaurantSuccessAction extends ReduxAction<AppState>{
  SaveRestaurantSuccessAction(this.payload);
  final Restaurant payload;

  @override
  Future<AppState?> reduce() async{
    return state.copyWith(restaurantsState: state.restaurantsState.copyWith(currentRestaurant: payload));
  }
}

class DeletePlaceAction extends ReduxAction<AppState>{
  DeletePlaceAction(this.payload);
  final Restaurant payload;

  @override
  Future<AppState?> reduce() async{
    await RestaurantManager().deletePlace(payload.id!);
    dispatch(FetchRestaurantsAction());
    return null;
  }
}

