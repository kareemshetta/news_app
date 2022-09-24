import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/cubit/states.dart';
import 'package:news_app/layout/news_layout.dart';
import 'package:news_app/network/local/cach_helper.dart';
import 'package:news_app/network/remote/dio_helper.dart';
import 'package:news_app/screens/search_screen.dart';

import 'cubit/cubit.dart';
import 'cubit/observer_cubit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  runApp(MyApp(isDark ?? false));
}

class MyApp extends StatelessWidget {
  const MyApp(this.isPrefDark, {Key? key}) : super(key: key);
  final bool isPrefDark;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()
        ..getBusiness()
        ..isDark = isPrefDark,
      child: BlocConsumer<NewsCubit, NewsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'News App',
            darkTheme: ThemeData(
              textTheme: TextTheme(
                headline6:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              scaffoldBackgroundColor: HexColor('333739'),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.deepOrange),
              appBarTheme: AppBarTheme(
                backgroundColor: HexColor('333739'),
                elevation: 0.0,
                // so we can change theme of  the statusbar
                systemOverlayStyle: SystemUiOverlayStyle(
                  // Status bar color
                  statusBarColor: HexColor('333739'),
                  // statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  elevation: 20.0,
                  backgroundColor: HexColor('333739'),
                  selectedItemColor: Colors.deepOrange,
                  unselectedItemColor: Colors.grey),
              primarySwatch: Colors.deepOrange,
            ),
            themeMode: NewsCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: ThemeData(
              textTheme: TextTheme(
                headline6:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              scaffoldBackgroundColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.deepOrange),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0.0,
                // so we can change theme of  the statusbar
                systemOverlayStyle: SystemUiOverlayStyle(
                  // Status bar color
                  statusBarColor: Colors.white,
                  // statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  elevation: 20.0,
                  selectedItemColor: Colors.deepOrange),
              primarySwatch: Colors.deepOrange,
            ),
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: NewsLayout(),
            ),
            routes: {
              SearchScreen.routeName: (context) => SearchScreen(),
              NewsLayout.routeName: (context) => NewsLayout(),
            },
          );
        },
      ),
    );
  }
}
