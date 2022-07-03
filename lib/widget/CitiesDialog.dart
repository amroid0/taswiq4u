import 'package:flutter/material.dart';
import 'package:olx/data/bloc/country_bloc.dart';
import 'package:olx/model/Cities.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/utils/global_locale.dart';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, Cities item, bool isSelected);

class CitiesListDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final void Function(Cities) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;
  final int c_id;

  const CitiesListDialog(
      {Key key,
      this.itemsList,
      this.showSearchBox,
      this.onChange,
      this.selectedValue,
      this.onFind,
      this.itemBuilder,
      this.searchBoxDecoration,
      this.c_id})
      : super(key: key);

  static Future<T> showModal<T>(
    BuildContext context, {
    List<T> items,
    String label,
    int id,
    T selectedValue,
    bool showSearchBox,
    Future<List<T>> Function(String text) onFind,
    SelectOneItemBuilderType<T> itemBuilder,
    void Function(Cities) onChange,
    InputDecoration searchBoxDecoration,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: CitiesListDialog<T>(
            selectedValue: selectedValue,
            itemsList: items,
            onChange: onChange,
            c_id: id,
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

class _SelectDialogState<T> extends State<CitiesListDialog<T>> {
  CountryBloc bloc;
  void Function(Cities) onChange;

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

    bloc.getAllCities(widget.c_id);
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
              child: StreamBuilder<ApiResponse<List<Cities>>>(
                stream: bloc.citiesStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());
                        break;
                      case Status.COMPLETED:
                        // TODO: Handle this case.
                        List<Cities> list = snapshot.data.data;
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
                                    ? item.englishName ?? item.name
                                    : item.arabicName ?? item.name),
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
