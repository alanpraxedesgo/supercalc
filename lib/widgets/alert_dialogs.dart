import 'package:flutter/material.dart';

enum AlertDialogIcon {
  SUCCESS_ICON,
  ERROR_ICON,
  WARNING_ICON,
  INFO_ICON,
  HELP_ICON,
  WIFI_OFF_ICON,
  DELETE_ICON
}

class AlertDialogColors {
  static const SUCCESS = Color(0xff008577);
  static const WARNING = Color(0xffFF8C00);
  static const ERROR = Color(0xffc0392b);
  static const INFO = Color.fromARGB(255, 0, 123, 206);
}

/// Private class __AlertDialog
/// cannot use
class __AlertDialog extends StatefulWidget {
  final Color color;
  final String title, message;
  final Color? negativeTextColor;
  final Color? positiveTextColor;
  final String? positiveText, negativeText, neutralText, confirmationText;
  final Function? positiveAction, negativeAction, neutralAction;
  final bool showNeutralButton;
  final AlertDialogIcon? alertDialogIcon;
  final bool confirm;
  final TextAlign textAlign;
  final Widget? customIcon;

  const __AlertDialog({
    required this.color,
    required this.title,
    required this.message,
    this.showNeutralButton = false,
    this.neutralText,
    this.neutralAction,
    this.positiveText,
    this.positiveTextColor,
    this.positiveAction,
    this.negativeText,
    this.negativeTextColor,
    this.negativeAction,
    this.alertDialogIcon,
    this.customIcon,
    this.confirm = false,
    this.textAlign = TextAlign.start,
    this.confirmationText,
  });

  @override
  __AlertDialogState createState() => __AlertDialogState();
}

class __AlertDialogState extends State<__AlertDialog> {
  bool _confirmDeleteAction = false;
  late double _screenWidth;

  final successIcon = const Icon(
    Icons.check,
    size: 28,
    color: AlertDialogColors.SUCCESS,
  );

  final errorIcon = const Icon(
    Icons.close,
    size: 28,
    color: AlertDialogColors.ERROR,
  );

  final warningIcon = const Icon(
    Icons.warning,
    size: 28,
    color: AlertDialogColors.WARNING,
  );

  final infoIcon = const Icon(
    Icons.info_outline,
    size: 28,
    color: AlertDialogColors.INFO,
  );

  final confirmIcon = const Icon(
    Icons.help_outline,
    size: 28,
    color: AlertDialogColors.WARNING,
  );

  final wifiOffIcon = const Icon(
    Icons.perm_scan_wifi,
    size: 28,
    color: AlertDialogColors.INFO,
  );

  final deleteIcon = const Icon(
    Icons.delete_forever_outlined,
    size: 28,
    color: AlertDialogColors.ERROR,
  );

  var _dialogIcon;

  @override
  void initState() {
    super.initState();
    _dialogIcon = confirmIcon;
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _positiveActionPerform() {
    if (widget.confirm) {
      if (_confirmDeleteAction) {
        Navigator.of(context).pop();
        // To close the dialog
        if (widget.positiveAction != null) {
          widget.positiveAction!();
        }
      }
    } else {
      Navigator.of(context).pop(); // To close the dialog
      if (widget.positiveAction != null) {
        widget.positiveAction!();
      }
    }
  }

  _getPositiveButtonColor() {
    var color =
        widget.positiveTextColor ?? const Color.fromARGB(255, 0, 126, 119);
    if (widget.confirm) {
      if (_confirmDeleteAction) {
        color = color;
      } else {
        color = Colors.grey;
      }
    }
    return color;
  }

  _positiveButton(BuildContext context) {
    if (widget.positiveText != null && widget.positiveAction != null) {
      return TextButton(
        onPressed: _positiveActionPerform,
        child: Text(
          "${widget.positiveText}",
          style: TextStyle(
              color: _getPositiveButtonColor(), fontWeight: FontWeight.bold),
        ),
      );
    }
    return const SizedBox();
  }

  _negativeButton(BuildContext context) {
    if (widget.negativeText != null && widget.negativeAction != null) {
      return TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // To close the dialog
          if (widget.negativeAction != null) {
            widget.negativeAction!();
          }
        },
        child: Text(
          "${widget.negativeText}",
          style: TextStyle(
              color: widget.negativeTextColor ?? Colors.red,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    return const SizedBox();
  }

  _dialogContent(BuildContext context) {
    _dialogIcon = confirmIcon;

    switch (widget.alertDialogIcon) {
      case AlertDialogIcon.SUCCESS_ICON:
        _dialogIcon = successIcon;
        break;
      case AlertDialogIcon.ERROR_ICON:
        _dialogIcon = errorIcon;
        break;
      case AlertDialogIcon.WARNING_ICON:
        _dialogIcon = warningIcon;
        break;
      case AlertDialogIcon.INFO_ICON:
        _dialogIcon = infoIcon;
        break;
      case AlertDialogIcon.HELP_ICON:
        _dialogIcon = confirmIcon;
        break;
      case AlertDialogIcon.DELETE_ICON:
        _dialogIcon = deleteIcon;
        break;
      case AlertDialogIcon.WIFI_OFF_ICON:
        _dialogIcon = wifiOffIcon;
        break;
      default:
        _dialogIcon = confirmIcon;
    }

    return Container(
      width: _screenWidth >= 600 ? 500 : _screenWidth,
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      margin: const EdgeInsets.only(top: 55.0),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Container(
            height: 48,
            width: 48,
            child: widget.alertDialogIcon == null
                ? widget.customIcon ?? const Text("")
                : _dialogIcon,
            decoration: BoxDecoration(
                border: Border.all(color: widget.color, width: 2.0),
                borderRadius: BorderRadius.circular(48)),
          ),
          const SizedBox(
            height: 8.0,
          ),
          if (widget.title.isNotEmpty)
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(height: 16.0),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              child: Text(
                widget.message,
                textAlign: widget.textAlign,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          if (widget.confirm)
            Row(
              children: <Widget>[
                Checkbox(
                  value: _confirmDeleteAction,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _confirmDeleteAction = value;
                    });
                  },
                ),
                Text(widget.confirmationText ??
                    "Marque esta caixa para confirmação!"),
              ],
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _negativeButton(context),
                _positiveButton(context),
                widget.showNeutralButton
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                          if (widget.neutralAction != null) {
                            widget.neutralAction!();
                          }
                        },
                        child: Text(
                          "${widget.neutralText}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic dialog function
dialog(
  BuildContext context,
  Color color,
  String title,
  String message,
  bool showNeutralButton,
  bool closeOnBackPress, {
  String? neutralText,
  Function? neutralAction,
  String positiveText = "Ok",
  Color? positiveTextColor,
  Function? positiveAction,
  String negativeText = "Cancelar",
  Color? negativeTextColor,
  Function? negativeAction,
  AlertDialogIcon? icon,
  confirm = false,
  textAlign = TextAlign.center,
  Widget? customIcon,
  String confirmationText = '',
}) {
  return showDialog(
    barrierDismissible: closeOnBackPress,
    context: context,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => closeOnBackPress,
      child: __AlertDialog(
        color: color,
        title: title,
        message: message,
        showNeutralButton: showNeutralButton,
        neutralText: neutralText,
        neutralAction: neutralAction,
        positiveText: positiveText,
        positiveTextColor: positiveTextColor,
        positiveAction: positiveAction,
        negativeText: negativeText,
        negativeTextColor: negativeTextColor,
        negativeAction: negativeAction,
        alertDialogIcon: icon,
        confirm: confirm,
        textAlign: textAlign,
        customIcon: customIcon,
        confirmationText: confirmationText,
      ),
    ),
  );
}

/// Success dialog
successDialog(
  BuildContext context,
  String message, {
  showNeutralButton = false,
  String positiveText = "Ok",
  Function? positiveAction,
  String negativeText = "Cancelar",
  Function? negativeAction,
  String? neutralText,
  Function? neutralAction,
  title = "Sucesso",
  closeOnBackPress = false,
  icon = AlertDialogIcon.SUCCESS_ICON,
  textAlign = TextAlign.center,
}) {
  return dialog(
    context,
    AlertDialogColors.SUCCESS,
    title,
    message,
    showNeutralButton,
    closeOnBackPress,
    neutralText: neutralText,
    neutralAction: neutralAction,
    positiveText: positiveText,
    positiveAction: positiveAction ?? () {},
    negativeText: negativeText,
    negativeAction: negativeAction,
    icon: icon,
    textAlign: textAlign,
  );
}

/// Error Dialog
errorDialog(
  BuildContext context,
  String message, {
  showNeutralButton = false,
  String positiveText = "Ok",
  Function? positiveAction,
  String negativeText = "Cancelar",
  Function? negativeAction,
  String? neutralText,
  Function? neutralAction,
  title = "Error",
  closeOnBackPress = false,
  icon = AlertDialogIcon.ERROR_ICON,
  textAlign = TextAlign.center,
}) {
  return dialog(
    context,
    AlertDialogColors.ERROR,
    title,
    message,
    showNeutralButton,
    closeOnBackPress,
    neutralText: neutralText,
    neutralAction: neutralAction,
    positiveText: positiveText,
    positiveAction: positiveAction ?? () {},
    negativeText: negativeText,
    negativeAction: negativeAction,
    icon: icon,
    textAlign: textAlign,
  );
}

/// Warning Dialog
warningDialog(
  BuildContext context,
  String message, {
  showNeutralButton = false,
  String positiveText = "Ok",
  Function? positiveAction,
  String negativeText = "Cancelar",
  Function? negativeAction,
  String? neutralText,
  Function? neutralAction,
  title = "Aviso",
  closeOnBackPress = false,
  icon = AlertDialogIcon.WARNING_ICON,
  textAlign: TextAlign.center,
}) {
  return dialog(
    context,
    AlertDialogColors.WARNING,
    title,
    message,
    showNeutralButton,
    closeOnBackPress,
    neutralText: neutralText,
    neutralAction: neutralAction,
    positiveText: positiveText,
    positiveAction: positiveAction,
    negativeText: negativeText,
    negativeAction: negativeAction ?? () {},
    icon: icon,
    textAlign: textAlign,
  );
}

/// Info Dialog
infoDialog(
  BuildContext context,
  String message, {
  showNeutralButton = false,
  String positiveText = "Ok",
  Function? positiveAction,
  String negativeText = "Cancelar",
  Function? negativeAction,
  String? neutralText,
  Function? neutralAction,
  title = "Informação",
  closeOnBackPress = false,
  icon = AlertDialogIcon.INFO_ICON,
  textAlign = TextAlign.center,
}) {
  return dialog(
    context,
    AlertDialogColors.INFO,
    title,
    message,
    showNeutralButton,
    closeOnBackPress,
    neutralText: neutralText,
    neutralAction: neutralAction,
    positiveText: positiveText,
    positiveAction: positiveAction ?? () {},
    negativeText: negativeText,
    negativeAction: negativeAction,
    icon: icon,
    textAlign: textAlign,
  );
}

/// Confirmation Dialog
confirmationDialog(
  BuildContext context,
  String message, {
  Color color = AlertDialogColors.WARNING,
  showNeutralButton = false,
  String positiveText = 'Ok',
  Color positiveTextColor = AlertDialogColors.ERROR,
  required Function positiveAction,
  String negativeText = "Cancelar",
  Color negativeTextColor = AlertDialogColors.WARNING,
  Function? negativeAction,
  String? neutralText,
  Function? neutralAction,
  title = "Confirmação?",
  closeOnBackPress = false,
  icon = AlertDialogIcon.HELP_ICON,
  confirm = false,
  textAlign = TextAlign.center,
  confirmationText = "Marque esta caixa\npara confirmação!",
}) {
  return dialog(
    context,
    color,
    title,
    message,
    showNeutralButton,
    closeOnBackPress,
    neutralText: neutralText,
    neutralAction: neutralAction,
    positiveText: positiveText,
    positiveTextColor: positiveTextColor,
    positiveAction: positiveAction,
    negativeText: negativeText,
    negativeTextColor: negativeTextColor,
    negativeAction: negativeAction ?? () {},
    icon: icon,
    confirm: confirm,
    textAlign: textAlign,
    confirmationText: confirmationText,
  );
}
