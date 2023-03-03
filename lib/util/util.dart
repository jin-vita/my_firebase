import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Util {
  static void showSnackBar({title = '알림', message, seconds = 2}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: seconds),
    );
  }

  static void showTextDialog({
    title,
    titleStyle,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Text(
            title ?? '알림',
            style: titleStyle ??
                const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
          ),
        ),
      ),
    );
  }

  static void showYesNoDialog({
    title,
    titleStyle,
    noText,
    noStyle,
    yesText,
    yesStyle,
    required void Function() onNoPressed,
    required void Function() onYesPressed,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Transform.translate(
          offset: const Offset(0, 5),
          child: Transform.scale(
            scale: 1.3,
            child: Center(
              child: Text(
                title ?? '알림',
                style: titleStyle ??
                    const TextStyle(
                      fontSize: 15,
                      color: Colors.cyan,
                    ),
              ),
            ),
          ),
        ),
        // content: Text(message ?? '내용'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: MaterialButton(
                  height: 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  color: Colors.white,
                  onPressed: onNoPressed,
                  child: Text(
                    noText ?? '아니오',
                    style: yesStyle ??
                        const TextStyle(
                          fontSize: 14,
                          color: Colors.cyan,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: MaterialButton(
                  height: 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  color: Colors.cyan,
                  onPressed: onYesPressed,
                  child: Text(
                    yesText ?? '예',
                    style: noStyle ??
                        const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              // Transform.scale(
              //   scaleY: 1.2,
              //   child: Transform.translate(
              //     offset: const Offset(0, -3),
              //     child: Container(
              //       height: 50,
              //       width: 1.0,
              //       color: Colors.cyan,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  static void showLoadingDialog(context) {
    WillPopScope alert = WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10,
              ),
              child: const Text('데이터 처리중 ...'),
            ),
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => alert,
    );
  }
}
