import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key key,
    this.thumbnail,
    this.title,
    this.user,
    this.viewCount,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String user;
  final String viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _TitleDescription(
              title: title,
              user: user,
              viewCount: viewCount,
            ),
          ),
           Column(
             children: [
               Icon(
                 Icons.message,
                 size: 25.0,
               ),

               Icon(
                 Icons.list_alt,
                 size: 25.0,
               ),

               Icon(
                 Icons.cancel,
                 size: 25.0,
               ),

             ],
           ),
        ],
      ),
    );
  }
}

class _TitleDescription extends StatelessWidget {
  const _TitleDescription({
    Key key,
    this.title,
    this.user,
    this.viewCount,
  }) : super(key: key);

  final String title;
  final String user;
  final String viewCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            user,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$viewCount',
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
