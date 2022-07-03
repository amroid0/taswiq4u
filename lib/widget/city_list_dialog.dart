import 'package:flutter/material.dart';
import 'package:olx/data/bloc/country_bloc.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cityModel.dart';
import 'package:olx/utils/global_locale.dart';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, CityModel item, bool isSelected);

class CityListDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final void Function(CityModel) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;

  const CityListDialog({
    Key key,
    this.itemsList,
    this.showSearchBox,
    this.onChange,
    this.selectedValue,
    this.onFind,
    this.itemBuilder,
    this.searchBoxDecoration,
  }) : super(key: key);

  static Future<T> showModal<T>(
    BuildContext context, {
    List<T> items,
    String label,
    T selectedValue,
    bool showSearchBox,
    Future<List<T>> Function(String text) onFind,
    SelectOneItemBuilderType<T> itemBuilder,
    void Function(CityModel) onChange,
    InputDecoration searchBoxDecoration,
  }) {
    return showModalBottomSheet(
      context: context,
      elevation: 2,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 200,
          // title: Text(label ?? ""),
          // actions: <Widget>[
          //   FlatButton(child:Text(allTranslations.text('cancel')), onPressed: () {
          //     Navigator.of(context).pop();
          //   },)
          // ],
          child: CityListDialog<T>(
            selectedValue: selectedValue,
            itemsList: items,
            onChange: onChange,
            onFind: onFind,
            showSearchBox: showSearchBox,
            itemBuilder: itemBuilder,
            searchBoxDecoration: searchBoxDecoration,
          ),
        );
      },
    );
  }

  @override
  _SelectDialogState<T> createState() =>
      _SelectDialogState<T>(itemsList, onChange, onFind);
}

class _SelectDialogState<T> extends State<CityListDialog<T>> {
  CountryBloc bloc;
  void Function(CityModel) onChange;

  _SelectDialogState(
    List<T> itemsList,
    this.onChange,
    Future<List<T>> Function(String text) onFind,
  ) {}

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

    bloc.getCityList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .5,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: StreamBuilder<ApiResponse<List<CityModel>>>(
                stream: bloc.cityStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());
                        break;
                      case Status.COMPLETED:
                        // TODO: Handle this case.
                        List<CityModel> list = snapshot.data.data;
                        return ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (c, index) => Divider(
                            height: 0.5,
                            color: Colors.grey.shade500,
                          ),
                          itemBuilder: (context, index) {
                            var item = list[index];
                            if (widget.itemBuilder != null)
                              return InkWell(
                                child: widget.itemBuilder(context, item,
                                    item == widget.selectedValue),
                                onTap: () {
                                  onChange(item);
                                  Navigator.pop(context);
                                },
                              );
                            else
                              return ListTile(
                                title: Text(allTranslations.isEnglish
                                    ? item.englishDescription ?? item.name
                                    : item.arabicDescription ?? item.name),
                                selected: item == widget.selectedValue,
                                onTap: () {
                                  onChange(item);
                                  Navigator.pop(context);
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
}
