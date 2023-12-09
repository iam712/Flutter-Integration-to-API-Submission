part of 'services.dart';

class MasterDataService {
  
  static Future<List<Province>> getProvince() async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          "Content-Type": "application/json, charset=UTF-8",
          "key": Const.apiKey,
        });
    

    var job = json.decode(response.body);
    //print(job.toString());
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  static Future<List<City>> getCities(var provId) async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/city"),
        headers: <String, String>{
          "Content-Type": "application/json, charset=UTF-8",
          "key": Const.apiKey,
        });
    
    var job = json.decode(response.body);
    List<City> result = [];
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();

    }
    List<City> terserah = [];
    for (var i in result){
      if(i.provinceId == provId){
        terserah.add(i);
      }
    }
    return terserah;
  }

  static Future<List<Costs>> getCostes(var originId, var destinationId, var berat, var kurir) async {

    final Map<String, dynamic> costData= {
      "origin" : originId,
      "destination" : destinationId,
      "weight" : berat.toString(),
      "courier" : kurir.toString(),
    };

    var response = await http.post(Uri.https(Const.baseUrl, "/starter/cost"),
        headers: <String, String>{
          "Content-Type": "application/json, charset=UTF-8",
          "key": Const.apiKey,
        },
        body: jsonEncode(costData)
      );
    

    var job = json.decode(response.body);
    List<Costs> terserah = [];

    if (response.statusCode == 200) {
      terserah = (job['rajaongkir']['results'][0]['costs'] as List)
          .map((e) => Costs.fromJson(e))
          .toList();

    }
    else {
      print('${response.statusCode}');
    }
    //print(terserah);
    
    return terserah;
  }
}
