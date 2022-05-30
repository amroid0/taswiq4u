import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/add_post_bloc.dart';
import 'package:olx/data/bloc/upload_image_bloc.dart';
import 'package:olx/data/shared_prefs.dart';
import 'package:olx/model/Cities.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/cityModel.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/model/user_info.dart';
import 'package:olx/pages/ImageUploaderListPage.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/ToastUtils.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';
import 'package:olx/widget/CitiesDialog.dart';
import 'package:olx/widget/check_box_withlabel.dart';
import 'package:olx/widget/city_list_dialog.dart';
import 'package:olx/widget/map_widget.dart';
import 'package:olx/widget/mutli_select_chip_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../data/bloc/bloc_provider.dart';
import 'cateogry_dailog.dart';

class AddAdvertisment extends StatefulWidget {
  @override
  _AddAdvertismentState createState() => _AddAdvertismentState();
}

class _AddAdvertismentState extends State<AddAdvertisment> {
  AddPostBloc bloc = null;

  List<int> _selectedFieldValue = [];
  List<Color> _colorFieldValue = [];
  AdsPostEntity adsPostEntity = AdsPostEntity();
  final _formKey = GlobalKey<FormState>();
  bool isNeogtiable = false;
  String countryId;
  int userCountryId;
  int cId;
  String userId = "";
  String text = "";
  List<String> adsStateList = ["جديد", "مستعمل"];
  String selectedAdsStates = "جديد";
  final TextEditingController _cattextController = TextEditingController();
  final TextEditingController _phonetextController = TextEditingController();
  final TextEditingController _citytextController = TextEditingController();
  final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _pricetextController = TextEditingController();
  final TextEditingController _desctextController = TextEditingController();
  final TextEditingController _citiestextController = TextEditingController();
  Color adNameColor,
      descColor,
      priceColor,
      categoryColor,
      cityColor,
      phoneColor = Colors.grey;
  GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  List<TextEditingController> contollers = List();
  CateogryEntity _selectedcataogry;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UploadImageBloc uploadBloc;
  int cityID = 0;
  bool isVisiable = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  ProgressDialog progressDialog;

  List<List> _multiselectedFieldValue =
      List<List<FieldProprtiresSpecificationoption>>();

  @override
  void dispose() {
    // TODO: implement dispose
    _nametextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
    bloc = AddPostBloc();
    uploadBloc = UploadImageBloc();
    getCountryId();
    getUserNumber();
    getUserID();
    bloc.addStream.listen((data) {
      // Redirect to another view, given your conditi on
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
                msg: "${allTranslations.text('send_success')}",
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
          ToastUtils.showErrorMessage(allTranslations.text('err_wrong'));
          break;
      }
    });

    _phonetextController.addListener(() {
      bool isvalid = _phoneValidate(_phonetextController.value.text) == null;
      setState(() {
        phoneColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
    });
    _nametextController.addListener(() {
      bool isvalid = _titleAdsValidate(_nametextController.value.text) == null;
      setState(() {
        adNameColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
    });

    _desctextController.addListener(() {
      bool isvalid = _descAdsValidate(_desctextController.value.text) == null;
      setState(() {
        descColor =
            isvalid ? AppColors.validValueColor : AppColors.errorValueColor;
      });
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
    _citiestextController.addListener(() {
      bool isvalid = _emptyValidate(_citiestextController.value.text) == null;
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
  }

  _showDialog() async {
    await SelectDialog.showModal<CateogryEntity>(
      context,
      label: allTranslations.text('choose_category'),
      selectedValue: CateogryEntity(),
      items: List(),
      onChange: (CateogryEntity selected) {
        _cattextController.text = allTranslations.isEnglish
            ? selected.englishDescription.toString()
            : selected.arabicDescription.toString();
        _selectedFieldValue = [];
        _colorFieldValue = [];
        bloc.getAddFieldsByCatID(selected.id);
        _selectedcataogry = selected;
        adsPostEntity.categoryId = selected.id;
      },
    );
  }

  _showCityDialog() async {
    await CityListDialog.showModal<CityModel>(
      context,
      label: allTranslations.text('choose_govrnment'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            allTranslations.text('ads_add'),
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
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(allTranslations.text('add_image')),
              ),
              BlocProvider(
                  bloc: uploadBloc, child: ImageInput()), //add image list

              TextFormField(
                  validator: _titleAdsValidate,
                  controller: _nametextController,
                  inputFormatters: [LengthLimitingTextInputFormatter(70)],
                  onSaved: (val) {
                    adsPostEntity.title = val;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.check_circle,
                      color: AppColors.validValueColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: allTranslations.text('ads_title'),
                    hintText: allTranslations.text('ads_title'),
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  )),
              SizedBox(
                height: 8,
              ),

              _BuildRoundedTextField(
                  labelText: allTranslations.text('cateogry'),
                  hintText: allTranslations.text('cateogry'),
                  controller: _cattextController,
                  iswithArrowIcon: true,
                  onClickAction: () {
                    _showDialog();
                  }),
              SizedBox(
                height: 8,
              ),

              _BuildCityRoundedTextField(
                  labelText: allTranslations.text('govrnment'),
                  hintText: allTranslations.text('govrnment'),
                  controller: _citytextController,
                  iswithArrowIcon: true,
                  onClickAction: () {
                    _showCityDialog();
                  }),
              SizedBox(
                height: 8,
              ),
              Visibility(
                visible: isVisiable,
                child: _BuildCityRoundedTextField(
                    labelText: allTranslations.text('zone'),
                    hintText: allTranslations.text('zone'),
                    controller: _citiestextController,
                    iswithArrowIcon: true,
                    onClickAction: () {
                      _showCiiesDialog(cityID);
                    }),
              ),
              SizedBox(
                height: 8,
              ),

              TextFormField(
                validator: _descAdsValidate,
                controller: _desctextController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.check_circle,
                    color: AppColors.validValueColor,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: allTranslations.text('description'),
                  hintText: allTranslations.text('description'),
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                ),
                onSaved: (val) {
                  adsPostEntity.englishDescription = val;
                  adsPostEntity.arabicDescription = val;
                },
              ),

              SizedBox(
                height: 8,
              ),

              TextFormField(
                  controller: _pricetextController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter((20))
                  ],
                  onSaved: (val) {
                    adsPostEntity.price = int.tryParse(val) ?? 0;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.check_circle,
                      color: AppColors.validValueColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: allTranslations.text('price'),
                    hintText: allTranslations.text('price'),
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  )),

              SizedBox(
                height: 8,
              ),

              StreamBuilder<FieldPropReponse>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data.isSucess == false)
                    return Visibility(
                      child: Text(""),
                      visible: false,
                    );
                  else if (!snapshot.hasData) return SizedBox.shrink();
                  var fields = snapshot.data.data;
                  if (_selectedFieldValue.isEmpty)
                    _selectedFieldValue = List(snapshot.data.data.length);
                  if (_colorFieldValue.isEmpty)
                    _colorFieldValue = List(snapshot.data.data.length);
                  if (_multiselectedFieldValue.isEmpty)
                    _multiselectedFieldValue = List(snapshot.data.data.length);
                  if (contollers.isEmpty)
                    contollers = List(snapshot.data.data.length);
                  if (adsPostEntity.advertismentSpecification == null) {
                    adsPostEntity.advertismentSpecification =
                        List(snapshot.data.data.length);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      var item = fields[index];

                      //if(item.CustomValue==null)
                      if ((item.MuliSelect == null || !item.MuliSelect) &&
                          item.SpecificationOptions.isNotEmpty)
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FormField<String>(
                              autovalidate: item.Required,
                              validator: item.Required ? _emptyValidate : null,
                              onSaved: (val) {
                                var vv = Advertisment_SpecificationBean();
                                vv.id = item.Id;
                                int itemval = int.tryParse(val) ?? 0;
                                vv.advertismentSpecificatioOptions = [itemval];
                                adsPostEntity.advertismentSpecification[index] =
                                    vv;
                              },
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: allTranslations.isEnglish
                                        ? item.EnglishName
                                        : item.ArabicName,
                                    errorText:
                                        state.hasError ? state.errorText : null,
                                    prefixIcon: Icon(
                                      Icons.check_circle,
                                      color: _colorFieldValue[index],
                                    ),
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                  ),
                                  child: Container(
                                    height: 30,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: Text(
                                            '${allTranslations.text('choose')} ${allTranslations.isEnglish ? item.EnglishName : item.ArabicName}'),
                                        value: _selectedFieldValue[index],
                                        isDense: true,
                                        items: item.SpecificationOptions.map(
                                            (FieldProprtiresSpecificationoption
                                                value) {
                                          return DropdownMenuItem(
                                            value: value.Id,
                                            child: Text(
                                                allTranslations.isEnglish
                                                    ? value.EnglishName
                                                    : value.ArabicName),
                                          );
                                        }).toList(),
                                        onChanged: (int newValue) {
                                          item.Value = newValue;
                                          setState(() {
                                            _selectedFieldValue[index] =
                                                newValue;
                                            state
                                                .didChange(newValue.toString());
                                            _colorFieldValue[index] =
                                                AppColors.validValueColor;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      else if (item.MuliSelect)
                        //if(item.MuliSelect!=null&&item.MuliSelect)
                        /*return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: FormField<String>(

                          autovalidate: true,
                          validator:_emptyValidate,
                          onSaved: (val){
                            if(adsPostEntity.AdvertismentSpecification==null){
                              adsPostEntity.AdvertismentSpecification=List<Advertisment_SpecificationBean>();
                            }
                            var vv=Advertisment_SpecificationBean();
                            vv.Id=item.Id;
                            int itemval=item.Value as int ?? 0;
                            vv.AdvertismentSpecificatioOptions=[itemval];
                            adsPostEntity.AdvertismentSpecification[index]=vv;

                          },
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: item.ArabicName,
                                errorText: state.hasError?state.errorText:null,
                                prefixIcon: Icon(Icons.check_circle,color: _colorFieldValue[index],),
                                border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(10.0)),
                              ),
                              child: MultiSelectFormField(

                                hintText: '${allTranslations.text('choose')} ${allTranslations.isEnglish?item.EnglishName:item.ArabicName}',
                                titleText: '${allTranslations.text('choose')} ${allTranslations.isEnglish?item.EnglishName:item.ArabicName}',
                                value:_multiselectedFieldValue[index],
                                dataSource: item.SpecificationOptions.map((FieldProprtiresSpecificationoption value){
                                  return {
                                    "value": value.Id,
                                    "display":
                                        allTranslations.isEnglish ? value
                                            .EnglishName : value.ArabicName,
                                  };
                                }).toList(),

                                  textField: 'display',
                                  valueField: 'value',
                                cancelButtonLabel: "Cancel",
                                okButtonLabel: "Ok",
                                  onSaved: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _multiselectedFieldValue[index] = value;
                                    });
                                  },
                              ),
                            );}

                      ),
                    );*/

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextFormField(
                              controller: contollers[index],
                              onTap: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _showReportDialog(
                                      index,
                                      allTranslations.isEnglish
                                          ? item.EnglishName
                                          : item.ArabicName,
                                      item.SpecificationOptions);
                                });
                              },
                              readOnly: true,
                              enableInteractiveSelection: true,
                              autovalidate: item.Required,
                              validator: item.Required ? _emptyValidate : null,
                              onSaved: (val) {
                                var vv = Advertisment_SpecificationBean();
                                vv.id = item.Id;
                                //int itemval=item.Value as int ?? 0;
                                vv.customValue = val;
                                adsPostEntity.advertismentSpecification[index] =
                                    vv;
                              },
                              decoration: InputDecoration(
                                filled: true,
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
                                border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              )),
                        );
                      else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextFormField(
                              controller: contollers[index],
                              autovalidate: true,
                              validator: _emptyValidate,
                              onSaved: (val) {
                                var vv = Advertisment_SpecificationBean();
                                vv.id = item.Id;
                                vv.customValue = val;
                                //int itemval=item.Value as int ?? 0;
                                //vv.AdvertismentSpecificatioOptions=[val];
                                adsPostEntity.advertismentSpecification[index] =
                                    vv;
                              },
                              decoration: InputDecoration(
                                filled: true,
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
                                border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                              )),
                        );
                      }
                    }, //
                  );
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phonetextController,
                  validator: _phoneValidate,
                  autovalidate: phoneColor == AppColors.validValueColor ||
                      phoneColor == AppColors.errorValueColor,
                  onSaved: (val) {
                    adsPostEntity.phone = val;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.check_circle,
                      color: phoneColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: allTranslations.text('phone'),
                    hintText: allTranslations.text('phone'),
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  )),
              SizedBox(
                height: 8,
              ),
              Center(
                child: InkWell(
                  child: MapWidget(
                    center: LatLng(0, 0),
                    mapController: _mapController,
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    onTap: (lat) async {
                      LocationResult result = await showLocationPicker(
                        context,
                        "AIzaSyC57DQKo0jhnTJtdZX1Lp7LAIFmAFhZiNQ",
                      );
                      print("result = $result");
                      setState(() {
                        _markers.clear();
                        final marker = Marker(
                          markerId: MarkerId("curr_loc"),
                          position: result.latLng,
                          infoWindow: InfoWindow(title: 'Your Location'),
                        );
                        _markers.add(marker);
                        _mapController.moveCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: result.latLng,
                              zoom: 20.0,
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
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
                    });
                  },
                ),
              ),

              SizedBox(
                height: 8,
              ),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      int count = 0;
                      var images = <PhotosBean>[];
                      bool isuploaded = true;
                      List<ImageListItem> uploadedimges =
                          uploadBloc.getUploadImageList;
                      for (var image in uploadedimges) {
                        if (image is UploadedImage &&
                            image.state != StateEnum.LOADING) {
                          if (image.remoteUrl != null &&
                              image.remoteUrl.isNotEmpty) {
                            PhotosBean photo = new PhotosBean(
                                image.remoteUrl.toString(), image.uplodedID);
                            images.add(photo);
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
                      adsPostEntity.locationLatitude =
                          0 /*_markers.elementAt(0).position.latitude as int*/;
                      adsPostEntity.locationLongtude =
                          0 /*_markers.elementAt(0).position.longitude as int*/;
                      adsPostEntity.userId = userId;
                      adsPostEntity.isNogitable = isNeogtiable;
                      bloc.postAds(adsPostEntity);
                    } else {
                      ToastUtils.showWarningMessage(
                          allTranslations.text("missing_fields"));
                    }
                  },
                  child: Center(child: Text(allTranslations.text('ads_add'))),
                  textColor: Colors.white,
                ),
              ),
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
    return TextFormField(
        validator: _emptyValidate,
        autovalidate: categoryColor == AppColors.validValueColor ||
            categoryColor == AppColors.errorValueColor,
        controller: controller,
        onTap: () {
          onClickAction();
        },
        readOnly: true,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          suffixIcon: iswithArrowIcon ? Icon(Icons.arrow_drop_down) : null,
          prefixIcon: Icon(
            Icons.check_circle,
            color: categoryColor,
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          hintText: hintText,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0)),
        ));
  }

  Widget _BuildCityRoundedTextField(
      {String labelText,
      TextEditingController controller = null,
      String hintText,
      iswithArrowIcon = false,
      Function onClickAction,
      bool visible}) {
    return TextFormField(
        enableInteractiveSelection: true,
        readOnly: true,
        validator: _emptyValidate,
        autovalidate: cityColor == AppColors.validValueColor ||
            cityColor == AppColors.errorValueColor,
        controller: controller,
        onTap: () {
          onClickAction();
        },
        decoration: InputDecoration(
          suffixIcon: iswithArrowIcon ? Icon(Icons.arrow_drop_down) : null,
          prefixIcon: Icon(
            Icons.check_circle,
            color: cityColor,
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          hintText: hintText,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0)),
        ));
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

  String _titleAdsValidate(String value) {
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (value.length < 5) {
      return allTranslations.text('err_short_title');
    } else if (value.length > 60) {
      return allTranslations.text('err_long_title');
    } else {
      return null;
    }
  }

  String _descAdsValidate(String value) {
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (value.length < 10) {
      return allTranslations.text('err_short_desc');
    } else {
      return null;
    }
  }

  String _emptyValidate(String value) {
    if (value == null || value.isEmpty) {
      return allTranslations.text('empty_field');
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
                    "${allTranslations.isEnglish ? val.EnglishName : val.ArabicName} ,");
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

  Future<void> showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String _phoneValidate(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return allTranslations.text('empty_field');
    } else if (cId == 2 && value.length != 8) {
      return allTranslations.text('err_numk');
    } else if (cId == 1 && value.length != 11) {
      return allTranslations.text('err_email');
      ;
    } else {
      return null;
    }
  }

  Future getUserNumber() async {
    UserInfo userInfo = await preferences.getUserInfo();
    _phonetextController.text = userInfo.phone;
  }

  Future getUserID() async {
    UserInfo userInfo = await preferences.getUserInfo();
    userId = userInfo.id;
    userCountryId = userInfo.countryId;
  }

  void getCountryId() async {
    countryId = await preferences.getCountryID();
    cId = int.parse(countryId);
  }
}
