import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/close_button.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class ModalHeader extends StatelessWidget {
  final String? title;

  const ModalHeader({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(title ?? '', style: Theme.of(context).textTheme.titleSmall),
            ),
            CloseButtonWidget(onCloseButtonTap: () => Navigator.of(context).pop()),
          ],
        ),
        const VerticalSpacer(8),
        buildVerticalDivider(),
      ],
    );
  }

  Divider buildVerticalDivider() {
    return const Divider(
      color: MyColors.onPrimaryColor,
      thickness: 0.5,
      height: 1,
    );
  }
}
