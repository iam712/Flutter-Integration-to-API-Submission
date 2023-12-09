part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  dynamic provinceData;
  dynamic jasaPengiriman;
  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic cityOriginList;
  dynamic selectedCityOrigin;
  dynamic cityOriginId;
  dynamic cityDestinationList;
  dynamic selectedCityDestination;
  dynamic cityDestinationId;
  dynamic calculateCost;
  bool check = false;
  dynamic dataLength;

  TextEditingController beratBarang = TextEditingController();
  // ambil data yang asingkronus(yang perlu login dll), fungsi mengembalikan nilai berupa list
  Future<List<Province>> getProvinces() async {
    dynamic prov;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        prov = value;
        isLoading = false;
      });
    });
    return prov;
  }

  //function untuk ambil data city
  Future<List<City>> getCities(var provinceId) async {
    dynamic city;
    await MasterDataService.getCities(provinceId).then((value) {
      setState(() {
        city = value;
      });
    });
    return city;
  }

  //function untuk  ambil data cost
  Future<List<Costs>> getCosts(
      var origin, var destinationId, var weight, var courier) async {
    // dynamic result;
    try {
      List<Costs> costs = await MasterDataService.getCostes(
        origin,
        destinationId,
        weight,
        courier,
      );
      setState(() {
        dataLength = costs.length;
      });
      return costs;
    } catch (error) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text("Layanan",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                            SizedBox(width: 128.0),
                            Text("Berat Barang",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // show service list
                              Expanded(
                                child: DropdownButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  value: jasaPengiriman,
                                  // hint: jasaPengiriman == null
                                  //     ? const Text("Jasa Pengiriman")
                                  //     : Text(jasaPengiriman),
                                  onChanged: (String? value) {
                                    setState(() {
                                      jasaPengiriman = value;
                                    });
                                  },
                                  items: <String>[
                                    'JNE',
                                    'TIKI',
                                    'POS',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toLowerCase(),
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: TextField(
                                  controller: beratBarang,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Berat",
                                    labelStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: [
                            Text("Provinsi Asal",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                            SizedBox(width: 95.0),
                            Text("Kota Asal",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            //show province list
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedProvinceOrigin,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedProvinceOrigin == null
                                          ? const Text("Provinsi")
                                          : Text(
                                              selectedProvinceOrigin.province),
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem<Province>>(
                                              (Province itemProvince) {
                                        return DropdownMenuItem(
                                            value: itemProvince,
                                            child: Text(itemProvince.province
                                                .toString()));
                                      }).toList(),
                                      onChanged: (newItemProvince) {
                                        setState(() {
                                          selectedProvinceOrigin = null;
                                          selectedProvinceOrigin =
                                              newItemProvince;
                                          cityOriginList = getCities(
                                              selectedProvinceOrigin.provinceId
                                                  .toString());
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("No Data");
                                  }
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            //show city list
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<City>>(
                                future: cityOriginList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityOrigin,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedCityOrigin == null
                                          ? const Text("Pilih Kota")
                                          : Text(selectedCityOrigin.cityName),
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem<City>>(
                                              (City itemCity) {
                                        return DropdownMenuItem(
                                            value: itemCity,
                                            child: Text(
                                                itemCity.cityName.toString()));
                                      }).toList(),
                                      onChanged: (newItemCity) {
                                        setState(() {
                                          selectedCityOrigin = newItemCity;
                                          cityOriginId = selectedCityOrigin
                                              .cityId
                                              .toString();
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("No Data");
                                  }
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        const Row(
                          children: [
                            Text("Provinsi Tujuan",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                            SizedBox(width: 75.0),
                            Text("Kota Tujuan",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            // show province list
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedProvinceDestination,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedProvinceDestination == null
                                          ? const Text("Provinsi")
                                          : Text(selectedProvinceDestination
                                              .province),
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem<Province>>(
                                              (Province itemProvince) {
                                        return DropdownMenuItem(
                                            value: itemProvince,
                                            child: Text(itemProvince.province
                                                .toString()));
                                      }).toList(),
                                      onChanged: (newItemProvince) {
                                        setState(() {
                                          selectedProvinceDestination = null;
                                          selectedProvinceDestination =
                                              newItemProvince;
                                          cityDestinationList = getCities(
                                              selectedProvinceDestination
                                                  .provinceId
                                                  .toString());
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("No Data");
                                  }
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            //show city list
                            Expanded(
                              flex: 3,
                              child: FutureBuilder<List<City>>(
                                future: cityDestinationList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityDestination,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      hint: selectedCityDestination == null
                                          ? const Text("Pilih Kota")
                                          : Text(
                                              selectedCityDestination.cityName),
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem<City>>(
                                              (City itemCity) {
                                        return DropdownMenuItem(
                                            value: itemCity,
                                            child: Text(
                                                itemCity.cityName.toString()));
                                      }).toList(),
                                      onChanged: (newItemCity) {
                                        setState(() {
                                          selectedCityDestination = newItemCity;
                                          cityDestinationId =
                                              selectedCityDestination.cityId
                                                  .toString();
                                        });
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text("No Data");
                                  }
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: const TextStyle(color: Colors.black),
                                    items: const [],
                                    onChanged: (value) {
                                      Null;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade600,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                  onPressed: () async {
                                    calculateCost = await getCosts(
                                        cityOriginId,
                                        cityDestinationId,
                                        beratBarang.text,
                                        jasaPengiriman);
                                    setState(() {
                                      check = true;
                                    });
                                  },
                                  child: const Text(
                                    'Hitung Estimasi Ongkir',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: !check
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Tidak ada Data"),
                          )
                        : ListView.builder(
                            itemCount: dataLength,
                            itemBuilder: (context, index) {
                              return cardTest(calculateCost[index]);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
