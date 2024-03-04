import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/service/restaurant_manager.dart';
import 'package:gastrorate/store/app_state.dart';

class FetchRestaurantsAction extends ReduxAction<AppState>{
  FetchRestaurantsAction();

  @override
  Future<AppState?> reduce() async{
    List<Restaurant>? restaurants = await RestaurantManager().findRestaurants();
    return state.copyWith(restaurantsState: state.restaurantsState.copyWith(restaurants: restaurants));
  }
}