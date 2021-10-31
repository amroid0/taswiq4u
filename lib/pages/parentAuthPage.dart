
import 'package:flutter/material.dart';
import 'package:olx/pages/register_page.dart';

import 'login_page.dart';

class ParentAuthPage extends StatefulWidget {
  int login = 0 ;

  ParentAuthPage({this.login});
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
      backgroundColor: Colors.white,

      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
          DefaultTabController(
            length: 2,

            child: SizedBox(

              child: Column(
                children: <Widget>[
                  SizedBox(height: 16,),

                  Container(
              height: 70,
                  width: 120,
                  child: Image.asset('images/logo.png')),

                  Stack(
                    children: [
                      Positioned.fill(child: Container(decoration:  BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 4.0,
                          ),
                        ),
                      ),)),

                      Container(
                        width: 80,
                        child: TabBar(
                          indicatorColor: Colors.green,
                          indicator:
                          UnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 4.0,
                            ))
                          ,

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
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        LoginPage(tabController: _tabController,home:widget.login,),
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
