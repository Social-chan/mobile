import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:socialchan/models/chat.dart';
import 'package:socialchan/services/firebase_service.dart';
import 'package:socialchan/util/styles.dart';
import 'package:socialchan/widgets/settings.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo.shade300,
        backgroundColor: Colors.indigo.shade400,
      ),
      home: new ChatsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatsPage extends StatefulWidget {
  @override
  _ListChatsState createState() => new _ListChatsState();
}

class _ListChatsState extends State<ChatsPage> {
  List<Chat> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> chatSub;

  Widget _buildListItem(BuildContext context, Chat item) {
    // print(item);

    return ListTile(
      title: Text(item.title),
      subtitle: Text('hello world'),
      enabled: true,
      onTap: () => {},
      onLongPress: () => {},
      leading: CircleAvatar(
        backgroundColor: Colors.indigo.shade600,
        backgroundImage: NetworkImage(
          'https://randomuser.me/api/portraits/women/33.jpg',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    items = new List();

    chatSub?.cancel();
    chatSub = db.getNoteList().listen((QuerySnapshot snapshot) {
      final List<Chat> chats = snapshot.documents
          .map((documentSnapshot) => Chat.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = chats;
      });
    });
  }

  @override
  void dispose() {
    chatSub?.cancel();
    super.dispose();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          // title: Text(widget.title),
          titleSpacing: 60.0,
          centerTitle: true,
          title: TabBar(
            indicatorColor: primary,
            tabs: [
              Tab(icon: Icon(Icons.account_circle)),
              Tab(icon: Icon(Icons.supervised_user_circle)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {},
            )
          ],
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, items[index]),
            ),
            // ListView(
            //   children: <Widget>[
            //     ListTile(
            //       title: Text('Test 1'),
            //       subtitle: Text('hello world'),
            //       enabled: true,
            //       onTap: () => {},
            //       onLongPress: () => {},
            //       leading: CircleAvatar(
            //         backgroundColor: Colors.indigo.shade600,
            //         backgroundImage: NetworkImage(
            //           'https://randomuser.me/api/portraits/women/33.jpg',
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Test 1'),
                  enabled: true,
                  onTap: () => {},
                  onLongPress: () => {},
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade600,
                    child: Text('T1'),
                  ),
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Social menu',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(color: Colors.indigoAccent),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Inicio'),
                enabled: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble),
                title: Text('Chats'),
                enabled: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ajustes'),
                enabled: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
