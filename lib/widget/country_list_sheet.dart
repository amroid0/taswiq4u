import 'package:flutter/material.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/data/bloc/country_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/pages/main_page.dart';
import 'package:olx/utils/global_locale.dart';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, CountryEntity item, bool isSelected);

class CountryListSheet<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final void Function(CountryEntity) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;


  final String label;


  const CountryListSheet({
    Key key,
    this.itemsList,
    this.showSearchBox,
    this.onChange,
    this.selectedValue,
    this.onFind,
    this.itemBuilder,
    this.searchBoxDecoration,
    this.label
  }) : super(key: key);

  static Future<T> showModal<T>(
      BuildContext context, {
        List<T> items,
        String label,
        T selectedValue,
        bool showSearchBox,
        Future<List<T>> Function(String text) onFind,
        SelectOneItemBuilderType<T> itemBuilder,
        void Function(CountryEntity) onChange,
        InputDecoration searchBoxDecoration,
      }) {
     showModalBottomSheet(

      context: context,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(10.0),
           topRight: Radius.circular(10.0),
         ),
       ),
      builder: (context) {
        return CountryListSheet<T>(
          selectedValue: selectedValue,
          itemsList: items,
          onChange: onChange,
          onFind: onFind,
          showSearchBox: showSearchBox,
          itemBuilder: itemBuilder,
          searchBoxDecoration: searchBoxDecoration,
          label: label,
        );
      },
    );
  }

  @override
  _SelectDialogState<T> createState() =>
      _SelectDialogState<T>(itemsList, onChange, onFind);
}

class _SelectDialogState<T> extends State<CountryListSheet<T>> {
  CountryBloc bloc;
  void Function(CountryEntity) onChange;
  String cont ;
  int  i ;

  var _slectedCountry=-1;

  _SelectDialogState(
      List<T> itemsList,
      this.onChange,
      Future<List<T>> Function(String text) onFind,
      ) {
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CountryBloc();
    getGroupId();
    bloc.getCountryList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 20,),
          Text(widget.label,style: TextStyle(
              color: Colors.black,
              fontSize: 18
          ),),
          Expanded(
            child: Scrollbar(
              child: StreamBuilder<ApiResponse<List<CountryEntity>>>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if(snapshot.data!=null){
                    switch(snapshot.data.status){
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());
                        break;
                      case Status.COMPLETED:
                      // TODO: Handle this case.
                        List<CountryEntity> list=snapshot.data.data;
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var item = list[index];
                            if (widget.itemBuilder != null)
                              return InkWell(
                                child: widget.itemBuilder(
                                    context, item, item == widget.selectedValue),
                                onTap: () {

                                  onChange(item);
                                  Navigator.pop(context);

                                },
                              );
                            else
                              return   GestureDetector(
                                onTap: (){
                                  preferences.clearCity();
                                  onChange(item);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                    ),
                                    child: ListTile(

                                       leading:  Image.asset(
                                         item.countryId==1?'images/egypt_square.png':'images/kuwait_square.png',
                                         width: 60,
                                         height: 40,
                                         fit: BoxFit.fill,
                                       ),
                                      title: Text(
                                        allTranslations.isEnglish?item.englishDescription.toString():item.arabicDescription,
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                      ),

                                    ),
                                  ),
                                ),
                              );
                              return RadioListTile(
                                value: item.countryId,
                                groupValue:i,
                                title: Text(allTranslations.isEnglish?item.englishDescription.toString():item.arabicDescription),
                                selected: item == widget.selectedValue,
                                onChanged: (val) {
                                  preferences.clearCity();
                                  onChange(item);
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                      MainScreen()), (Route<dynamic> route) => false);
                                },
                              );
                          },
                        );









                        break;
                      case Status.ERROR:
                        return Center(child: Text("Oops"));
                        break;
                    }
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  void getGroupId() async{
    cont = await preferences.getCountryID() ;
    i = int.parse(cont);

    print("group  value"+cont);
  }
}