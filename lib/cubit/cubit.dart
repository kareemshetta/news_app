import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/network/local/cach_helper.dart';

import '../cubit/states.dart';
import '../screens/business_screen.dart';
import '../screens/science_screen.dart';
import '../screens/sports_screen.dart';

import '../network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(InitialState());
  static NewsCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  int currentIndex = 0;
  void changeBottomNavigation(int index) async {
    if (index == 0) {
      await getBusiness();
    } else if (index == 1) {
      await getScience();
    } else if (index == 2) {
      await getSports();
    }
    currentIndex = index;
    emit(BottomNavigationState());
  }

  ThemeMode themMode = ThemeMode.light;
  bool isDark = false;

  void changeTheme() async {
    isDark = !isDark;
    await CacheHelper.setBoolean(key: 'isDark', value: isDark);
    emit(NewsChangeAppThemeState());
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
        icon: Icon(Icons.business_center), label: 'Business'),
    BottomNavigationBarItem(
        icon: Icon(Icons.science_outlined), label: 'Science'),
    BottomNavigationBarItem(icon: Icon(Icons.sports_baseball), label: 'Sports'),
  ];
  List<Widget> screens = [
    BusinessScreen(),
    ScienceScreen(),
    SportsScreen(),
  ];
  // here we create list of dynamic because data which returned is in a form of list<dynamic>
  List<dynamic> business = [];
  Future<void> getBusiness() async {
    // here we check if business list is not empty which mean that this method is called before
    // so don't have to get data again
    // and emit the state of  NewsGetBusinessSuccessState
    if (business.isNotEmpty) {
      emit(NewsGetBusinessSuccessState());
    } else {
      try {
        emit(NewsGetBusinessLoadingState());
        final response =
            await DioHelper.getData(url: 'v2/top-headlines', queries: {
          'country': 'eg',
          'category': 'business',
          'apiKey': '89f3ae7d98e9427785e2e183a53588f4'
        });

        final art = response.data['articles'];
        business = art;
        print('length of list:${(response.data['articles'] as List).length}');
        print(business[0]['title']);
        emit(NewsGetBusinessSuccessState());
      } catch (e) {
        print(e);
        emit(NewsGetBusinessErrorState(e.toString()));
      }
    }
  }

  List<dynamic> sports = [];
  Future<void> getSports() async {
    if (sports.isNotEmpty) {
      emit(NewsGetSportsSuccessState());
    } else {
      try {
        emit(NewsGetSportsLoadingState());
        final response =
            await DioHelper.getData(url: 'v2/top-headlines', queries: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': '89f3ae7d98e9427785e2e183a53588f4'
        });

        final art = response.data['articles'];
        sports = art;
        print('length of list:${(response.data['articles'] as List).length}');
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      } catch (e) {
        print(e);
        emit(NewsGetSportsErrorState(e.toString()));
      }
    }
  }

  List<dynamic> science = [];
  Future<void> getScience() async {
    if (science.isNotEmpty) {
      emit(NewsGetScienceSuccessState());
    } else {
      try {
        emit(NewsGetScienceLoadingState());
        final response =
            await DioHelper.getData(url: 'v2/top-headlines', queries: {
          'country': 'eg',
          'category': 'science',
          'apiKey': '89f3ae7d98e9427785e2e183a53588f4'
        });

        final art = response.data['articles'];
        science = art;
        print('length of list:${(response.data['articles'] as List).length}');
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      } catch (e) {
        print(e);
        emit(NewsGetScienceErrorState(e.toString()));
      }
    }
  }

  List<dynamic> search = [];
  Future<void> getSearch({required String value}) async {
    try {
      emit(NewsGetSearchLoadingState());
      final response = await DioHelper.getData(
          url: 'v2/everything/',
          queries: {'q': value, 'apiKey': '89f3ae7d98e9427785e2e183a53588f4'});

      final art = response.data['articles'];
      search = art;
      print('length of list:${(response.data['articles'] as List).length}');
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    } catch (e) {
      print(e);
      emit(NewsGetSearchErrorState(e.toString()));
    }
  }
}
