import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/screens/web_view_screen.dart';

Widget buildNewsCard(data, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WebViewScreen(
            data['url'],
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['urlToImage'] != null)
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(data['urlToImage']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      data['title'],
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(data['publishedAt']))
                        .toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildListConditionally(List<dynamic> tasks, BuildContext context,
    {bool isSearch = false}) {
  return tasks.isNotEmpty
      ? ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (ctx, index) {
            return buildNewsCard(tasks[index], context);
          },
          separatorBuilder: (ctx, index) {
            return buildHorizontalDivider();
          },
          itemCount: tasks.length)
      : isSearch
          ? Container()
          : Center(
              child: CircularProgressIndicator(),
            );
}

Widget buildHorizontalDivider() {
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    ),
  );
}

Widget buildDefaultTextFormField(
    {required TextEditingController controller,
    required String? Function(String? value)? validator,
    bool isPassword = false,
    bool isEnable = true,
    void Function()? onTap,
    void Function(String value)? onChange,
    required String labelText,
    TextInputType keyBoardType = TextInputType.text,
    Widget? suffixIcon,
    Widget? prefixIcon}) {
  return TextFormField(
    enabled: isEnable,
    onChanged: onChange,
    onTap: onTap,
    controller: controller,
    validator: validator,
    obscureText: isPassword,
    keyboardType: keyBoardType,
    decoration: InputDecoration(
      label: Text(labelText),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(),
    ),
  );
}

void navigateTo(context, String routeName) {
  Navigator.of(context).pushNamed(routeName);
}
