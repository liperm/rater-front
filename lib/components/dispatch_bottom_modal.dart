import "package:flutter/material.dart";

class DispatchBottomModal {
  BuildContext context;
  final Widget child;

  DispatchBottomModal({required this.context, required this.child});

  Future openModal() {
    return showModalBottomSheet(
      useRootNavigator: true,
      builder: (BuildContext context) {
        return child;
      },
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }
}
