import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/views/home.dart';
import 'package:theme_desiree/a/views/settings.dart';
import 'package:theme_desiree/a/views/cart.dart';
import 'package:theme_desiree/a/views/categories.dart';
import 'package:theme_desiree/address/add_address.dart';
import 'package:theme_desiree/address/address.dart';
import 'package:theme_desiree/address/address_model.dart';
import 'package:theme_desiree/address/edit_address.dart';

import 'package:theme_desiree/checkout/checkout_view.dart';
import 'package:theme_desiree/currency/currency_view.dart';
import 'package:theme_desiree/language/language_view.dart';
import 'package:theme_desiree/a/views/notification.dart';
import 'package:theme_desiree/orders/orders_view.dart';
import 'package:theme_desiree/a/views/search.dart';
import 'package:theme_desiree/showcase/showcase_view.dart';
import 'package:theme_desiree/a/views/theme.dart';
import 'package:theme_desiree/signin_opt/otp.dart';
import 'package:theme_desiree/signin_opt/signin_signup.dart';

class AppRoutes {
  static final routes = [
    GetPage(
        name: '/',
        //  page: () => OtpPage(contact: ''),
        page: () => HomeView(),
        transition: Transition.rightToLeft,
        curve: Curves.easeInOut,
        transitionDuration: Duration(milliseconds: 300),
        children: [
          GetPage(
            name: '/categories',
            page: () => Categories(),
            transition: Transition.rightToLeft,
            curve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/search',
            page: () => Search(),
            transition: Transition.rightToLeft,
            curve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/item',
            page: () => ShowcaseView(),
            transition: Transition.rightToLeft,
            curve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/checkout',
            page: () => CheckoutView(),
            transition: Transition.rightToLeft,
            curve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/cart',
            page: () => CartView(),
            transition: Transition.rightToLeft,
            curve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/settings',
            page: () => Settings(),
            transition: Transition.rightToLeft,
            curve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 300),
            children: [
              GetPage(
                name: '/profile',
                page: () => SigninPage(),

                //     page: () => ProfileView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/address',
                page: () => AddressPage(),

                //     page: () => ProfileView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/selectaddress',
                page: () => SelectAddress(),

                //     page: () => ProfileView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),

              GetPage(
                name: '/editaddress',
                page: () => EditAddress(address: Get.arguments as FullAddress),

                //     page: () => ProfileView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/OtpPage',
                page: () => OtpPage(contact: ''),

                //     page: () => ProfileView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/orders',
                page: () => OrdersView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),

              // GetPage(
              //   name: '/order-details',
              //   page: () => OrderDetailsView(),
              //   transition: Transition.rightToLeft,
              //   curve: Curves.easeInOut,
              //   transitionDuration: Duration(milliseconds: 300),
              // ),
              //  GetPage(
              //   name: '/SignupPage',
              //   page: () => SignupPage(),
              //   transition: Transition.rightToLeft,
              //   curve: Curves.easeInOut,
              //   transitionDuration: Duration(milliseconds: 300),
              // ),
              GetPage(
                name: '/currency',
                page: () => CurrencyView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/theme',
                page: () => ThemesView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/notification',
                page: () => NotificationView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
              GetPage(
                name: '/language',
                page: () => LanguageView(),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut,
                transitionDuration: Duration(milliseconds: 300),
              ),
            ],
          ),
        ]),
  ];
}
