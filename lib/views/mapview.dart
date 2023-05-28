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
  Map<String, String> _buildingsRu = {};
  Key _childKey = UniqueKey();
  List<MyMap>? _maps;
  String _selectedKey = "m"; // MAIN BUILDING
  int? _selectedLayer;
  String? _currUrl;

  void _resetChildKey() {
    setState(() {
      _childKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    MapController.getRuBuildings().then((value) {
      setState(() {
        _buildingsRu = value;
      });
      MapController.getMapsByBuilding(_selectedKey).then((value) {
        setState(() {
          _maps = value;
        });
        if (_maps != null) {
          int minLayer = _maps!
              .reduce((value, element) =>
                  element.buildingLevel < value.buildingLevel ? element : value)
              .buildingLevel;
          setState(() {
            _selectedLayer = minLayer;
          });
          String? newUrl = getImageUrl(_maps, _selectedKey, minLayer);
          setState(() {
            _currUrl = newUrl;
          });
          // print("$maps, $selectedKey, $selectedLayer, $newUrl");
        }
      });
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
      return objects
          .reduce((minObject, currentObject) =>
              currentObject.buildingLevel < minObject.buildingLevel
                  ? currentObject
                  : minObject)
          .buildingLevel;
    }

    int nextValue = filteredValues.fold(
        objects
            .map((object) => object.buildingLevel)
            .reduce((minValue, value) => minValue > value ? minValue : value),
        (minValue, value) => minValue < value ? minValue : value);
    return nextValue;
  }

  String? getImageUrl(List<MyMap>? maps, String? building, int? selectedLayer) {
    // print("$maps, $building, $selectedLayer");
    if (maps == null || building == null || selectedLayer == null) {
      return null;
    }
    try {
      MyMap? foundObj = maps.firstWhere((object) =>
          object.building == building && object.buildingLevel == selectedLayer);
      return foundObj.mapFile;
    } catch (e) {
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
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                key: _childKey,
                boundaryMargin: const EdgeInsets.all(50),
                minScale: 0.1,
                maxScale: 4.0,
                child: Container(
                    constraints: BoxConstraints.expand(),
                    child: _currUrl == null
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Color(0xFFD9D9D9),
                          ))
                        : LoadingImageWidget(imageUrl: _currUrl!)
                    ),
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      int? nextLayer = getNextLayer(_maps, _selectedLayer);
                      setState(() {
                        _selectedLayer = nextLayer;
                        _isListOpen = false;
                      });
                      String? newUrl =
                          getImageUrl(_maps, _selectedKey, nextLayer);
                      setState(() {
                        _currUrl = newUrl;
                      });
                      _resetChildKey();
                    },
                    child: Image.asset(
                      'assets/map/layer_select.png',
                      width: 100,
                      height: 70,
                    ),
                  ),
                )),
          ],
        )
        ),
        Column(
          children: [
            Container(
              color: Colors.white,
                child: SingleChildScrollView(
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 0),
                            child: _makeButton(
                                text: _buildingsRu.isEmpty
                                    ? ""
                                    : "${_buildingsRu[_selectedKey]} $_selectedLayer этаж",
                                paddingBottom: 10,
                                f: () {
                                  setState(() {
                                    _isListOpen = !_isListOpen;
                                  });
                                }))))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                color: Colors.black,
              ),
            ),
            AnimatedCrossFade(
                firstChild: Container(
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: SingleChildScrollView(
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var currBuilding
                                        in _buildingsRu.entries)
                                      _makeButton(
                                          text: currBuilding.value,
                                          f: () {
                                            if (_selectedKey !=
                                                currBuilding.key) {
                                              setState(() {
                                                _selectedKey = currBuilding.key;
                                              });
                                              MapController.getMapsByBuilding(
                                                      _selectedKey)
                                                  .then((value) {
                                                setState(() {
                                                  _maps = value;
                                                });
                                                if (_maps != null) {
                                                  int minLayer = _maps!
                                                      .reduce((value,
                                                              element) =>
                                                          element.buildingLevel <
                                                                  value
                                                                      .buildingLevel
                                                              ? element
                                                              : value)
                                                      .buildingLevel;
                                                  setState(() {
                                                    _selectedLayer = minLayer;
                                                  });
                                                  String? newUrl = getImageUrl(
                                                      _maps,
                                                      _selectedKey,
                                                      minLayer);
                                                  setState(() {
                                                    _currUrl = newUrl;
                                                  });
                                                  // print("$maps, $selectedKey, $selectedLayer, $newUrl");
                                                }
                                              }).catchError((error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Ошибка загрузки данных: $error'),
                                                  ),
                                                );
                                              });
                                              String? newUrl = getImageUrl(
                                                  _maps,
                                                  _selectedKey,
                                                  _selectedLayer);
                                              setState(() {
                                                _currUrl = newUrl;
                                              });
                                              _resetChildKey();
                                            }
                                          },
                                          paddingLeft: 40,
                                          paddingRight: 40),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                  ])))),
                ),
                secondChild: Container(),
                crossFadeState: _isListOpen
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300)),
          ],
        ),
      ],
    );
  }
}
