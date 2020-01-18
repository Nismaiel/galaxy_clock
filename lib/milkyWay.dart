import 'dart:async';
import 'dart:math';
import 'dart:math' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationControllerHrs;
  AnimationController animationControllerMin;
  AnimationController animationControllerSec;

  AnimationController rotationHrController;
  AnimationController rotationMinController;
  AnimationController rotationSecController;
  AnimationController meteorController;

  Animation<double> meteor;
  Animation<double> animationSecTxt;
  Animation<double> animationMinText;
  Animation<double> animationHrText;

  String _timeString;
  String _minString;
  String _hrsString;
  String _secString;

  int currentHrFormat;
  int currentHr;
  int currentMin;
  int currentSec;
  var currentSecFormat;

  bool am;

  @override
  void initState() {
    super.initState();

    //========Getting Time Strings to position the planets=======================

    currentHrFormat = TimeOfDay.now().hour;
    if (currentHrFormat > 12) {
      setState(() {
        currentHr = currentHrFormat - 12;
        am = false;
      });
    } else {
      setState(() {
        currentHr = currentHrFormat;
        am = true;
      });
    }

    currentMin = TimeOfDay.now().minute;

    DateTime now = DateTime.now();
    currentSecFormat = DateFormat('ss').format(now);
    currentSec = int.parse(currentSecFormat);
    assert(currentSec is int);

    //===============Animation Controllers Settings=================

    animationControllerHrs =
    new AnimationController(vsync: this, duration: Duration(hours: 12));
    animationControllerHrs.forward(
        from: 0 + (((1 / 12) * currentHr) + (((1 / 12) / 60) * currentMin)))
      ..whenCompleteOrCancel(() {
        animationControllerHrs.repeat(
            min: 0, max: 1, period: Duration(hours: 12));
      });

    animationControllerMin =
    new AnimationController(vsync: this, duration: Duration(minutes: 60));
    animationControllerMin.forward(from: 0 + ((1 / 60) * currentMin))
      ..whenCompleteOrCancel(() {
        animationControllerMin.repeat(
            min: 0, max: 1, period: Duration(minutes: 60));
      });

    animationControllerSec =
    new AnimationController(vsync: this, duration: Duration(seconds: 60));

    animationControllerSec.forward(
      from: 0 + ((1 / 60) * currentSec),
    )..whenCompleteOrCancel(() {
      animationControllerSec.repeat(
          min: 0, max: 1, period: Duration(seconds: 60));
    });

    //===============Time String Rotation Settings==========================

    rotationHrController =
        AnimationController(vsync: this, duration: Duration(hours: 24));
    animationHrText = Tween<double>(
        begin: ((2 * pi) -
            ((((1 / 12) * currentHr) + ((1 / 12) / 60 * currentMin)) *
                (pi * 2))),
        end: (-2 * pi) -
            ((((1 / 12) * currentHr) + ((1 / 12) / 60 * currentMin)) *
                (pi * 2)))
        .animate(rotationHrController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationHrController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          rotationHrController.repeat();
        }
      });
    rotationHrController.forward();

    rotationMinController =
        AnimationController(vsync: this, duration: Duration(minutes: 120));
    animationMinText = Tween<double>(
        begin: (2 * pi) - ((1 / 60) * currentMin * (pi * 2)),
        end: (-2 * pi) - ((1 / 60) * currentMin * 2 * pi))
        .animate(rotationMinController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationMinController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          rotationMinController.repeat();
        }
      });
    rotationMinController.forward();

    rotationSecController =
        AnimationController(duration: Duration(seconds: 120), vsync: this);
    animationSecTxt = Tween<double>(
        begin: (2 * pi) - ((1 / 60) * currentSec * 2 * pi),
        end: (-2 * pi) - ((1 / 60) * currentSec * 2 * pi))
        .animate(rotationSecController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationSecController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          rotationSecController.repeat();
        }
      });
    rotationSecController.forward();

    //==============================Meteors===========================

    meteorController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 8));
    Tween tween = new Tween<double>(begin: -200.0, end: 1500.0);
    meteor = tween.animate(meteorController);
    meteor.addListener(() {
      setState(() {});
    });
    meteorController.forward();

    //===============================Time Settings===================

    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    _hrsString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getHrs());

    _minString = _formatMin(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getMin());

    _secString = _formatMin(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getSec());
  }

//====================Time Format===============

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  String _formatHrs(DateTime dateTime) {
    return DateFormat('hh').format(dateTime);
  }

  String _formatMin(DateTime dateTime) {
    return DateFormat('mm').format(dateTime);
  }

  String _formatSec(DateTime dateTime) {
    return DateFormat('ss').format(dateTime);
  }

  //==========================Time String Getters====================

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  void _getHrs() {
    final DateTime now = DateTime.now();
    final String formattedHrs = _formatHrs(now);
    setState(() {
      _hrsString = formattedHrs;
    });
  }

  void _getMin() {
    final DateTime now = DateTime.now();
    final String formattedMin = _formatMin(now);
    setState(() {
      _minString = formattedMin;
    });
  }

  void _getSec() {
    final DateTime now = DateTime.now();
    final String formattedSec = _formatSec(now);
    setState(() {
      _secString = formattedSec;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      primary: isLandscape,
      body: AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/milkyway.jpeg',
                    fit: BoxFit.cover,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                        left: meteor.value,
                        top: meteor.value / 2,
                        child: Image.asset(
                          'assets/meteor.png',
                          width: 50,
                        )),
                    Positioned(
                        left: meteor.value,
                        top: meteor.value / 2.2 + 15,
                        child: Image.asset(
                          'assets/meteor.png',
                          width: 50,
                        )),
                    Positioned(
                        left: meteor.value,
                        top: meteor.value / 2.3 + 30,
                        child: Image.asset(
                          'assets/meteor.png',
                          width: 50,
                        )),
                    Positioned(
                        left: meteor.value / 1.2,
                        top: meteor.value / 2.4 + 45,
                        child: Image.asset(
                          'assets/meteor.png',
                          width: 50,
                        )),
                    Positioned(
                        left: meteor.value / 1.1,
                        top: meteor.value / 2.5 + 60,
                        child: Image.asset(
                          'assets/meteor.png',
                          width: 50,
                        )),
                    Positioned(
                        top: MediaQuery.of(context).size.height / 5,
                        left: MediaQuery.of(context).size.width / 2,
                        child: Image.asset(
                          am ? 'assets/realsun.png' : 'assets/Clip.png',
                          width: MediaQuery.of(context).size.width / 14,
                        )),
                    Center(
                      child: Image.asset(
                        'assets/globe.png',
                        width: MediaQuery.of(context).size.width / 8,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 3.7,
                      left: MediaQuery.of(context).size.width / 2.21,
                      child: Text(
                        _timeString,
                        style: TextStyle(
                            fontFamily: 'Graduate',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width / 40,
                  left: MediaQuery.of(context).size.width / 2.16,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            RotationTransition(
                              turns: animationControllerHrs,
                              alignment: FractionalOffset(
                                  MediaQuery.of(context).size.height / 4500,
                                  MediaQuery.of(context).size.width / 205),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          14,
                                      child: Image.asset('assets/red.png')),
                                  Positioned(
                                    top: MediaQuery.of(context).size.width / 70,
                                    left:
                                    MediaQuery.of(context).size.width / 80,
                                    child: Transform.rotate(
                                      angle: animationHrText.value,
                                      alignment: Alignment.center,
                                      child: Text(
                                        _hrsString,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Graduate',
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.width / 9.5,
                    left: MediaQuery.of(context).size.width / 2.14,
                    child: RotationTransition(
                      turns: animationControllerMin,
                      alignment: FractionalOffset(
                          MediaQuery.of(context).size.width / 4000,
                          MediaQuery.of(context).size.width / 250),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 16,
                            child: Image.asset('assets/venus.png'),
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.width / 65,
                              left: MediaQuery.of(context).size.width / 90,
                              child: Transform.rotate(
                                angle: animationMinText.value,
                                alignment: Alignment.center,
                                child: Container(
                                  child: Text(
                                    _minString,
                                    style: TextStyle(
                                        fontFamily: 'Graduate',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    )),
                Positioned(
                    top: MediaQuery.of(context).size.width / 5.8,
                    left: MediaQuery.of(context).size.width / 2.14,
                    child: RotationTransition(
                      turns: animationControllerSec,
                      alignment: FractionalOffset(
                          MediaQuery.of(context).size.height / 2500,
                          MediaQuery.of(context).size.width / 350),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 18,
                            child: Image.asset('assets/mercury.png'),
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.width / 70,
                              left: MediaQuery.of(context).size.width / 80,
                              child: Transform.rotate(
                                angle: animationSecTxt.value,
                                alignment: Alignment.center,
                                child: Text(
                                  _secString,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Graduate',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
