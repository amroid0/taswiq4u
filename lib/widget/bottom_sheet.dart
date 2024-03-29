import 'package:flutter/material.dart';
import 'package:olx/data/bloc/cateogry_bloc.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/utils/global_locale.dart';

typedef Widget SelectOneItemBuilderType<T>(
    BuildContext context, CateogryEntity item, bool isSelected);

class SelectBottom<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> itemsList;
  final bool showSearchBox;
  final void Function(CateogryEntity) onChange;
  final Future<List<T>> Function(String text) onFind;
  final SelectOneItemBuilderType<T> itemBuilder;
  final InputDecoration searchBoxDecoration;

  const SelectBottom({
    Key key,
    this.itemsList,
    this.showSearchBox,
    this.onChange,
    this.selectedValue,
    this.onFind,
    this.itemBuilder,
    this.searchBoxDecoration,
  }) : super(key: key);

  static Future<T> showBottom<T>(
    BuildContext context, {
    List<T> items,
    String label,
    T selectedValue,
    bool showSearchBox,
    Future<List<T>> Function(String text) onFind,
    SelectOneItemBuilderType<T> itemBuilder,
    void Function(CateogryEntity) onChange,
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
          height: MediaQuery.of(context).size.height * 0.8,
          //     elevation: 0,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // title: Text(label ?? ""),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text(allTranslations.text('cancel')),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   )
          // ],
          child: SelectBottom<T>(
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
  _SelectBottomState<T> createState() =>
      _SelectBottomState<T>(itemsList, onChange, onFind);
}

class _SelectBottomState<T> extends State<SelectBottom<T>> {
  CategoryBloc bloc;
  void Function(CateogryEntity) onChange;

  _SelectBottomState(
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
    bloc = CategoryBloc();

    bloc.submitQuery("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .7,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: StreamBuilder<List<CateogryEntity>>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text("Something wrong"));
                  else if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.data.isEmpty)
                    return Center(child: Text("No data found"));
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (c, index) => Divider(
                      height: 0.5,
                      color: Colors.grey.shade500,
                    ),
                    itemBuilder: (context, index) {
                      var item = snapshot.data[index];
                      if (widget.itemBuilder != null)
                        return InkWell(
                          child: widget.itemBuilder(
                              context, item, item == widget.selectedValue),
                          onTap: () {
                            if (item.hasSub) {
                              bloc.addCateogryToStack(item);
                            } else {
                              onChange(item);
                              Navigator.pop(context);
                            }
                          },
                        );
                      else
                        return ListTile(
                          title: Text(allTranslations.isEnglish
                              ? item.englishDescription.toString()
                              : item.arabicDescription.toString()),
                          selected: item == widget.selectedValue,
                          trailing: item.hasSub
                              ? Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.black87,
                                  size: 30,
                                )
                              : SizedBox(),
                          onTap: () {
                            if (item.hasSub) {
                              bloc.addCateogryToStack(item);
                            } else {
                              onChange(item);
                              Navigator.pop(context);
                            }
                          },
                        );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
