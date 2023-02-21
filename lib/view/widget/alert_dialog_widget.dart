import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

class AlertDialogWidget {
  static alertYesNo({
    required BuildContext context,
    required String title,
    required String message,
    required Function onYes,
    Function? onNo,
  }) async {
    await FlutterPlatformAlert.playAlertSound();

    AlertButton clickedButton = await FlutterPlatformAlert.showAlert(
      windowTitle: title,
      text: message,
      alertStyle: AlertButtonStyle.yesNo,
      iconStyle: IconStyle.information,
    );

    if (clickedButton == AlertButton.yesButton) {
      onYes();
    } else {
      if (onNo != null) onNo();
    }
  }
}
