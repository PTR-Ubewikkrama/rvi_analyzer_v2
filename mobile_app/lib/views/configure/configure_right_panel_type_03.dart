import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvi_analyzer/providers/device_state_provider.dart';
import 'package:rvi_analyzer/service/flutter_blue_service_impl.dart';
import 'package:rvi_analyzer/views/common/form_eliments/text_input.dart';
import 'package:rvi_analyzer/views/common/graph.dart';
import 'package:rvi_analyzer/views/common/test_line.dart';

class ConfigureRightPanelType03 extends ConsumerStatefulWidget {
  final ScanResult sc;
  final GlobalKey<FormState> keyForm;
  final void Function() updateStarted;
  final void Function() updateTestId;
  final TextEditingController customerNameController;
  final TextEditingController batchNoController;
  final TextEditingController operatorIdController;
  final TextEditingController sessionIdController;
  final TextEditingController testIdController;
  final TextEditingController dateController;
  const ConfigureRightPanelType03(
      {Key? key,
      required this.sc,
      required this.keyForm,
      required this.updateStarted,
      required this.updateTestId,
      required this.customerNameController,
      required this.batchNoController,
      required this.operatorIdController,
      required this.sessionIdController,
      required this.testIdController,
      required this.dateController})
      : super(key: key);

  @override
  ConsumerState<ConfigureRightPanelType03> createState() =>
      _ConfigureRightPanelType03State();
}

class _ConfigureRightPanelType03State
    extends ConsumerState<ConfigureRightPanelType03> {
  Blue blue = Blue();
  final _formKey = GlobalKey<FormState>();
  final startingVoltageController = TextEditingController();
  final desiredVoltageController = TextEditingController();
  final maxCurrentController = TextEditingController();
  final voltageResolutionController = TextEditingController();
  final changeInTimeController = TextEditingController();

  bool started = false;
  bool saveClicked = false;
  bool passed = false;
  bool isNotInitial = false;

  // voltage vs current graph

  double xMin = 0.0;
  double xMax = 0.0;
  double yMin = 0.0;
  double yMax = 0.0;
  double xInterval = 1;
  double yInterval = 1;
  List<FlSpot> spotData = [];
  double lastCurrent = 0.0;
  double lastVoltage = 0.0;

  void setGraphValues() {
    if (started) {
      if (ref
              .watch(
                  ref.watch(deviceDataMap[widget.sc.device.name]!).streamData)
              .state ==
          6) {
        setState(() {
          started = false;
        });
      } else {
        if (ref
                .watch(
                    ref.watch(deviceDataMap[widget.sc.device.name]!).streamData)
                .currentProtocol ==
            3) {
          double currentReadingVoltage = ref
              .read(ref.read(deviceDataMap[widget.sc.device.name]!).streamData)
              .voltage;
          double currentReadingCurrent = ref
              .read(ref.read(deviceDataMap[widget.sc.device.name]!).streamData)
              .current;

          //Update when x axis value groth
          if (xMax < currentReadingVoltage) {
            if (yMax < currentReadingCurrent) {
              List<FlSpot> tempSpotData = spotData;
              for (var i = 0; i < tempSpotData.length; i++) {
                FlSpot item = tempSpotData[i];
                tempSpotData[i] = FlSpot(item.x * 2, item.x * 2);
              }
              tempSpotData
                  .add(FlSpot(currentReadingVoltage, currentReadingCurrent));
              setState(() {
                spotData = tempSpotData;
                xMax = xMax * 2;
                yMax = yMax * 2;
                xInterval = xInterval * 2;
                yInterval = yInterval * 2;
              });
            } else {
              List<FlSpot> tempSpotData = spotData;
              for (var i = 0; i < tempSpotData.length; i++) {
                FlSpot item = tempSpotData[i];
                tempSpotData[i] = FlSpot(item.x, item.x * 2);
              }
              tempSpotData
                  .add(FlSpot(currentReadingVoltage, currentReadingCurrent));
              setState(() {
                spotData = tempSpotData;
                xMax = xMax * 2;
                xInterval = xInterval * 2;
              });
            }
          } else {
            if (yMax < currentReadingCurrent) {
              List<FlSpot> tempSpotData = spotData;
              for (var i = 0; i < tempSpotData.length; i++) {
                FlSpot item = tempSpotData[i];
                tempSpotData[i] = FlSpot(item.x * 2, item.x);
              }
              tempSpotData
                  .add(FlSpot(currentReadingVoltage, currentReadingCurrent));
              setState(() {
                spotData = tempSpotData;
                yMax = yMax * 2;
                yInterval = yInterval * 2;
              });
            } else {
              setState(() {
                spotData
                    .add(FlSpot(currentReadingVoltage, currentReadingCurrent));
              });
            }
          }
        }
      }
    }
  }

  void saveModeOne() {
    widget.updateTestId();
  }

  Widget getScrollView() {
    print("CCCCCCCCCCCCC");

    return Form(
      key: _formKey,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextInput(
                    data: TestInputData(
                        inputType: TextInputType.number,
                        controller: startingVoltageController,
                        validatorFun: (val) {
                          if (val!.isEmpty) {
                            return "Starting voltage cannot be empty";
                          } else if (!RegExp(r"^(?=\D*(?:\d\D*){1,12}$)")
                              .hasMatch(val)) {
                            return "Only allowed numbers";
                          } else if (!RegExp(
                                  r"^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1})?$")
                              .hasMatch(val)) {
                            return "Starting voltage ONLY allowed one Place Value";
                          } else {
                            null;
                          }
                        },
                        labelText: 'Starting voltage (V)',
                        enabled: !started)),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: TextInput(
                    data: TestInputData(
                        inputType: TextInputType.number,
                        controller: desiredVoltageController,
                        validatorFun: (val) {
                          if (val!.isEmpty) {
                            return "Desired Voltage cannot be empty";
                          } else if (!RegExp(r"^(?=\D*(?:\d\D*){1,12}$)")
                              .hasMatch(val)) {
                            return "Only allowed numbers";
                          } else if (!RegExp(
                                  r"^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1})?$")
                              .hasMatch(val)) {
                            return "Desired Voltage ONLY allowed one Place Value";
                          } else {
                            null;
                          }
                        },
                        labelText: 'Desired Voltage (V)',
                        enabled: !started)),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextInput(
                    data: TestInputData(
                        inputType: TextInputType.number,
                        controller: maxCurrentController,
                        validatorFun: (val) {
                          if (val!.isEmpty) {
                            return "Max Current cannot be empty";
                          } else if (!RegExp(r"^(?=\D*(?:\d\D*){1,12}$)")
                              .hasMatch(val)) {
                            return "Only allowed numbers";
                          } else if (!RegExp(
                                  r"^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1,2})?$")
                              .hasMatch(val)) {
                            return "Max Current ONLY allowed two Place Value";
                          } else {
                            null;
                          }
                        },
                        labelText: 'Max Current (A)',
                        enabled: !started)),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextInput(
                    data: TestInputData(
                        controller: voltageResolutionController,
                        inputType: TextInputType.number,
                        validatorFun: (val) {
                          if (val!.isEmpty) {
                            return "Voltage resolution cannot be empty";
                          } else if (!RegExp(r"^(?=\D*(?:\d\D*){1,12}$)")
                              .hasMatch(val)) {
                            return "Only allowed numbers";
                          } else if (!RegExp(
                                  r"^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1})?$")
                              .hasMatch(val)) {
                            return "Voltage resolution ONLY allowed one Place Value";
                          } else {
                            null;
                          }
                        },
                        labelText: 'Voltage resolution',
                        enabled: !started)),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: TextInput(
                    data: TestInputData(
                        inputType: TextInputType.number,
                        controller: changeInTimeController,
                        validatorFun: (val) {
                          if (val!.isEmpty) {
                            return "Change in time cannot be empty";
                          } else if (!RegExp(r"^(?=\D*(?:\d\D*){1,6}$)")
                              .hasMatch(val)) {
                            return "Only allowed numbers";
                          } else {
                            null;
                          }
                        },
                        labelText: 'Change in time (Sec)',
                        enabled: !started)),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          started
              ? Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: LineChartSample2(
                          data: LineChartDataCustom(
                              xAxisName: "Voltage",
                              spotData: spotData,
                              xMax: xMax,
                              xMin: xMin,
                              yAxisName: "Current",
                              yMax: yMax,
                              yMin: yMin,
                              xInterval: xInterval,
                              yInterval: yInterval),
                        )),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 10,
          ),
          // started
          //     ? Row(
          //         children: [
          //           Expanded(
          //               flex: 1,
          //               child: LineChartScreen(
          //                 horizontalAxisName: "Temperature",
          //                 horizontalAxisStep: 5,
          //                 values: [],
          //                 verticalAxisName: "Voltage",
          //                 verticalAxisStep:
          //                     double.parse(voltageResolutionController.text),
          //               )),
          //         ],
          //       )
          //     : const SizedBox.shrink(),
          started
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 55,
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          disabledColor: Colors.grey,
                          color: Colors.orange,
                          onPressed: () {
                            blue.stop(widget.sc.device);
                            widget.updateStarted();
                            setState(() {
                              started = !started;
                            });
                          },
                          child: const Text(
                            'Stop',
                            style: TextStyle(
                                color: Color.fromARGB(255, 231, 230, 230),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 55,
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          disabledColor: Colors.grey,
                          color: Colors.green,
                          onPressed: () {
                            saveModeOne();
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                color: Color.fromARGB(255, 231, 230, 230),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 55,
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          disabledColor: Colors.grey,
                          color: Colors.cyan,
                          onPressed: () {
                            if (widget.keyForm.currentState!.validate() &&
                                _formKey.currentState!.validate()) {
                              startMode3();
                            }
                          },
                          child: const Text(
                            'Start',
                            style: TextStyle(
                                color: Color.fromARGB(255, 231, 230, 230),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  void startMode3() {
    double startingVoltage = double.parse(startingVoltageController.text);
    double pointSize = double.parse(voltageResolutionController.text);

    blue.runMode03(
        widget.sc.device,
        (startingVoltage * 10).toInt(),
        (double.parse(desiredVoltageController.text) * 10).toInt(),
        (double.parse(maxCurrentController.text) * 100).toInt(),
        (pointSize * 10).toInt(),
        (int.parse(changeInTimeController.text)));

    setState(() {
      yMax = double.parse(maxCurrentController.text);
      xMax = double.parse(desiredVoltageController.text);

      xInterval =
          double.parse(((xMax - startingVoltage) / 20).toStringAsFixed(2));

      yInterval = yMax / 10;
      xMin = startingVoltage;
      started = !started;
    });

    Timer.periodic(
        Duration(seconds: int.parse(changeInTimeController.text)),
        (Timer t) => {
              setGraphValues(),
              if (!started) {t.cancel()}
            });
    widget.updateStarted();
  }

  @override
  Widget build(BuildContext context) {
    print("DDDDDDDDDDDDD");

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SizedBox(
      width: isLandscape ? (width / 3) * 2 - 32 : width,
      child: SizedBox(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 0.5), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Mode 03",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        "[service data  : ${ref.watch(ref.watch(deviceDataMap[widget.sc.device.name]!).streamData).notifyData}]",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  getScrollView(),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
