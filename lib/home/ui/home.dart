import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pratilipi_assignment/common/provider/app_info.dart';
import 'package:pratilipi_assignment/home/provider/home.dart';
import 'package:pratilipi_assignment/home/ui/login_form.dart';
import 'package:pratilipi_assignment/home/ui/register_form.dart';
import 'package:pratilipi_assignment/story/ui/story.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeProvider(),
      child: HomeContentsWrapper(),
    );
  }
}

class HomeContentsWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          provider.isSignedIn
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      provider.user.username,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              : Container(),
          provider.isSignedIn
              ? Container()
              : Builder(
                  builder: (sContext) => IconButton(
                    icon: Icon(Icons.login),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Login",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.cancel_sharp),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ),
                                LoginForm(sContext),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          provider.isSignedIn
              ? Container()
              : Builder(
                  builder: (sContext) => IconButton(
                    icon: Icon(Icons.app_registration),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sign Up",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.cancel_sharp),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ),
                                RegisterForm(sContext),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          !provider.isSignedIn
              ? Container()
              : Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      provider.signOut();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Signed out!')),
                      );
                    },
                  ),
                ),
        ],
      ),
      body: HomeContents(),
    );
  }
}

class HomeContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    return provider.stories.keys.length == 0
        ? Container()
        : Center(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.portrait ||
                        provider.stories.keys.length == 1
                    ? 1
                    : 2,
                childAspectRatio: 4 * MediaQuery.of(context).size.aspectRatio,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              shrinkWrap: true,
              itemCount: provider.stories.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => StoryPage(
                          storyId: provider.stories.keys.toList()[index],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider
                              .stories[provider.stories.keys.toList()[index]]
                              .title,
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                        ),
                        Text(
                          provider
                                  .stories[
                                      provider.stories.keys.toList()[index]]
                                  .content
                                  .substring(0, 150) +
                              '...',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color
                                    .withOpacity(0.4),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
