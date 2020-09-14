import 'package:flutter/material.dart';
import 'package:pratilipi_assignment/common/provider/app_info.dart';
import 'package:pratilipi_assignment/story/provider/story.dart';
import 'package:provider/provider.dart';

class StoryPage extends StatelessWidget {
  final String storyId;

  StoryPage({@required this.storyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: StoryProvider(
        storyId: storyId,
        user: Provider.of<AppInfoProvider>(context).user,
      ),
      child: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            Provider.of<StoryProvider>(context, listen: false).removeViewer();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Story"),
            ),
            body: StoryContents(),
          ),
        ),
      ),
    );
  }
}

class StoryContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoryProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.story?.title ?? "",
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
                Counters(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                provider.story?.content ?? "",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.9),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Counters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoryProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    provider.story?.allReads?.length?.toString() ?? '0',
                    style: TextStyle(fontSize: 20),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text("Total Reads"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    provider.story?.viewing?.length?.toString() ?? '0',
                    style: TextStyle(fontSize: 20),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text("Currently viewing"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
