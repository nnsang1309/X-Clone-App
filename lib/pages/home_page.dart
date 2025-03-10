import 'package:app/components/my_drawer.dart';
import 'package:app/components/my_input_alert_box.dart';
import 'package:app/components/my_post_tile.dart';
import 'package:app/helper/navigate_pages.dart';
import 'package:app/helper/toast_message.dart';
import 'package:app/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';

/*
  HOME PAGE

  This is a main page of this app: It displays a list of all posts.

  --------------------------------------------------------

  We can organise this page using a tab bar to split into:

  - for you page
  - following page

*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  // text controller
  final _messageControler = TextEditingController();

  // on start
  @override
  void initState() {
    super.initState();

    // load all posts
    loadAllPosts();
  }

  // load all posts
  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  // show post message dialog box
  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
          textController: _messageControler,
          hintText: "Content Post",
          onPressed: () async {
            if (_messageControler.text.isEmpty) {
              ToastMessage().showToast('The content is not empty', ToastType.failed);
              return;
            }
            //post in db
            await postMassage(_messageControler.text);
          },
          onPressedText: "Post"),
    );
  }

  // user post message
  Future<void> postMassage(String message) async {
    await databaseProvider.postMessage(message);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,

      // SCAFFOLD
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          drawer: MyDrawer(),

          // App Bar
          appBar: AppBar(
            centerTitle: true,
            title: const Text('H O M E'),
            foregroundColor: Theme.of(context).colorScheme.primary,
            bottom: TabBar(
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              // Tabs
              tabs: const [
                Tab(text: 'For you'),
                Tab(text: 'Following'),
              ],
            ),
          ),

          // Floatinh Action Button
          floatingActionButton: FloatingActionButton(
            onPressed: _openPostMessageBox,
            child: const Icon(Icons.add),
          ),

          // Body: list of all posts
          body: TabBarView(children: [
            _buildPostList(listeningProvider.allPosts),
            _buildPostList(listeningProvider.followingPosts),
          ])),
    );
  }

  // build list UI given a list of posts
  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ?
        // post list is empty
        const Center(
            child: Text("Nothing here..."),
          )
        :
        // post list is NOT empty
        ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // get each individual post
              final post = posts[index];

              // return Post Tile UI
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
