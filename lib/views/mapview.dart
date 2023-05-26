import 'package:flutter/material.dart';
import 'package:mycsf_app_client/api/map.dart';

import 'components/loadingimage.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool _isListOpen = false;
  Map<String, String> buildingsRu = {};
  List<MyMap>? maps;
  String selectedKey = "m";// MAIN BUILDING
  int? selectedLayer;
  String? currUrl;

  @override
  void initState() {
    super.initState();
    MapController.getRuBuildings().then((value) {
      setState(() {
        buildingsRu = value;
      });
      MapController.getMapsByBuilding(selectedKey).then(
              (value) {
            setState(() {
              maps = value;
            });
            if (maps != null) {
              int minLayer = maps!.reduce((value, element) =>
              element.buildingLevel < value.buildingLevel ? element : value
              ).buildingLevel;
              setState(() {
                selectedLayer = minLayer;
              });
              String? newUrl = getImageUrl(maps, selectedKey, minLayer);
              setState(() {
                currUrl = newUrl;
              });
              // print("$maps, $selectedKey, $selectedLayer, $newUrl");
            }

          }
      );

    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки данных: $error'),
        ),
      );
    });
  }

  int? getNextLayer(List<MyMap>? objects, int? currentValue) {
    if (currentValue == null || objects == null) {
      return null;
    }
    List<int> filteredValues = objects
        .where((object) => object.buildingLevel > currentValue)
        .map((object) => object.buildingLevel)
        .toList();

    if (filteredValues.isEmpty) {
      return objects.reduce((minObject, currentObject) =>
        currentObject.buildingLevel < minObject.buildingLevel ?
        currentObject :
        minObject
      ).buildingLevel;
    }

    int nextValue = filteredValues.fold(
        objects
            .map((object) => object.buildingLevel)
            .reduce((minValue, value) => minValue > value ? minValue : value),
            (minValue, value) => minValue < value ? minValue : value
    );
    return nextValue;
  }

  String? getImageUrl(List<MyMap>? maps, String? building, int? selectedLayer) {
    // print("$maps, $building, $selectedLayer");
    if (maps == null || building == null || selectedLayer == null) {
      return null;
    }
    try {
      MyMap? foundObj = maps.firstWhere(
              (object) => object.building == building && object.buildingLevel == selectedLayer
      );
      return foundObj.mapFile;
    }
    catch (e) {
      print(e);
    }
    return null;

  }

  Widget _makeButton(
      {required String text,
      required Function f,
      double paddingLeft = 0,
      double paddingRight = 0,
      double paddingBottom = 20}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: paddingLeft, right: paddingRight, bottom: paddingBottom),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD9D9D9),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(200, 50),
              elevation: 10,
              alignment: Alignment.center,
            ),
            onPressed: () {
              f();
            },
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
          ),
        )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                        child: _makeButton(
                            text:
                              buildingsRu.isEmpty ?
                              "" :
                              "${buildingsRu[selectedKey]} $selectedLayer этаж",
                            paddingBottom: 10,
                            f: () {
                              setState(() {
                                _isListOpen = !_isListOpen;
                              });
                            }
                            )
                    )
                )
            )
        ),
        const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 25
            ),
          child: Divider(color: Colors.black,),
        ),
        if (_isListOpen)
        Container(
          constraints: const BoxConstraints(
            maxHeight: 300,
          ),
          child: SingleChildScrollView(
              child: Center(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var currBuilding in buildingsRu.entries)
                              _makeButton(
                                  text: currBuilding.value,
                                  f: () {
                                    if (selectedKey != currBuilding.key) {
                                      setState(() {
                                        selectedKey = currBuilding.key;
                                      });
                                      MapController.getMapsByBuilding(selectedKey).then(
                                              (value) {
                                            setState(() {
                                              maps = value;
                                            });
                                            if (maps != null) {
                                              int minLayer = maps!.reduce((value, element) =>
                                              element.buildingLevel < value.buildingLevel ? element : value
                                              ).buildingLevel;
                                              setState(() {
                                                selectedLayer = minLayer;
                                              });
                                              String? newUrl = getImageUrl(maps, selectedKey, minLayer);
                                              setState(() {
                                                currUrl = newUrl;
                                              });
                                              // print("$maps, $selectedKey, $selectedLayer, $newUrl");
                                            }
                                          }
                                      ).catchError((error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Ошибка загрузки данных: $error'),
                                          ),
                                        );
                                      });
                                      String? newUrl = getImageUrl(maps, selectedKey, selectedLayer);
                                      setState(() {
                                        currUrl = newUrl;
                                      });
                                    }
                                  },
                                  paddingLeft: 40,
                                  paddingRight: 40
                              ),
                            const Divider(color: Colors.black,),
                          ]
                      )
                  )
              )
          ),
        ),
        Expanded(
          child: Container(
              child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.1,
                  maxScale: 4.0,
                  child: Container(
                    constraints: BoxConstraints.expand(),
                    child:
                      currUrl == null ?
                        Image.asset("assets/map/NO_IMAGE.png") :
                        LoadingImageWidget(imageUrl: currUrl!)
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      int? nextLayer = getNextLayer(maps, selectedLayer);
                      setState(() {
                        selectedLayer = nextLayer;
                      });
                      String? newUrl = getImageUrl(maps, selectedKey, nextLayer);
                      setState(() {
                        currUrl = newUrl;
                      });
                    },
                    child: Image.asset(
                      'assets/map/layer_select.png',
                      width: 100,
                      height: 70,
                    ),
                  ),
                )
              ),
            ],
          )),
        ),
      ],
    );
  }
//   Stack(
//   children: [
//     Center(
//       child: InteractiveViewer(
//         boundaryMargin: const EdgeInsets.all(20),
//         minScale: 0.1,
//         maxScale: 4.0,
//         child: Container(
//           constraints: BoxConstraints.expand(),
//           child: Image.asset(
//             "assets/example.png",
//           ),
//         ),
//       ),
//     ),
//     Align(
//       alignment: Alignment.bottomRight,
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: () {
//             // Button onPressed action
//           },
//           child: Text('Button'),
//         ),
//       ),
//     ),
//   ],
// );
}
