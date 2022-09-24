import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/cubit.dart';
import 'package:news_app/cubit/states.dart';
import 'package:news_app/network/remote/dio_helper.dart';
import 'package:news_app/widgets/widgets.dart';

import '../screens/search_screen.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);
  static const routeName = '/newsLayout';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      builder: (context, state) {
        final newsCubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('News App'),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen.routeName);
                },
                icon: Icon(
                  Icons.search,
                ),
              ),
              IconButton(
                  onPressed: () {
                    NewsCubit.get(context).changeTheme();
                  },
                  icon: Icon(Icons.brightness_4_outlined))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: newsCubit.currentIndex,
            onTap: newsCubit.changeBottomNavigation,
            items: newsCubit.items,
          ),
          body: newsCubit.screens[newsCubit.currentIndex],
        );
      },
      listener: (context, state) {},
    );
  }
}
