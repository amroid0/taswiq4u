import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olx/data/bloc/add_post_bloc.dart';
import 'package:olx/data/bloc/upload_image_bloc.dart';
import 'package:olx/generated/i18n.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/StateEnum.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/model/upload_image_entity.dart';
import 'package:olx/pages/ImageUploaderListPage.dart';
import 'package:olx/pages/cateogry_dialog_page.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/widget/check_box_withlabel.dart';
import 'package:olx/widget/map_widget.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
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
   final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _pricetextController = TextEditingController();
  final TextEditingController _phonetextController = TextEditingController();
  final TextEditingController _emailtextController = TextEditingController();
  Color adNameColor,descColor,priceColor,emailColor,phoneColor,categoryColor=Colors.grey;
  GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  CateogryEntity _selectedcataogry;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UploadImageBloc uploadBloc;

  ProgressDialog progressDialog;

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
   _nametextController.addListener((){
     bool isvalid=_titleAdsValidate(_nametextController.value.text)==null;
     setState(() {
       adNameColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
     });
   });

    _cattextController.addListener((){
      bool isvalid=_emptyValidate(_cattextController.value.text)==null;
      setState(() {
        categoryColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });


    _pricetextController.addListener((){
      bool isvalid=_emptyValidate(_pricetextController.value.text)==null;
      setState(() {
        priceColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });
    _emailtextController.addListener((){
      bool isvalid=_emailValidate(_emailtextController.value.text)==null;
      setState(() {
        emailColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });
    _phonetextController.addListener((){
      bool isvalid=_phoneValidate(_phonetextController.value.text)==null;
      setState(() {
        phoneColor=isvalid?AppColors.validValueColor:AppColors.errorValueColor;
      });
    });



  }
  _showDialog() async{
    await  SelectDialog.showModal<CateogryEntity>(
      context,
      label: "choose Cateogry",
      selectedValue: CateogryEntity(),
      items: List(),
      onChange: (CateogryEntity selected) {
        _cattextController.text=selected.name.toString();
        _selectedFieldValue=[];
        _colorFieldValue=[];
        bloc.getAddFieldsByCatID(selected.id);
          _selectedcataogry=selected;

      },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text('اضافه اعلان',textAlign: TextAlign.center,style: TextStyle(
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
            onPressed: () {},
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
         child: Text("اضف صور للاعلان"),
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
          adsPostEntity.Title=val;
          },
          decoration: InputDecoration(

           prefixIcon: Icon(Icons.check_circle,color: adNameColor,),
            filled: true,
            fillColor: Colors.white,
            labelText: "اسم الاعلان",
            hintText: "اسم الاعلان",

            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0)),
          )
      ),
        SizedBox(height: 8,),
        _BuildRoundedTextField(labelText: "التصنيف",hintText: "التصنيف",controller: _cattextController,
            iswithArrowIcon: true,onClickAction: (){
          _showDialog();
        }),
            SizedBox(height: 8,),

            TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.check_circle,color: descColor,),

                  filled: true,
                  fillColor: Colors.white,
                  labelText: "تفاصيل الاعلان",
                  hintText: "تفاصيل الاعلان",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                ),
              onSaved: (val){
                adsPostEntity.EnglishDescription=val;
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
        adsPostEntity.Price=int.tryParse(val)??0;
      },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.check_circle,color: priceColor,),
          filled: true,
          fillColor: Colors.white,
          labelText: "السعر",
          hintText: "السعر",
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
              return ListView.builder(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  var item = fields[index];

                  if(item.IsCustomValue==null)

                    return Padding(
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


                            child:DropdownButtonHideUnderline(
                              child: DropdownButton(

                                hint: Text('اختر ${item.ArabicName}'),
                                value:_selectedFieldValue[index],
                                isDense: true,
                                items: item.SpecificationOptions.map((FieldProprtiresSpecificationoption value){
                                  return DropdownMenuItem(
                                    value: value.Id,
                                    child: Text(value.ArabicName),
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


                  else{
                       return Padding(
                         padding: const EdgeInsets.only(bottom:8.0),
                         child: TextFormField(
                           validator: _emptyValidate,
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
                             decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: item.ArabicName,
                              hintText: item.ArabicName,


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
            TextFormField(
                controller: _emailtextController,

                autovalidate: emailColor==AppColors.validValueColor||emailColor==AppColors.errorValueColor,
                validator: _emailValidate,
                onSaved: (val){
                  adsPostEntity.Email=val;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.check_circle,color: emailColor,),

                  filled: true,
                  fillColor: Colors.white,
                  labelText: "الايميل",
                  hintText: "الايميل",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                )
            ),
            SizedBox(height: 8,),
            TextFormField(
                controller: _phonetextController,
                validator: _phoneValidate,
                autovalidate: phoneColor==AppColors.validValueColor||phoneColor==AppColors.errorValueColor,
                onSaved: (val){
                  adsPostEntity.Phone=val;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.check_circle,color: phoneColor,),

                  filled: true,
                  fillColor: Colors.white,
                  labelText: "الهاتف",
                  hintText: "الهاتف",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                )
            ),
            SizedBox(height: 8,),
          Center(
            child: InkWell(


              child: MapWidget(
                  center: LatLng(0, 0),
                  mapController: _mapController,
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                onTap: (lat) async {
                  LocationResult result = await LocationPicker.pickLocation(context, "AIzaSyC57DQKo0jhnTJtdZX1Lp7LAIFmAFhZiNQ",
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
                  label: "السعر قابل للتفاوض",
                  value: isNeogtiable,
                  onChanged: (newValue) {
                    setState(() {
                      isNeogtiable=newValue;
                      adsPostEntity.IsNogitable=newValue;
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
                    for(var image in uploadBloc.getUploadImageList){

                      if(image is UploadedImage&& image.state == StateEnum.LOADING){
                        if(image.remoteUrl!=null&& image.remoteUrl.isNotEmpty){
                        PhotosBean photo=new PhotosBean(image.remoteUrl.toString(),count);
                        images.add(photo);
                        count++;
                        }
                      }else{
                        isuploaded==false;
                        break;
                      }
                    }
                    if(isuploaded){
                      adsPostEntity.Photos=List<PhotosBean>();
                      adsPostEntity.Photos.addAll(images);
                    }else{
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('images not all uploaded')));
                      return;
                    }
                    progressDialog = new ProgressDialog(context,ProgressDialogType.Normal);


                    progressDialog.setMessage("Loading..");
                    progressDialog.show();
                    adsPostEntity.LocationLatitude=0 /*_markers.elementAt(0).position.latitude as int*/;
                    adsPostEntity.LocationLongtude=0 /*_markers.elementAt(0).position.longitude as int*/;
                    bloc.postAds(adsPostEntity);


                  }

                },
                child: Center(child: Text("اضافه الاعلان")),textColor: Colors.white,),)
,
            StreamBuilder<bool>(
              stream:bloc.addStream,
              builder: (context,snapshot){
                progressDialog?.hide();
                 if (snapshot.hasData)
                   {
                     snapshot.data?scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("sucess")))
                         :
                     scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("error")));
                   }
                 else if(snapshot.hasError){
                   scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(" eccecption error")));

                 }
             return Container();

              }
              ,)


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
       return "الحقل فارغ";
     }
     else if(value.length<3){
       return"الاسم قصير";
     }else{
       return null;
     }
  }

  String _phoneValidate(String value){

    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp=RegExp(patttern);
    if(value.isEmpty){
      return "الحقل فارغ";
    }

    else if(!regExp.hasMatch(value)){
      return"{قم الهاتف غير صحيح";
    }else{
      return null;
    }
  }
  String _emailValidate(String value){

    String patttern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp=RegExp(patttern);
    if(value.isEmpty){
      return "الحقل فارغ";
    }

    else if(!regExp.hasMatch(value)){
      return"الايميل  غير صحيح";
    }else{
      return null;
    }
  }
  String _emptyValidate(String value){

    if(value==null||value.isEmpty){
      return "الحقل فارغ";
    }
  else{
      return null;
    }
  }



}


