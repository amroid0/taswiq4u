
import 'package:flutter/material.dart';
import 'package:olx/pages/register_page.dart';

import 'login_page.dart';

class ParentAuthPage extends StatefulWidget {
  @override
  _ParentAuthPageState createState() => _ParentAuthPageState();
}

class _ParentAuthPageState extends State<ParentAuthPage>  with SingleTickerProviderStateMixin  {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController=new TabController(length: 2,vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
          DefaultTabController(
            length: 2,

            child: SizedBox(

              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 80,
                    child: TabBar(
                      tabs:  [
                        new Container(
                          width: 30.0,
                          child: new Tab(text: ''),
                        ),
                        new Container(
                          width: 30.0,
                          child: new Tab(text: ''),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        LoginPage(tabController: _tabController),
                        RegisterPage()

                      ],
                    ),
                  ),
                ],
              ),
                    ),
          )
      ),

    );

}
}
