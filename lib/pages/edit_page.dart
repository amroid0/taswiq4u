import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/edit_bloc.dart';
import 'package:olx/data/bloc/upload_image_bloc.dart';
import 'package:olx/model/Cities.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/cityModel.dart';
import 'package:olx/model/edit_field_property.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/dailogs.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';
import 'package:olx/widget/CitiesDialog.dart';
import 'package:olx/widget/bottom_sheet.dart';
import 'package:olx/widget/check_box_withlabel.dart';
import 'package:olx/widget/city_list_dialog.dart';
import 'package:olx/widget/mutli_select_chip_dialog.dart';
import 'package:olx/widget/progress_dialog.dart';
import 'package:olx/widget/text_field_decoration.dart';

import 'ImageUploaderListPage.dart';

class EditPage extends StatefulWidget {
  var detail;

  EditPage(this.detail);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  EditBloc bloc = null;
  List<int> _selectedFieldValue = [];
  List<Color> _colorFieldValue = [];
  AdsPostEntity adsPostEntity = AdsPostEntity();
  final _formKey = GlobalKey<FormState>();
  bool isNeogtiable = false;
  String text = "";
  List<String> adsStateList = ["جديد", "مستعمل"];
  String selectedAdsStates = "جديد";
  final TextEditingController _cattextController = TextEditingController();
  final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _pricetextController = TextEditingController();
  final TextEditingController _phonetextController = TextEditingController();
  final TextEditingController _emailtextController = TextEditingController();
  final TextEditingController _desctextController = TextEditingController();
  final TextEditingController _citytextController = TextEditingController();
  final TextEditingController _citiestextController = TextEditingController();

  Color adNameColor,
      descColor,
      priceColor,
      emailColor,
      phoneColor,
      categoryColor,
      cityColor = Colors.grey;
  GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  List<TextEditingController> contollers = List();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UploadImageBloc uploadBloc;

  ProgressDialog progressDialog;

  List<List> _multiselectedFieldValue =
      List<List<FieldProprtiresSpecificationoption>>();

  var adsObj;
  bool isVisiable = false;
  int cityID = 0;
  bool isFirst = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _nametextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = EditBloc();
    uploadBloc = UploadImageBloc();
    bloc.addStream.listen((data) {
      // Redirect to another view, given your condition
      switch (data.status) {
        case Status.LOADING:
          Future.delayed(Duration.zero, () {
            DialogBuilder(context).showLoadingIndicator('loading');
          });
          break;
        case Status.COMPLETED:
          DialogBuilder(context).hideOpenDialog();

          var isLogged = data as ApiResponse<bool>;
          var isss = isLogged.data;
          if (isss) {
            Fluttertoast.showToast(
                msg: "Sucessfully Edit'",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(context);
          }

          break;
        case Status.ERROR:
          DialogBuilder(context).hideOpenDialog();

          Fluttertoast.showToast(
              msg: "Something went Wrong'",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
      }
      setState(() {});
    });

    _cattextController.addListener(() {
      bool isvalid = _emptyValidate(_cattextController.value.text) == null;
      setState(() {
        categoryColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
    });

    _citytextController.addListener(() {
      bool isvalid = _emptyValidate(_citytextController.value.text) == null;
      setState(() {
        cityColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
    });
    _pricetextController.addListener(() {
      bool isvalid = _emptyValidate(_pricetextController.value.text) == null;
      setState(() {
        priceColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
    });

    _phonetextController.addListener(() {
      bool isvalid = _phoneValidate(_phonetextController.value.text) == null;
      setState(() {
        phoneColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
    });
    adsObj = widget.detail;

    _nametextController.text =
        allTranslations.isEnglish ? adsObj.EnglishTitle : adsObj.ArabicTitle;
    _desctextController.text = allTranslations.isEnglish
        ? adsObj.EnglishDescription
        : adsObj.ArabicDescription;
    _pricetextController.text =
        adsObj.Price == 0 ? "" : adsObj.Price.toString();
    _phonetextController.text =
        adsObj.UserPhone != null && adsObj.UserPhone.isNotEmpty
            ? adsObj.UserPhone
            : "";

    //bloc.getAddFieldsByCatID(adsObj.CategoryId);
    bloc.getEditFieldsByCatID(adsObj.Id.toString());
    _cattextController.text = adsObj.CategoryName.toString();
    _citytextController.text = allTranslations.isEnglish
        ? adsObj.CityNameEnglish.toString()
        : adsObj.CityNameArabic.toString();

    isNeogtiable = adsObj.IsNogitable;
    uploadBloc.addListImage(adsObj.AdvertismentImages);
  }

  _showDialog() async {
    await SelectBottom.showBottom<CateogryEntity>(
      context,
      label: allTranslations.text('choose_category'),
      selectedValue: CateogryEntity(),
      items: List(),
      onChange: (CateogryEntity selected) {
        _cattextController.text = allTranslations.isEnglish
            ? selected.englishDescription.toString()
            : selected.arabicDescription;
        _selectedFieldValue = [];
        _colorFieldValue = [];
        bloc.getEditFieldsByCatID("");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            allTranslations.text('edit_ads'),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black38),
          ),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black38,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'back',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: Text(allTranslations.text('add_image')),
              ),
              BlocProvider(
                  bloc: uploadBloc, child: ImageInput()), //add image list

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: TextFieldDecoration(
                  textEditingController: _nametextController,
                  //   inputFormatters: [LengthLimitingTextInputFormatter(70)],
                  onSaved: (val) {
                    adsPostEntity.title = val;
                  },
                  //  decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.check_circle,
                    color: AppColors.validValueColor,
                  ),
                  //  filled: true,
                  fillColor: Colors.white,
                  labelText: allTranslations.text('ads_title'),
                  hintText: allTranslations.text('ads_title'),
                  // border: new OutlineInputBorder(
                  //     borderRadius: new BorderRadius.circular(10.0)),
                  //  )
                ),
              ),
              SizedBox(
                height: 8,
              ),

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: _BuildRoundedTextField(
                    labelText: allTranslations.text('cateogry'),
                    hintText: allTranslations.text('cateogry'),
                    controller: _cattextController,
                    iswithArrowIcon: true,
                    onClickAction: () {
                      _showDialog();
                    }),
              ),
              SizedBox(
                height: 8,
              ),

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: _BuildCityRoundedTextField(
                    labelText: allTranslations.text('govrnment'),
                    hintText: allTranslations.text('govrnment'),
                    controller: _citytextController,
                    iswithArrowIcon: true,
                    onClickAction: () {
                      _showCityDialog();
                    }),
              ),

              SizedBox(
                height: 8,
              ),
              Visibility(
                visible: isVisiable,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                  child: _BuildCityRoundedTextField(
                      labelText: allTranslations.text('zone'),
                      hintText: allTranslations.text('zone'),
                      controller: _citiestextController,
                      iswithArrowIcon: true,
                      onClickAction: () {
                        _showCiiesDialog(cityID);
                      }),
                ),
              ),
              SizedBox(
                height: 8,
              ),

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: TextFieldDecoration(
                  textEditingController: _desctextController,
                  //   decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.check_circle,
                    color: AppColors.validValueColor,
                  ),
                  //     filled: true,
                  fillColor: Colors.white,
                  labelText: allTranslations.text('description'),
                  hintText: allTranslations.text('description'),
                  // border: new OutlineInputBorder(
                  //     borderRadius: new BorderRadius.circular(10.0)),
                  //  ),
                  onSaved: (val) {
                    adsPostEntity.englishDescription = val;
                  },
                ),
              ),

              SizedBox(
                height: 8,
              ),

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: TextFieldDecoration(
                  textEditingController: _pricetextController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  // inputFormatters: [
                  //   WhitelistingTextInputFormatter.digitsOnly,
                  //   LengthLimitingTextInputFormatter((20))
                  // ],
                  onSaved: (val) {
                    adsPostEntity.price = int.tryParse(val) ?? 0;
                  },
                  //     decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.check_circle,
                    color: AppColors.validValueColor,
                  ),
                  //     filled: true,
                  fillColor: Colors.white,
                  labelText: allTranslations.text('price'),
                  hintText: allTranslations.text('price'),
                  // border: new OutlineInputBorder(
                  //     borderRadius: new BorderRadius.circular(10.0)),
                  //  )
                ),
              ),

              SizedBox(
                height: 8,
              ),

              StreamBuilder<EditFieldProperty>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    return Visibility(
                      child: Text(""),
                      visible: false,
                    );
                  else if (!snapshot.hasData) return SizedBox.shrink();
                  var fields = snapshot.data.CategorySpecification;
                  // setState(() {
                  //
                  // });
                  if (_selectedFieldValue.isEmpty)
                    _selectedFieldValue =
                        List(snapshot.data.CategorySpecification.length);
                  if (_colorFieldValue.isEmpty)
                    _colorFieldValue =
                        List(snapshot.data.CategorySpecification.length);
                  if (_multiselectedFieldValue.isEmpty)
                    _multiselectedFieldValue =
                        List(snapshot.data.CategorySpecification.length);
                  if (contollers.isEmpty)
                    contollers =
                        List(snapshot.data.CategorySpecification.length);
                  if (adsPostEntity.advertismentSpecification == null) {
                    adsPostEntity.advertismentSpecification =
                        List(snapshot.data.CategorySpecification.length);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      var item = fields[index];
                      if (isFirst &&
                          snapshot.data.AdData.Advertisment_Specification !=
                              null &&
                          snapshot.data.AdData.Advertisment_Specification
                              .isNotEmpty)
                        for (var spec in snapshot
                            .data.AdData.Advertisment_Specification) {
                          if (spec.CategorySpecificationId == item.Id) {
                            if ((item.MuliSelect == null || !item.MuliSelect) &&
                                item.SpecificationOptions.isNotEmpty) {
                              _selectedFieldValue[index] = spec
                                  .AdvertismentSpecificatioOptions[0]
                                  .SpecificationOptionId;
                              _colorFieldValue[index] =
                                  AppColors.validValueColor;
                            } else if (item.MuliSelect) {
                              _multiselectedFieldValue[index] =
                                  spec.AdvertismentSpecificatioOptions;
                              String text = "";
                              spec.AdvertismentSpecificatioOptions.forEach(
                                  (val) => text += "${val.NameEnglish},");
                              contollers[index].text = text;
                              _colorFieldValue[index] =
                                  AppColors.validValueColor;
                            } else {
                              contollers[index].text = spec.CustomValue;
                              _colorFieldValue[index] =
                                  AppColors.validValueColor;
                            }
                            break;
                          }
                          // setState(() {});
                        }

                      //if(item.CustomValue==null)
                      if ((item.MuliSelect == null || !item.MuliSelect) &&
                          item.SpecificationOptions.isNotEmpty)
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, right: 4, left: 4),
                          child: Container(
                            height: 70,
                            child: FormField<String>(
                                autovalidate: item.Required,
                                validator:
                                    item.Required ? _emptyValidate : null,
                                onSaved: (val) {
                                  var vv = Advertisment_SpecificationBean();
                                  vv.id = item.Id;

                                  int itemval = val == null
                                      ? _selectedFieldValue[index]
                                      : int.tryParse(val) ?? 0;
                                  vv.advertismentSpecificatioOptions = [
                                    itemval
                                  ];
                                  adsPostEntity
                                      .advertismentSpecification[index] = vv;
                                },
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        // labelText: allTranslations.isEnglish
                                        //     ? item.EnglishName
                                        //     : item.ArabicName,
                                        errorText: state.hasError
                                            ? state.errorText
                                            : null,
                                        prefixIcon: Icon(
                                          Icons.check_circle,
                                          color: _colorFieldValue[index],
                                        ),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xffB5B5B5),
                                                width: 0.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22.0)),
                                            borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 0.5))),
                                    child: InkWell(
                                      onTap: () {
                                        return showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  height: 350,
                                                  child: ListView.separated(
                                                    itemCount: item
                                                        .SpecificationOptions
                                                        .length,
                                                    separatorBuilder:
                                                        (c, index) => Divider(
                                                      height: 0.5,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      //  var item = item.SpecificationOptions[index];
                                                      //   if (widget.itemBuilder != null)
                                                      //     return InkWell(
                                                      //       child: widget.itemBuilder(
                                                      //           context, item, item == widget.selectedValue),
                                                      //       onTap: () {
                                                      //         if (item.hasSub) {
                                                      //           bloc.addCateogryToStack(item);
                                                      //         } else {
                                                      //           onChange(item);
                                                      //           Navigator.pop(context);
                                                      //         }
                                                      //       },
                                                      //     );

                                                      return ListTile(
                                                        title: Text(allTranslations
                                                                .isEnglish
                                                            ? item
                                                                .SpecificationOptions[
                                                                    index]
                                                                .EnglishName
                                                            : item
                                                                .SpecificationOptions[
                                                                    index]
                                                                .ArabicName),
                                                        // selected: item == widget.selectedValue,
                                                        // trailing: item.hasSub
                                                        //     ? Icon(
                                                        //   Icons.arrow_forward_ios_outlined,
                                                        //   color: Colors.black87,
                                                        //   size: 30,
                                                        // )
                                                        //     : SizedBox(),
                                                        onTap: () {
                                                          item.Value = allTranslations
                                                                  .isEnglish
                                                              ? item
                                                                  .SpecificationOptions[
                                                                      index]
                                                                  .EnglishName
                                                              : item
                                                                  .SpecificationOptions[
                                                                      index]
                                                                  .ArabicName;
                                                          setState(() {
                                                            _selectedFieldValue[
                                                                    index] =
                                                                item
                                                                    .SpecificationOptions[
                                                                        index]
                                                                    .Id;
                                                            state.didChange(item
                                                                .SpecificationOptions[
                                                                    index]
                                                                .Id
                                                                .toString());
                                                            _colorFieldValue[
                                                                    index] =
                                                                AppColors
                                                                    .validValueColor;
                                                          });
                                                          Navigator.pop(
                                                              context);

                                                          // if (item.hasSub) {
                                                          //   bloc.addCateogryToStack(item);
                                                          // } else {
                                                          //   onChange(item);
                                                          //   Navigator.pop(context);
                                                          // }
                                                        },
                                                      );
                                                    },
                                                  ));
                                            });
                                      },
                                      child: Container(
                                        height: 30,
                                        child: Text(
                                          //  item.Value != null
                                          // ?
                                          ' ${allTranslations.isEnglish ? snapshot.data.AdData.Advertisment_Specification[index].AdvertismentSpecificatioOptions[0].NameEnglish : snapshot.data.AdData.Advertisment_Specification[index].AdvertismentSpecificatioOptions[0].NameArabic}',
                                          // : '${allTranslations.text('choose')} ${allTranslations.isEnglish ? item.EnglishName : item.ArabicName}',
                                          style: TextStyle(
                                              fontSize:
                                                  _selectedFieldValue[index] !=
                                                          null
                                                      ? 16
                                                      : 14,
                                              color:
                                                  _selectedFieldValue[index] !=
                                                          null
                                                      ? Colors.black
                                                      : Color(0xffCAD1E0)),
                                        ),
                                        // child: DropdownButtonHideUnderline(
                                        //   child: DropdownButton(
                                        //     hint: Text(
                                        //         '${allTranslations.text('choose')} ${allTranslations.isEnglish ? item.EnglishName : item.ArabicName}',
                                        //         style: TextStyle(fontSize: 14)),
                                        //     value: _selectedFieldValue[index],
                                        //     isDense: true,
                                        //     items: item.SpecificationOptions.map(
                                        //         (FieldProprtiresSpecificationoption
                                        //             value) {
                                        //       return DropdownMenuItem(
                                        //         value: value.Id,
                                        //         child: Text(
                                        //             allTranslations.isEnglish
                                        //                 ? value.EnglishName
                                        //                 : value.ArabicName),
                                        //       );
                                        //     }).toList(),
                                        //     onChanged: (int newValue) {
                                        //       item.Value = newValue;
                                        //       setState(() {
                                        //         isFirst = false;
                                        //         _selectedFieldValue[index] =
                                        //             newValue;
                                        //         state.didChange(
                                        //             newValue.toString());
                                        //         _colorFieldValue[index] =
                                        //             AppColors.validValueColor;
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        );
                      else if (item.MuliSelect)
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, right: 4.0, left: 4.0),
                          child: TextFieldDecoration(
                            textEditingController: contollers[index],
                            onTap: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _showReportDialog(
                                    index,
                                    allTranslations.isEnglish
                                        ? item.EnglishName
                                        : item.ArabicName,
                                    item.SpecificationOptions);
                              });
                            },
                            readOnly: true,
                            //   enableInteractiveSelection: true,
                            autoValdite: item.Required,
                            validator: item.Required ? _emptyValidate : null,
                            onSaved: (val) {
                              var vv = Advertisment_SpecificationBean();
                              vv.id = item.Id;
                              int itemval = item.Value as int ?? 0;
                              //   vv.advertismentSpecificatioOptions = [];
                              vv.customValue = val;
                              adsPostEntity.advertismentSpecification[index] =
                                  vv;
                            },
                            //      decoration: InputDecoration(
                            //    filled: true,
                            fillColor: Colors.white,
                            labelText: allTranslations.isEnglish
                                ? item.EnglishName
                                : item.ArabicName,
                            hintText: allTranslations.isEnglish
                                ? item.EnglishName
                                : item.ArabicName,
                            prefixIcon: item.Required
                                ? Icon(
                                    Icons.check_circle,
                                    color: _colorFieldValue[index],
                                  )
                                : null,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            // border: new OutlineInputBorder(
                            //     borderRadius:
                            //         new BorderRadius.circular(10.0)),
                            //    )
                          ),
                        );
                      else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, right: 4.0, left: 4.0),
                          child: TextFieldDecoration(
                            textEditingController: contollers[index],
                            autoValdite: true,
                            validator: _emptyValidate,
                            onSaved: (val) {
                              var vv = Advertisment_SpecificationBean();
                              vv.id = item.Id;
                              int itemval = item.Value as int ?? 0;
                              //    vv.advertismentSpecificatioOptions = [];
                              vv.customValue = val;
                              adsPostEntity.advertismentSpecification[index] =
                                  vv;
                            },
                            //    decoration: InputDecoration(
                            //   filled: true,
                            fillColor: Colors.white,
                            labelText: allTranslations.isEnglish
                                ? item.EnglishName
                                : item.ArabicName,
                            hintText: allTranslations.isEnglish
                                ? item.EnglishName
                                : item.ArabicName,
                            prefixIcon: item.Required
                                ? Icon(
                                    Icons.check_circle,
                                    color: _colorFieldValue[index],
                                  )
                                : null,
                            // border: new OutlineInputBorder(
                            //     borderRadius:
                            //         new BorderRadius.circular(10.0)),
                            //  )
                          ),
                        );
                      }
                    }, //
                  );
                },
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 4.0, left: 4.0),
                child: TextFieldDecoration(
                  textEditingController: _phonetextController,
                  validator: _phoneValidate,
                  autoValdite: phoneColor == AppColors.validValueColor ||
                      phoneColor == AppColors.errorValueColor,
                  onSaved: (val) {
                    adsPostEntity.phone = val;
                  },
                  // decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.check_circle,
                    color: phoneColor,
                  ),
                  // filled: true,
                  fillColor: Colors.white,
                  labelText: allTranslations.text('phone'),
                  hintText: allTranslations.text('phone'),
                  // border: new OutlineInputBorder(
                  //     borderRadius: new BorderRadius.circular(10.0)),
                  // )
                ),
              ),
              SizedBox(
                height: 8,
              ),

              SizedBox(
                height: 8,
              ),
              Center(
                child: CheckboxLabel(
                  label: allTranslations.text('negtoable'),
                  value: isNeogtiable,
                  onChanged: (newValue) {
                    setState(() {
                      isNeogtiable = newValue;
                      adsPostEntity.isNogitable = newValue;
                    });
                  },
                ),
              ),

              SizedBox(
                height: 8,
              ),
              Dialogs.commonButton(() {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  int count = 0;
                  var images = <PhotosBean>[];
                  bool isuploaded = true;
                  int imageId;
                  for (var image in uploadBloc.getUploadImageList) {
                    if (image is UploadedImage &&
                        image.state != StateEnum.LOADING) {
                      if (image.remoteUrl != null &&
                          image.remoteUrl.isNotEmpty) {
                        imageId = adsObj.AdvertismentImages.indexWhere(
                            (element) => element.Url == image.remoteUrl);
                        if (image.uplodedID != null && image.uplodedID > 0) {
                          PhotosBean photo = new PhotosBean(
                              image.remoteUrl.toString(), image.uplodedID);
                          images.add(photo);
                        } else {
                          PhotosBean photo = new PhotosBean(
                              image.remoteUrl.toString(),
                              adsObj.AdvertismentImages[imageId].Id);
                          images.add(photo);
                        }
                        count++;
                      }
                    } else if (image is UploadedImage &&
                        image.state == StateEnum.LOADING) {
                      isuploaded == false;
                      break;
                    }
                  }
                  if (isuploaded) {
                    adsPostEntity.photos = List<PhotosBean>();
                    adsPostEntity.photos.addAll(images);
                  } else {
                    scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('images not all uploaded')));
                    return;
                  }
                  adsPostEntity.id = adsObj.Id;
                  adsPostEntity.locationLatitude =
                      0 /*_markers.elementAt(0).position.latitude as int*/;
                  adsPostEntity.locationLongtude = 0
                      /*_markers.elementAt(0).position.longitude as int*/;
                  adsPostEntity.cityId = widget.detail.CityId;
                  adsPostEntity.stateId = widget.detail.StateId;
                  adsPostEntity.countryId = widget.detail.CountryId;
                  adsPostEntity.categoryId = widget.detail.CategoryId;
                  adsPostEntity.price = int.parse(_pricetextController.text
                      .trim()
                      .toString()
                      .split('.')[0]);
                  adsPostEntity.isNogitable = isNeogtiable;
                  bloc.editAdvertisment(adsPostEntity);
                }
              }, allTranslations.text('edit_ads'), height: 60)

              // SizedBox(
              //   width: double.infinity,
              //   height: 60,
              //   child: RaisedButton(
              //     color: Colors.green,
              //     onPressed: () {
              //       if (_formKey.currentState.validate()) {
              //         _formKey.currentState.save();
              //         int count = 0;
              //         var images = <PhotosBean>[];
              //         bool isuploaded = true;
              //         int imageId;
              //         for (var image in uploadBloc.getUploadImageList) {
              //           if (image is UploadedImage &&
              //               image.state != StateEnum.LOADING) {
              //             if (image.remoteUrl != null &&
              //                 image.remoteUrl.isNotEmpty) {
              //               imageId = adsObj.AdvertismentImages.indexWhere(
              //                   (element) => element.Url == image.remoteUrl);
              //               if (image.uplodedID != null &&
              //                   image.uplodedID > 0) {
              //                 PhotosBean photo = new PhotosBean(
              //                     image.remoteUrl.toString(), image.uplodedID);
              //                 images.add(photo);
              //               } else {
              //                 PhotosBean photo = new PhotosBean(
              //                     image.remoteUrl.toString(),
              //                     adsObj.AdvertismentImages[imageId].Id);
              //                 images.add(photo);
              //               }
              //               count++;
              //             }
              //           } else if (image is UploadedImage &&
              //               image.state == StateEnum.LOADING) {
              //             isuploaded == false;
              //             break;
              //           }
              //         }
              //         if (isuploaded) {
              //           adsPostEntity.photos = List<PhotosBean>();
              //           adsPostEntity.photos.addAll(images);
              //         } else {
              //           scaffoldKey.currentState.showSnackBar(
              //               SnackBar(content: Text('images not all uploaded')));
              //           return;
              //         }
              //         adsPostEntity.id = adsObj.Id;
              //         adsPostEntity.locationLatitude =
              //             0 /*_markers.elementAt(0).position.latitude as int*/;
              //         adsPostEntity.locationLongtude = 0
              //             /*_markers.elementAt(0).position.longitude as int*/;
              //         adsPostEntity.cityId = widget.detail.CityId;
              //         adsPostEntity.stateId = widget.detail.StateId;
              //         adsPostEntity.countryId = widget.detail.CountryId;
              //         adsPostEntity.categoryId = widget.detail.CategoryId;
              //         adsPostEntity.price = int.parse(_pricetextController.text
              //             .trim()
              //             .toString()
              //             .split('.')[0]);
              //         adsPostEntity.isNogitable = isNeogtiable;
              //         bloc.editAdvertisment(adsPostEntity);
              //       }
              //     },
              //     child: Center(child: Text(allTranslations.text('edit_ads'))),
              //     textColor: Colors.white,
              //   ),
              // ),
            ]),
          ),
        ),
      ),

/*
        BlocProvider(
            bloc: UploadImageBloc(),child:ImageInput()),*/
    );
  }

  Widget _BuildRoundedTextField(
      {String labelText,
      TextEditingController controller = null,
      String hintText,
      iswithArrowIcon = false,
      Function onClickAction}) {
    return TextFieldDecoration(
      //  validator: _emptyValidate,
      validator: _emptyValidate,
      readOnly: true,
      // enableInteractiveSelection: true,
      autoValdite: categoryColor == AppColors.validValueColor ||
          categoryColor == AppColors.errorValueColor,
      textEditingController: controller,
      onTap: () {
        onClickAction();
      },
      //   decoration: InputDecoration(
      suffixIcon: iswithArrowIcon ? Icon(Icons.arrow_drop_down) : null,
      prefixIcon: Icon(
        Icons.check_circle,
        color: categoryColor,
      ),
      //     filled: true,
      fillColor: Colors.white,
      labelText: labelText,
      hintText: hintText,
      // border: new OutlineInputBorder(
      //     borderRadius: new BorderRadius.circular(10.0)),
      // )
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getLocation();
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers.add(marker);
      _mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 20.0,
          ),
        ),
      );
    });
  }

  String _descAdsValidate(String value) {
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (value.length < 10) {
      return allTranslations.text('err_short-desc');
    } else {
      return null;
    }
  }

  String _titleAdsValidate(String value) {
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (value.length < 5) {
      return allTranslations.text('err_short-title');
    } else if (value.length > 60) {
      return allTranslations.text('err_long-title');
    } else {
      return null;
    }
  }

  String _emptyValidate(String value) {
    Future.delayed(const Duration(milliseconds: 50), () {
// Here you can write your code
      if (value == null || value.isEmpty) {
        //  print("rr" + value);
        return allTranslations.text('empty_field');
      } else {
        return null;
      }

      // Here you can write your code for open new view
    });
    //setState(() {});
  }

  String _phoneValidate(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (!regExp.hasMatch(value)) {
      return allTranslations.text('err_phone');
    } else {
      return null;
    }
  }

  String _emailValidate(String value) {
    String patttern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (!regExp.hasMatch(value)) {
      return allTranslations.text('err_email');
    } else {
      return null;
    }
  }

  _showReportDialog(
      int index, String title, List<FieldProprtiresSpecificationoption> list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text(title),
            content: MultiSelectChip(
              list,
              onSelectionChanged: (selectedList) {
                if (contollers[index] == null) {
                  contollers[index] = TextEditingController();
                }
                selectedList.forEach((val) => text +=
                    "${allTranslations.isEnglish ? val.EnglishName : val.ArabicName},");
                contollers[index].text = text;
                setState(() {
                  _multiselectedFieldValue[index] = selectedList;
                  _colorFieldValue[index] = AppColors.validValueColor;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('${allTranslations.text('ok')}'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  _showCiiesDialog(int cityId) async {
    await CitiesListDialog.showModal<Cities>(
      context,
      id: cityId,
      label: allTranslations.text('zone'),
      selectedValue: Cities(),
      items: List(),
      onChange: (Cities selected) {
        _citiestextController.text = allTranslations.isEnglish
            ? selected.englishName.toString()
            : selected.arabicName;
        adsPostEntity.stateId = selected.cityId;
        // adsPostEntity.cityId=selected.id;
      },
    );
  }

  Widget _BuildCityRoundedTextField(
      {String labelText,
      TextEditingController controller = null,
      String hintText,
      iswithArrowIcon = false,
      Function onClickAction}) {
    return TextFieldDecoration(
      validator: _emptyValidate,
      readOnly: true,
      // enableInteractiveSelection: true,
      autoValdite: cityColor == AppColors.validValueColor ||
          cityColor == AppColors.errorValueColor,
      textEditingController: controller,
      onTap: () {
        onClickAction();
      },
      //  decoration: InputDecoration(
      suffixIcon: iswithArrowIcon ? Icon(Icons.arrow_drop_down) : null,
      prefixIcon: Icon(
        Icons.check_circle,
        color: cityColor,
      ),
      //  filled: true,
      fillColor: Colors.white,
      labelText: labelText,
      hintText: hintText,
      // border: new OutlineInputBorder(
      //     borderRadius: new BorderRadius.circular(10.0)),
      // )
    );
  }

  _showCityDialog() async {
    await CityListDialog.showModal<CityModel>(
      context,
      label: allTranslations.text('choose_city'),
      selectedValue: CityModel(),
      items: List(),
      onChange: (CityModel selected) {
        _citytextController.text = allTranslations.isEnglish
            ? selected.englishDescription.toString()
            : selected.arabicDescription;
        adsPostEntity.stateId = selected.id;
        adsPostEntity.cityId = selected.id;
        _citiestextController.clear();
        cityID = selected.id;

        setState(() {
          isVisiable = true;
        });
      },
    );
  }
}
