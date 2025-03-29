import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/screens/wishlist.dart';
import 'package:gastrorate/store/app_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => Wishlist(),
    );
  }
}

class Factory extends VmFactory<AppState, WishlistPage, ViewModel> {
  Factory(WishlistPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel();
}

class ViewModel extends Vm {
  ViewModel();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is ViewModel && runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}
