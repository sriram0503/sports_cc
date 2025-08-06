import 'package:flutter/material.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:sports_c/Reusable/color.dart';
import 'package:sports_c/Reusable/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

showLogoutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: whiteColor,
            titlePadding: const EdgeInsets.only(
              top: 12,
              left: 26,
            ),
            insetPadding: MediaQuery.of(context).size.width < 650
                ? const EdgeInsets.symmetric(horizontal: 20)
                : const EdgeInsets.symmetric(horizontal: 100),
            buttonPadding:
                const EdgeInsets.only(bottom: 15, left: 20, top: 0, right: 20),
            contentPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 10,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Logout ?",
              style: MediaQuery.of(context).size.width < 650
                  ? const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 2,
                      color: appPrimaryColor,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 2,
                      color: appPrimaryColor,
                    ),
            ),
            content: Text(
              "Are you sure to logout?",
              style: MediaQuery.of(context).size.width < 650
                  ? const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: greyColor,
                    )
                  : const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: greyColor,
                    ),
            ),
            actionsPadding: const EdgeInsets.all(20),
            actions: <Widget>[
              TextButton(
                child: Text("NOT NOW",
                    style: MediaQuery.of(context).size.width < 650
                        ? const TextStyle(
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
                        : const TextStyle(
                            color: greyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              Container(
                width: 100,
                height: MediaQuery.of(context).size.width < 650 ? 35 : 40,
                decoration: BoxDecoration(
                    color: appPrimaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: TextButton(
                    child: Text(
                      "LOGOUT",
                      style: MediaQuery.of(context).size.width < 650
                          ? const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14)
                          : const TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    onPressed: () async {
                      SharedPreferences sharedPreference =
                          await SharedPreferences.getInstance();
                      await sharedPreference.remove('userId');
                      await sharedPreference.remove('roleId');
                      await sharedPreference.remove('role');
                      //   Cart().clearCart();
                      //    Navigator.pushAndRemoveUntil(
                      //        context,
                      //        MaterialPageRoute(
                      //            builder: (context) => const LoginScreen()),
                      //        (route) => false);
                    }),
              ),
            ],
          );
        });
      });
}

/// show to build Error Notification Toast use CustomNavigate
class CustomNavigate {
  final String message;

  const CustomNavigate({
    required this.message,
  });

  static buildErrorNotification(BuildContext context, String message, {color}) {
    showSimpleNotification(
      Text(
        message,
        style: MediaQuery.of(context).size.width < 650
            ? MyTextStyle.f16(whiteColor, weight: FontWeight.w400)
            : MyTextStyle.f22(whiteColor, weight: FontWeight.w400),
      ),
      background: color ? greenColor : redColor,
      position: NotificationPosition.top,
      slideDismissDirection: DismissDirection.horizontal,
    );
  }
}
