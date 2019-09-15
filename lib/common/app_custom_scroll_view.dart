import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppCustomScrollView extends StatefulWidget {
  AppCustomScrollView();

  _AppCustomScrollView createState() => _AppCustomScrollView();
}

class NestedTestingObject{
  NestedTestingObject({this.testingObjectId, this.text});

  final int testingObjectId;
  final String text;
}

class TestingObject{
  TestingObject({this.id, this.text, this.isSelected = false});

  final int id;
  final String text;
  final bool isSelected;
}

class _AppCustomScrollView extends State<AppCustomScrollView> {
  _AppCustomScrollView();

  ///pass this into children so they can update the list from their own instance
  callback(newSliver, index){
    setState(() {
      sliverItems.insert(index, newSliver);
    });
  }

  List<TestingObject> objectItems = [
    TestingObject(id: 1, text: 'Object 1'),
    TestingObject(id: 2, text: 'Object 2'),
    TestingObject(id: 3, text: 'Object 3'),
    TestingObject(id: 4, text: 'Object 4'),
    TestingObject(id: 5, text: 'Object 5'),
  ];

  List<NestedTestingObject> nestedTestingItems = [
    NestedTestingObject(testingObjectId: 1, text: 'Inner thang 1'),
    NestedTestingObject(testingObjectId: 1, text: 'Inner thang 3'),
    NestedTestingObject(testingObjectId: 1, text: 'Inner thang 5'),
  ];

  List<String> items = [
    "1",
    "2",
    "3","4","5"
  ];

  Map<String, bool> rItems = {
    "1": false,
    "2": false,
    "3": false,
    "4": false,
    "5": false
  };

  List<String> subItems = [
    '1-1','1-2','1-3'
  ];

  Map<String, bool> rSubItems = {
    "inner 1": true,
    "inner 2": true,
    "inner 3": true,
  };

  List<Widget> sliverItems = [
    SliverAppBar(
      title: Text('SliverAppBar'),
      backgroundColor: Colors.green,
      floating: true,
      expandedHeight: 75.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: Colors.green,)
      ),
    ),
    AppSliverPersistentHeader(),
    ///this breaks it
    /*CustomScrollView(
      slivers: <Widget>[
        AppSliverFixedExtentList()
      ],
    ),*/
    //AppSliverNestedFixedExtentList(), //also breaks it
    ///to add the nested items on tap:
    ///Need to find a way to use a builder function here or make one
    ///within the builder function do something like
    ///itemBuilder: (context, index) {
    //            final item = titles[index];
    //            return Card(
    //              child: ListTile(
    //                title: Text(item),
    //
    //                onTap: () { //                                  <-- onTap
    //                  setState(() {
    //                    titles.insert(index, 'Planet'); <--- insert all or just 5 related items here
    //                  });
    //                },
    //
    //                onLongPress: () { //                            <-- onLongPress
    //                  setState(() {
    //                    titles.removeAt(index);
    //                  });
    //                },
    //
    //              ),
    //            );
    //          },
    AppSliverPersistentHeader(),
    AppSliverFixedExtentList(),
    AppSliverPersistentHeader(),
    //AppSliverNestedFixedExtentList()
  ];

  void addItems(int index){
    setState(() {
      items.insertAll(index + 1, subItems);
    });
  }

  void removeItems(int index){
    setState(() {
      items.removeRange(index + 1, index + 1 + subItems.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFixedExtentList(
          itemExtent: 75,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index){
              return FlatButton(
                onPressed: (){
                  if(index == 1){
                    addItems(index);
                  }
                },
                child: SliverData(
                  key: ValueKey<String>(objectItems[index].text),
                  isNested: items[index].length > 1,
                  data: items[index],
                ),
              );
              /*if(index.isOdd){
                return Container(
                  height: 75,
                  color: Colors.blueGrey[300],
                  child: ListTile(
                    title: Text("Project $index (${items[index]})"),
                  ),
                );
              }else{
                return Container(
                  color: Colors.green[300],
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Work item $index (${items[index]})"),
                  ),
                );
              }*/
            },
            childCount: objectItems.length,
            findChildIndexCallback: (Key key){
              final ValueKey<String> valueKey = key;
              return objectItems.indexWhere((objectItem) => objectItem.text == valueKey.value);
              //return items.indexOf(valueKey.value);
            }
          ),
        ),
      ],
    );
  }
}

class SliverData extends StatefulWidget {
  const SliverData({Key key, this.data, this.isNested = false}) : super(key: key);

  final bool isSelected = false;
  final bool isNested;
  final String data;

  @override
  _SliverDataState createState() => _SliverDataState();
}

class _SliverDataState extends State<SliverData> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(widget.isNested){
      return Container(
        color: Colors.blueGrey[100],
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(widget.data),
          leading: Icon(Icons.info),
        ),
      );
    }else{
      return Container(
        color: Colors.green[300],
        child: ListTile(
          title: Text(widget.data),
          leading: Icon(Icons.map),
        ),
      );
    }
  }
}

class NestedSliverData extends StatefulWidget {
  const NestedSliverData({Key key, this.data}) : super(key: key);

  final String data;

  @override
  _NestedSliverDataState createState() => _NestedSliverDataState();
}

class _NestedSliverDataState extends State<NestedSliverData> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.blueGrey[100],
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(widget.data),
        leading: Icon(Icons.info),
      ),
    );
  }
}

class AppSliverPersistentHeader extends StatelessWidget {
  AppSliverPersistentHeader();

  final int index = 0; //find way to get index on all every sliver?

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: _SliverAppBarDelegate(
        height: 175, //project cards are 165 right now
        child: FlatButton(
          onPressed: (){
            //do somethin
          },
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor: Colors.green,
              onTap: (){
                //don't need this?
              },
              child: Container(
                color: Colors.red[200],
                child: Center(child: Text('Persistent Header')),
              )
            )),
        )
      ),
    );
  }
}

class AppSliverList extends StatelessWidget {
  AppSliverList();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      //SliverChildBuilderDelegate
      delegate: SliverChildListDelegate(
        [
          Container(color: Colors.lightBlue, height: 75),
          Container(color: Colors.deepPurpleAccent, height: 90),
          Container(color: Colors.redAccent, height: 100),
        ],
      ),
    );
  }
}

class AppSliverFixedExtentList extends StatelessWidget {
  AppSliverFixedExtentList();

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 75,
      delegate: SliverChildListDelegate(
        [
          ///this breaks it
          /*SliverFixedExtentList(
            itemExtent: 75,
            delegate: SliverChildListDelegate(
              [
                Container(color: Colors.black, child: Center(child: Text('inner fixed extent list'))),
                Container(color: Colors.blueGrey, child: Center(child: Text('inner fixed extent list'))),
                Container(color: Colors.orange, child: Center(child: Text('inner fixed extent list'))),
              ],
            ),
          ),*/
          Container(color: Colors.lightBlue, child: Center(child: Text('fixed extent list'))),
          Container(color: Colors.deepPurpleAccent, child: Center(child: Text('fixed extent list'))),
          Container(color: Colors.redAccent, child: Center(child: Text('fixed extent list'))),
        ],
      ),
    );
  }
}

class AppSliverNestedFixedExtentList extends StatelessWidget {
  AppSliverNestedFixedExtentList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: SliverFixedExtentList(
        itemExtent: 75,
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            return ListTile(
              title: Text("Item $index"),
            );
          },
          childCount: 10
        ),
        /*delegate: SliverChildListDelegate(
          [
            Container(color: Colors.lightBlue, child: Center(child: Text('fixed extent list'))),
            Container(color: Colors.deepPurpleAccent, child: Center(child: Text('fixed extent list'))),
            Container(color: Colors.redAccent, child: Center(child: Text('fixed extent list'))),
          ],
        ),*/
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.height,
    @required this.child,
  });

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class AppNestedScrollView extends StatelessWidget {
  AppNestedScrollView();

  final List<String> _tabs = [
    'tab 1',
    'tab 2',
    'tab3'
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          //these are the slivers that show up in the outer scroll view
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
                title: Text('title'),
                pinned: true,
                expandedHeight: 150,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(tabs: _tabs.map((String name) => Tab(text: name)).toList(),
              ),
            )
            )
          ];
        },
        body: TabBarView(
        // These are the contents of the tab views, below the tabs.
        children: _tabs.map((String name) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Builder(
              // This Builder is needed to provide a BuildContext that is "inside"
              // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
              // find the NestedScrollView.
              builder: (BuildContext context) {
              return CustomScrollView(
                // The "controller" and "primary" members should be left
                // unset, so that the NestedScrollView can control this
                // inner scroll view.
                // If the "controller" property is set, then this scroll
                // view will not be associated with the NestedScrollView.
                // The PageStorageKey should be unique to this ScrollView;
                // it allows the list to remember its scroll position when
                // the tab view is not on the screen.
                key: PageStorageKey<String>(name),
                slivers: <Widget>[
                  SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber above.
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    // In this example, the inner scroll view has
                    // fixed-height list items, hence the use of
                    // SliverFixedExtentList. However, one could use any
                    // sliver widget here, e.g. SliverList or SliverGrid.
                    sliver: SliverFixedExtentList(
                      // The items in this example are fixed to 48 pixels
                      // high. This matches the Material Design spec for
                      // ListTile widgets.
                      itemExtent: 48.0,
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        // This builder is called for each child.
                        // In this example, we just number each list item.
                        return ListTile(
                          title: Text('Item $index'),
                          );
                        },
                        // The childCount of the SliverChildBuilderDelegate
                        // specifies how many children this inner list
                        // has. In this example, each tab has a list of
                        // exactly 30 items, but this is arbitrary.
                        childCount: 30,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            );
          }).toList(),
        )
      )
    );
  }
}
