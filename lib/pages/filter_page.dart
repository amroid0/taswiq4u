 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/data/bloc/add_post_bloc.dart';
import 'package:olx/data/bloc/bloc_provider.dart';
import 'package:olx/data/bloc/filter_bloc.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/ads_post_entity.dart';
import 'package:olx/model/api_response_entity.dart';
import 'package:olx/model/cateogry_entity.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/model/filter_response.dart';
import 'package:olx/utils/Theme.dart';
import 'package:olx/utils/global_locale.dart';
import 'package:olx/widget/check_box_withlabel.dart';
import 'package:olx/widget/mutli_select_chip_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'cateogry_dailog.dart';

class FilterPage extends StatefulWidget {
   @override
   _FilterPageState createState() => _FilterPageState();
 }

 class _FilterPageState extends State<FilterPage> {
   FilterBloc _bloc;
   final _filterformKey = GlobalKey<FormState>();
   final _filterscaffoldKey = GlobalKey<ScaffoldState>();

   List<int> _selectedFieldValue=[];


   AddPostBloc bloc=null;
   List<Color> _colorFieldValue=[];
   FilterParamsEntity filterParamsEntity=FilterParamsEntity();
   bool isNeogtiable=false;
   List<String> adsStateList=["جديد","مستعمل"];
   String selectedAdsStates="جديد";
   final TextEditingController _cattextController = TextEditingController();
   final TextEditingController _nametextController = TextEditingController();
   final TextEditingController _pricetextController = TextEditingController();
   Color adNameColor,descColor,priceColor,emailColor,phoneColor,categoryColor=Colors.grey;
   List<TextEditingController>contollers=List();
   final scaffoldKey = GlobalKey<ScaffoldState>();

   ProgressDialog progressDialog;

   List<List> _multiselectedFieldValue=List<List<FieldProprtiresSpecificationoption>>();

   TextEditingController _fromController=TextEditingController();
   TextEditingController _toController=TextEditingController();
   String minValue="";
   String maxValue="";
   bool isFirst=true;

   @override
   void dispose() {
     // TODO: implement dispose
     _nametextController.dispose();
     super.dispose();
   }
   @override
   void initState() {
     super.initState();

     //WidgetsBinding.instance.addPostFrameCallback((_){_showDialog();});
     _bloc=FilterBloc();
     bloc=AddPostBloc();


     _cattextController.addListener((){
       bool isvalid=_emptyValidate(_cattextController.value.text)==null;
       setState(() {
         categoryColor=isvalid?AppColors.validValueColor:Colors.grey;
       });
     });


     _pricetextController.addListener((){
       bool isvalid=_emptyValidate(_pricetextController.value.text)==null;
       setState(() {
         priceColor=isvalid?AppColors.validValueColor:Colors.grey;
       });
     });
     Future.delayed(Duration.zero,()
     {
       filterParamsEntity = ModalRoute
           .of(context)
           .settings
           .arguments;
       _cattextController.text = filterParamsEntity.cateName.toString();
       if (filterParamsEntity.priceMin != null &&
           filterParamsEntity.priceMax != null) {
         if (filterParamsEntity.priceMin != 0 &&
             filterParamsEntity.priceMax != 0)
           _fromController.text = filterParamsEntity.priceMin.toString();
         _toController.text = filterParamsEntity.priceMax.toString();
         _pricetextController.text =
         "${_fromController.text}-${_toController.text}";
       }
       bloc.getAddFieldsByCatID(filterParamsEntity.categoryId);
     });

   }


   @override
   Widget build(BuildContext context) {

     return Scaffold(
       key: _filterscaffoldKey,
       appBar: AppBar(
         title: Center(
           child: Text("filter",textAlign: TextAlign.center,style: TextStyle(
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
             key: _filterformKey,
             child: Column(

                 crossAxisAlignment: CrossAxisAlignment.start,

                 children:<Widget>[


                   SizedBox(height: 8,),


                   _BuildRoundedTextField(labelText: allTranslations.text('cateogry'),
                       hintText: allTranslations.text('cateogry'),
                       controller: _cattextController,
                       iswithArrowIcon: true,enabled: false),
                   SizedBox(height: 8,),


                   TextFormField(
                       controller: _pricetextController,
                       readOnly: true,
                       onTap: (){

                         Alert(
                             context: context,
                             title: "Price",
                             content: Column(
                               children: <Widget>[
                                 TextField(

                                   controller: _fromController,
                                   decoration: InputDecoration(
                                     labelText: 'Min Price',

                                   ),
                                 ),
                                 TextField(
                                   controller: _toController,
                                   decoration: InputDecoration(
                                     labelText: 'Max Price',
                                   ),
                                 ),
                               ],
                             ),
                             buttons: [
                               DialogButton(
                                 onPressed: (){
                                   setState((){
                                     minValue=_fromController.text;
                                     maxValue=_toController.text;
                                     _pricetextController.text ="${_fromController.text}-${_toController.text}";
                                   });
                                   Navigator.pop(context);
                                 },                                 child: Text(
                                   "Ok",
                                   style: TextStyle(color: Colors.white, fontSize: 20),
                                 ),
                               )
                             ]).show();

                       },
                       keyboardType: TextInputType.numberWithOptions(decimal: true),
                       inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter((20))],
                       onSaved: (val){
                         filterParamsEntity.priceMin=double.tryParse(minValue)??0;
                         filterParamsEntity.priceMax=double.tryParse(maxValue)??0;

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
                       if(filterParamsEntity.params==null){
                         filterParamsEntity.params=List(snapshot.data.data.length);
                       }

                       return ListView.builder(

                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemCount: fields.length,
                         itemBuilder: (context, index) {
                           var item = fields[index];
                           if(isFirst &&filterParamsEntity.params!=null&&filterParamsEntity.params.isNotEmpty)
                           for (var spec in filterParamsEntity.params) {
                             if(spec!=null&&spec.specificationId!=null)
                               if(spec.specificationId==item.Id){
                               if(item.MuliSelect==null||!item.MuliSelect) {
                                 if (spec.options
                                     .length == 1)
                                   if(spec.options[0]!=0)
                                   _selectedFieldValue[index] =
                                       spec.options[0];
                               }else if(item.CustomValue==null){
                                 _multiselectedFieldValue[index] = spec.options;
                                 /*String text="";
                                 spec..forEach((val)=>text+="${val.NameEnglish} ,");
                                 contollers[index].text=text;*/

                               }else{

                                 contollers[index].text=spec.value;

                               }
                               break;
                             }
                           }
                           //if(item.CustomValue==null)
                           if(item.MuliSelect==null||!item.MuliSelect)
                             return Padding(
                               padding: const EdgeInsets.only(bottom:8.0),
                               child: FormField<String>(

                                   onSaved: (val){
                                     if(val!=null) {
                                       var vv = Params();
                                       vv.specificationId = item.Id;
                                       vv.hasOptions=true;
                                       vv.hasRange=false;
                                       int itemval = int.tryParse(val) ?? 0;
                                       vv.options = [itemval];
                                       filterParamsEntity.params[index] = vv;
                                     }
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
                                              isFirst=false;
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


                             return Padding(
                               padding: const EdgeInsets.only(bottom:8.0),
                               child: TextFormField(
                                   controller: contollers[index],
                                   onTap:() {
                                     WidgetsBinding.instance.addPostFrameCallback((_){_showReportDialog(index, item.EnglishName, item.SpecificationOptions);});
                                   },
                                    readOnly: true,
                                    onSaved: (val){
                                     var vv=Params();
                                     vv.specificationId=item.Id;
                                     //int itemval=item.Value as int ?? 0;
                                     vv.options=_multiselectedFieldValue[index];
                                     filterParamsEntity.params[index]=vv;
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
                                   onSaved: (val){
                                     var vv=Params();
                                     vv.specificationId=item.Id;
                                     //int itemval=item.Value as int ?? 0;
                                     //vv.options=[val];
                                     filterParamsEntity.params[index]=vv;

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

                   SizedBox(width: double.infinity,height: 60
                     ,child: RaisedButton(
                       color:  Colors.green,
                       onPressed: (){

                             _filterformKey.currentState.save();
                             Navigator.pop(context,filterParamsEntity); // <--- add message

                       },
                       child: Center(child: Text(allTranslations.text('ads_filter'))),textColor: Colors.white,),)



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
     Function onClickAction,bool enabled=true}){
     return TextFormField(
       enabled: enabled,
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




 }








