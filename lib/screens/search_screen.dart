import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/cubit.dart';
import 'package:news_app/cubit/states.dart';
import 'package:news_app/widgets/widgets.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  static const String routeName = '/searchPage';
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = NewsCubit.get(context);
    return BlocConsumer<NewsCubit, NewsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Search'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Column(children: [
                TextField(
                  onSubmitted: (value) async {
                    await cubit.getSearch(value: value);
                  },
                  decoration: InputDecoration(
                    label: Text('Search'),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: buildListConditionally(cubit.search, context,
                      isSearch: true),
                )
              ]),
            ),
          );
        },
        listener: (context, state) {});
  }
}
