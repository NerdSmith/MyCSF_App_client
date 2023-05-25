import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool _isListOpen = false;

  Widget _makeButton(
      {required String text,
      required Function f,
      double paddingLeft = 0,
      double paddingRight = 0}) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: paddingLeft, right: paddingRight, bottom: 25),
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
                            const EdgeInsets.only(left: 20, right: 40, top: 10),
                        child: _makeButton(
                            text: '11111',
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
        if (_isListOpen)
        Container(
          constraints: BoxConstraints(
            maxHeight: 300,
          ),
          child: SingleChildScrollView(
              child: Center(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 40, top: 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _makeButton(text: '1', f: () {}, paddingLeft: 40, paddingRight: 40),
                            _makeButton(text: '2', f: () {}, paddingLeft: 40, paddingRight: 40),

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
                    child: Image.asset(
                      "assets/example.png",
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Button onPressed action
                    },
                    child: Text('Button'),
                  ),
                ),
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
