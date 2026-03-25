import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/edit_profile/edit_profile.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => EditProfile(
        user: vm.user,
        updateUser: vm.updateUser,
        uploadProfileImage: vm.uploadProfileImage,
        isLoading: vm.isLoading,
        isUploadingImage: vm.isUploadingImage,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, EditProfilePage, ViewModel> {
  Factory(EditProfilePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        user: state.authState.loggedUser ?? User(),
        updateUser: (UpdateUserRequest request) => dispatch(UpdateUserAction(request)),
        uploadProfileImage: (File file) => dispatch(UploadProfileImageAction(file)),
        isLoading: isWaiting(UpdateUserAction),
        isUploadingImage: isWaiting(UploadProfileImageAction),
      );
}

class ViewModel extends Vm {
  ViewModel({
    required this.user,
    required this.updateUser,
    required this.uploadProfileImage,
    required this.isLoading,
    required this.isUploadingImage,
  });

  final User user;
  final Function(UpdateUserRequest request) updateUser;
  final Function(File imageFile) uploadProfileImage;
  final bool isLoading;
  final bool isUploadingImage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          updateUser == other.updateUser &&
          uploadProfileImage == other.uploadProfileImage &&
          isLoading == other.isLoading &&
          isUploadingImage == other.isUploadingImage;

  @override
  int get hashCode =>
      super.hashCode ^
      user.hashCode ^
      updateUser.hashCode ^
      uploadProfileImage.hashCode ^
      isLoading.hashCode ^
      isUploadingImage.hashCode;
}
