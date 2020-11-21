 import 'package:olx/data/remote/NetworkCommon.dart';
import 'package:olx/model/FieldproprtieyReposne.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/utils/Constants.dart';

class SearchClient{
  Future<FieldPropReponse>getFieldsFilters(String catID) async{
      final results = await NetworkCommon().dio.get(APIConstants.FIELDS_ADD_ADS+catID.toString(),
      );
      if(results.statusCode==200){
        final suggestions = results.data;
        var list= suggestions
            .map<FieldProprtiresEntity>((json) => FieldProprtiresEntity.fromJson(json))
            .toList(growable: false);
        return FieldPropReponse(list, true);
      }else{
        return FieldPropReponse(List(), false);

 }
  }
}