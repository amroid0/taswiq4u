import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/add_post_bloc.dart';
import 'package:olx/data/bloc/upload_image_bloc.dart';
import 'package:olx/generated/i18n.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/country_entity.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/pages/ImageUploaderListPage.dart';
import 'package:olx/pages/cateogry_dialog_page.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/dailogs.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/utils/loading_dialog.dart';
import 'package:olx/widget/check_box_withlabel.dart';
import 'package:olx/widget/city_list_dialog.dart';
import 'package:olx/widget/map_widget.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:olx/widget/multi_select_dialog.dart';
import 'package:olx/widget/multi_select_form.dart';
import 'package:olx/widget/mutli_select_chip_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../data/bloc/bloc_provider.dart';
import '../data/bloc/cateogry_bloc.dart';
import 'cateogry_dailog.dart';

class AddAdvertisment extends StatefulWidget {
  @override
  _AddAdvertismentState createState() => _AddAdvertismentState();
}

class _AddAdvertismentState extends State<AddAdvertisment> {
  AddPostBloc bloc=null;
  List<int> _selectedFieldValue=[];
  List<Color> _colorFieldValue=[];
  AdsPostEntity adsPostEntity=AdsPostEntity();
  final _formKey = GlobalKey<FormState>();
  bool isNeogtiable=false;
  List<String> adsStateList=["جديد","مستعمل"];
  String selectedAdsStates="جديد";
   final TextEditingController _cattextController = TextEditingController();
  final TextEditingController _citytextController = TextEditingController();
  final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _pricetextController = TextEditingController();
  final TextEditingController _desctextController = TextEditingController();
  Color adNameColor,descColor,priceColor,categoryColor,cityColor=Colors.grey;
  GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  List<TextEditingController>contollers=List();
  CateogryEntity _selectedcataogry;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UploadImageBloc uploadBloc;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();


  ProgressDialog progressDialog;

  List<List> _multiselectedFieldValue=List<List<FieldProprtiresSpecificationoption>>();


@override
  void dispose() {
    // TODO: implement dispose
  _nametextController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){_showDialog();});
   bloc=AddPostBloc();
   uploadBloc =UploadImageBloc();

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



          var isLogged=data as ApiResponse<bool>;
          var isss=isLogged.data;
          if(isss){

            Fluttertoast.showToast(
                msg: "Sucessfully Added'",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
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
              fontSize: 16.0
          );
          break;
      }
    });



   _nametextController.addListener((){
     bool isvalid=_titleAdsValidate(_nametextController.value.text)==null;
     setState(() {
       adNameColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
     });
   });

    _desctextController.addListener((){
      bool isvalid=_descAdsValidate(_desctextController.value.text)==null;
      setState(() {
        descColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });

    _cattextController.addListener((){
      bool isvalid=_emptyValidate(_cattextController.value.text)==null;
      setState(() {
        categoryColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });
    _citytextController.addListener((){
      bool isvalid=_emptyValidate(_citytextController.value.text)==null;
      setState(() {
        cityColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });


    _pricetextController.addListener((){
      bool isvalid=_emptyValidate(_pricetextController.value.text)==null;
      setState(() {
        priceColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });




  }
  _showDialog() async{
    await  SelectDialog.showModal<CateogryEntity>(
      context,
      label: allTranslations.text('choose_category'),
      selectedValue: CateogryEntity(),
      items: List(),
      onChange: (CateogryEntity selected) {
        _cattextController.text=selected.name.toString();
        _selectedFieldValue=[];
        _colorFieldValue=[];
        bloc.getAddFieldsByCatID(selected.id);
          _selectedcataogry=selected;
          adsPostEntity.categoryId=selected.id;

      },);
  }

  _showCityDialog() async{
    await  CityListDialog.showModal<CountryEntity>(
      context,
      label: allTranslations.text('choose_city'),
      selectedValue: CountryEntity(),
      items: List(),
      onChange: (CountryEntity selected) {
        _citytextController.text=selected.name.toString();
        adsPostEntity.stateId=selected.id;
        adsPostEntity.cityId=selected.id;


      },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(allTranslations.text('ads_add'),textAlign: TextAlign.center,style: TextStyle(
              color:
          Colors.black38

          ),),
        ),

        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_ios,color: Colors.black38,),
            onPressed: () {
              Navigator.pop(context);

            },
            tooltip: 'back',
          ),
        ],
            ),
body: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   SingleChildScrollView(
    child: Form(
      key: _formKey,
      child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children:<Widget>[


       Padding(
         padding: const EdgeInsets.only(left:8.0),
         child: Text(allTranslations.text('add_image')),
       ),
      BlocProvider(
      bloc: uploadBloc,child:ImageInput()),//add image list

      TextFormField(

        validator:_titleAdsValidate,
          autovalidate: adNameColor==AppColors.validValueColor||adNameColor==AppColors.errorValueColor,
          controller: _nametextController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(200)
          ],
          onSaved: (val){
          adsPostEntity.title=val;
          },
          decoration: InputDecoration(

           prefixIcon: Icon(Icons.check_circle,color: adNameColor,),
            filled: true,
            fillColor: Colors.white,
            labelText: allTranslations.text('ads_title'),
            hintText:  allTranslations.text('ads_title'),

            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0)),
          )
      ),
        SizedBox(height: 8,),


        _BuildRoundedTextField(labelText: allTranslations.text('cateogry'),
            hintText: allTranslations.text('cateogry'),
            controller: _cattextController,
            iswithArrowIcon: true,onClickAction: (){
          _showDialog();
        }),
            SizedBox(height: 8,),
            SizedBox(height: 8,),

            _BuildCityRoundedTextField(labelText: allTranslations.text('city'),
                hintText: allTranslations.text('city'),
                controller: _citytextController,
                iswithArrowIcon: true,onClickAction: (){
                  _showCityDialog();
                }),
            SizedBox(height: 8,),

            TextFormField(

              controller: _desctextController,
              validator: _descAdsValidate,
              autovalidate: descColor==AppColors.validValueColor||descColor==AppColors.errorValueColor,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.check_circle,color: descColor,),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: allTranslations.text('description'),
                  hintText: allTranslations.text('description'),
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                ),
              onSaved: (val){
                adsPostEntity.englishDescription=val;
              },
            ),

            SizedBox(height: 8,),


  TextFormField(
      controller: _pricetextController,

      autovalidate: priceColor==AppColors.validValueColor||priceColor==AppColors.errorValueColor,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter((20))],
         validator: _emptyValidate,
      onSaved: (val){
        adsPostEntity.price=int.tryParse(val)??0;
      },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.check_circle,color: priceColor,),
          filled: true,
          fillColor: Colors.white,
          labelText: allTranslations.text('price'),
          hintText: allTranslations.text('price'),
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0)),
        )
  ),

            SizedBox(height: 8,),

            StreamBuilder<FieldPropReponse>(
            stream: bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.data!=null &&snapshot.data.isSucess==false)
                return Visibility(child: Text(""),visible: false,);
              else if (!snapshot.hasData)
                return  SizedBox.shrink();
              var fields=snapshot.data.data;
             if(_selectedFieldValue.isEmpty) _selectedFieldValue=List(snapshot.data.data.length);
              if(_colorFieldValue.isEmpty) _colorFieldValue=List(snapshot.data.data.length);
              if(_multiselectedFieldValue.isEmpty) _multiselectedFieldValue=List(snapshot.data.data.length);
              if(contollers.isEmpty) contollers=List(snapshot.data.data.length);
              if(adsPostEntity.advertismentSpecification==null){
                adsPostEntity.advertismentSpecification=List(snapshot.data.data.length);
              }
              return ListView.builder(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  var item = fields[index];

                  //if(item.CustomValue==null)
                  if(item.MuliSelect==null||!item.MuliSelect)
                    return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: FormField<String>(

                        autovalidate: item.Required,
                          validator:item.Required?_emptyValidate:null,
                          onSaved: (val){
                          var vv=Advertisment_SpecificationBean();
                          vv.id=item.Id;
                          int itemval=int.tryParse(val) ?? 0;
                          vv.advertismentSpecificatioOptions=[itemval];
                          adsPostEntity.advertismentSpecification[index]=vv;

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


                            child:DropdownButtonHideUnderline(
                              child: DropdownButton(

                                hint: Text('${allTranslations.text('choose')} ${allTranslations.isEnglish?item.EnglishName:item.ArabicName}'),
                                value:_selectedFieldValue[index],
                                isDense: true,
                                items: item.SpecificationOptions.map((FieldProprtiresSpecificationoption value){
                                  return DropdownMenuItem(
                                    value: value.Id,
                                    child: Text(allTranslations.isEnglish?value.EnglishName:value.ArabicName),
                                  );
                                }).toList(),

                                   onChanged: (int newValue){
                                     item.Value=newValue;
                                     setState(() {
                                    _selectedFieldValue[index]=newValue;
                                    state.didChange(newValue.toString());
                                    _colorFieldValue[index]=AppColors.validValueColor;

                                     });
                                   },
                              ),
                            ) ,

                          );}

                      ),
                    );


                  else if(item.CustomValue==null)
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
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: TextFormField(
                        controller: contollers[index],
                          onTap:() {
                            WidgetsBinding.instance.addPostFrameCallback((_){_showReportDialog(index, item.EnglishName, item.SpecificationOptions);});
                            },
                          readOnly: true,
                          autovalidate: item.Required,
                          validator: item.Required?_emptyValidate:null,
                          onSaved: (val){

                            var vv=Advertisment_SpecificationBean();
                            vv.id=item.Id;
                            //int itemval=item.Value as int ?? 0;
                            vv.customValue=val;
                            adsPostEntity.advertismentSpecification[index]=vv;
                            },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,

                            labelText: allTranslations.isEnglish?item.EnglishName:item.ArabicName,
                            hintText:allTranslations.isEnglish?item.EnglishName:item.ArabicName,
                            prefixIcon: item.Required?Icon(Icons.check_circle,color: _colorFieldValue[index],):null,
                            suffixIcon:  Icon(Icons.arrow_drop_down),
                            border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                          )
                      ),
                    );



                  else{
                       return Padding(
                         padding: const EdgeInsets.only(bottom:8.0),
                         child: TextFormField(
                             controller: contollers[index],
                           autovalidate: true,
                           validator: _emptyValidate,
                             onSaved: (val){

                               var vv=Advertisment_SpecificationBean();
                               vv.id=item.Id;
                               vv.customValue=val;
                               //int itemval=item.Value as int ?? 0;
                               //vv.AdvertismentSpecificatioOptions=[val];
                               adsPostEntity.advertismentSpecification[index]=vv;

                             },
                             decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: allTranslations.isEnglish?item.EnglishName:item.ArabicName,
                              hintText:allTranslations.isEnglish?item.EnglishName:item.ArabicName,
                               prefixIcon: item.Required?Icon(Icons.check_circle,color: _colorFieldValue[index],):null,


                              border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0)),
                            )
                      ),
                       );

                  }














                },//
              );
            },
          ),
            SizedBox(height: 8,),
            SizedBox(height: 8,),
          Center(
            child: InkWell(


              child: MapWidget(
                  center: LatLng(0, 0),
                  mapController: _mapController,
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                onTap: (lat) async {
                  LocationResult result = await showLocationPicker(context, "AIzaSyC57DQKo0jhnTJtdZX1Lp7LAIFmAFhZiNQ",
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
                          target:result.latLng,
                          zoom: 20.0,
                        ),
                      ),
                    );
                  });

                },
              ),
            ),
          ),
            SizedBox(height: 8,),
            Center(
              child: CheckboxLabel(
                  label: allTranslations.text('negtoable'),
                  value: isNeogtiable,
                  onChanged: (newValue) {
                    setState(() {
                      isNeogtiable=newValue;
                      adsPostEntity.isNogitable=newValue;
                    });
                  },
                ),
            ),

            SizedBox(height: 8,),

            SizedBox(width: double.infinity,height: 60
              ,child: RaisedButton(
                color:  Colors.green,
                onPressed: (){
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    int count=0;
                    var images=<PhotosBean>[];
                    bool isuploaded=true;
                    List<ImageListItem>uploadedimges=uploadBloc.getUploadImageList;
                    for(var image in uploadedimges){

                      if(image is UploadedImage&& image.state != StateEnum.LOADING){
                        if(image.remoteUrl!=null&& image.remoteUrl.isNotEmpty){
                        PhotosBean photo=new PhotosBean(image.remoteUrl.toString(),count);
                        images.add(photo);
                        count++;
                        }
                      }else if(image is UploadedImage&& image.state == StateEnum.LOADING){
                        isuploaded==false;
                        break;
                      }
                    }
                    if(isuploaded){
                      adsPostEntity.photos=List<PhotosBean>();
                      adsPostEntity.photos.addAll(images);
                    }else{
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('images not all uploaded')));
                      return;
                    }
                    adsPostEntity.locationLatitude=0 /*_markers.elementAt(0).position.latitude as int*/;
                    adsPostEntity.locationLongtude=0 /*_markers.elementAt(0).position.longitude as int*/;
                    bloc.postAds(adsPostEntity);


                  }

                },
                child: Center(child: Text(allTranslations.text('ads_add'))),textColor: Colors.white,),)
,



          ]
          ),
    ),
  ),
),





/*
        BlocProvider(
            bloc: UploadImageBloc(),child:ImageInput()),*/

    );
  }


  Widget _BuildRoundedTextField({ String labelText,TextEditingController controller=null,String hintText,iswithArrowIcon=false,
      Function onClickAction}){
   return TextFormField(
     validator: _emptyValidate,
       autovalidate: categoryColor==AppColors.validValueColor||categoryColor==AppColors.errorValueColor,
     controller: controller,
     onTap: (){
         onClickAction();
     },
        decoration: InputDecoration(
          suffixIcon: iswithArrowIcon? Icon(Icons.arrow_drop_down):null,
          prefixIcon: Icon(Icons.check_circle,color: categoryColor,),


          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          hintText: hintText,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0)),
        )
    );

  }

  Widget _BuildCityRoundedTextField({ String labelText,TextEditingController controller=null,String hintText,iswithArrowIcon=false,
    Function onClickAction}){
    return TextFormField(
        validator: _emptyValidate,
        autovalidate: cityColor==AppColors.validValueColor||cityColor==AppColors.errorValueColor,
        controller: controller,
        onTap: (){
          onClickAction();
        },
        decoration: InputDecoration(
          suffixIcon: iswithArrowIcon? Icon(Icons.arrow_drop_down):null,
          prefixIcon: Icon(Icons.check_circle,color: cityColor,),


          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          hintText: hintText,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0)),
        )
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
            target:LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 20.0,
          ),
        ),
      );    });
  }
  String _titleAdsValidate(String value){
     if(value.isEmpty){
       return allTranslations.text('empty_field');
     }
     else if(value.length<3){
       return allTranslations.text('err_short');
     }else{
       return null;
     }
  }
  String _descAdsValidate(String value){
    if(value.isEmpty){
      return allTranslations.text('empty_field');
    }
    else if(value.length<30){
      return allTranslations.text('err_short');
    }else{
      return null;
    }
  }

  String _emptyValidate(String value){

    if(value==null||value.isEmpty){
      return allTranslations.text('empty_field');
    }
  else{
      return null;
    }
  }

  _showReportDialog(int index,String title,List<FieldProprtiresSpecificationoption> list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text(title),
            content: MultiSelectChip(
              list,
              onSelectionChanged: (selectedList) {
                if(contollers[index]==null){
                  contollers[index]=TextEditingController();}
                String text="";
                selectedList.forEach((val)=>text+="${val.EnglishName} ,");
                contollers[index].text=text;
                setState(() {

                  _multiselectedFieldValue[index] = selectedList;
                  _colorFieldValue[index]=AppColors.validValueColor;

                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }


  Future<void> showSnackBar(BuildContext context,String message)async{

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),

    );
    Scaffold.of(context).showSnackBar(snackBar);
  }


}


