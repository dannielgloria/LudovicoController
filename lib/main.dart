import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'app_style.dart';
import 'bluetooth.dart';
import 'bt.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  return runApp(LudovicoControllerApp());
}

class LudovicoControllerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludovico Controller',
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BehaviorSubject<int> willAcceptStream;

  Color background = AppColors.lightBackground;
  Color text = AppColors.lightText;
  Color select = AppColors.lightSelect;
  Color icon = AppColors.lightIcon;
  Color buttonBackground = AppColors.lightButtonBackground;
  Color iconButton = AppColors.lightIconButton;
  Icon darkMode = AppColors.lightDarkMode;
  AssetImage uamLogo = AppColors.lightUAM;

  @override
  void initState() {
    willAcceptStream = new BehaviorSubject<int>();
    willAcceptStream.add(0);
    super.initState();
  }

  void _fuctionDrag(String msg) {
    final snackBar = SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 500));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        color: background,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: size.width,
                  height: size.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Ludo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: text,
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'vico',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: text,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Bluetooth2()),
                            );
                          },
                          child: Container(
                            child: Icon(
                              Icons.settings_bluetooth,
                              color: select,
                              size: 28,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: select,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.11,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: size.height * 0.11,
                        height: size.height * 0.08,
                        child: const Icon(
                          Icons.battery_std_sharp,
                          color: Colors.transparent,
                          size: 38,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Dispensando Gel");
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          width: size.height * 0.11,
                          height: size.height * 0.11,
                          decoration: BoxDecoration(
                            color: buttonBackground,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.clean_hands_rounded,
                            color: Color(0xFF0077B6),
                            size: 38,
                          ),
                        ),
                      ),
                      Container(
                        width: size.height * 0.11,
                        height: size.height * 0.08,
                        child: const Icon(
                          Icons.battery_std_sharp,
                          color: Colors.transparent,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: size.width * 0.20,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                          color: buttonBackground,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              "Si",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: iconButton,
                                fontSize: 24,
                              ),
                            ),
                            Icon(
                              Icons.smart_toy_outlined,
                              color: text,
                              size: 38,
                            ),
                            Text(
                              "No",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: iconButton,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        width: size.width * 0.2,
                        height: size.width * 0.2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: uamLogo,
                        )),
                      ),
                      Container(
                        width: size.width * 0.20,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                          color: buttonBackground,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              "Der",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: iconButton,
                                fontSize: 24,
                              ),
                            ),
                            Icon(
                              Icons.precision_manufacturing_outlined,
                              color: text,
                              size: 38,
                            ),
                            Text(
                              "Izq",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: iconButton,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: icon,
                        size: 48,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.23,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      DragTarget(
                        builder: (context, list, list2) {
                          return Container(
                            padding: EdgeInsets.all(3),
                            width: size.width * 0.2,
                            height: size.width * 0.5,
                            child: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: icon,
                              size: 48,
                            ),
                          );
                        },
                        onWillAccept: (item) {
                          debugPrint('<================');
                          willAcceptStream.add(-50);
                          _fuctionDrag("<================");
                          return false;
                        },
                        onLeave: (item) {
                          debugPrint('RESET');
                          willAcceptStream.add(0);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        width: size.width * 0.5,
                        height: size.width * 0.5,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color(0xFF57A519),
                              Color(0xFF3D7311),
                              Color(0xFF81F224),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          width: size.width * 0.4,
                          height: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: background,
                            shape: BoxShape.circle,
                          ),
                          child: Draggable(
                            axis: Axis.horizontal,
                            feedback: StreamBuilder(
                              initialData: 0,
                              stream: willAcceptStream,
                              builder: (context, snapshot) {
                                return Container(
                                  width: size.width * 0.4,
                                  height: size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: (snapshot.data as num) > 0
                                        ? const Color(0xFFC24547)
                                        : (snapshot.data) == 0
                                            ? buttonBackground
                                            : const Color(0xFF1B94CA),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                            childWhenDragging: Container(),
                            child: Container(
                              width: size.width * 0.4,
                              height: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: buttonBackground,
                                shape: BoxShape.circle,
                              ),
                            ),
                            onDraggableCanceled: (v, f) => setState(
                              () {
                                willAcceptStream.add(0);
                              },
                            ),
                          ),
                        ),
                      ),
                      DragTarget(
                        builder: (context, list, list2) {
                          return Container(
                            padding: EdgeInsets.all(3),
                            width: size.width * 0.2,
                            height: size.width * 0.5,
                            child: Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: icon,
                              size: 48,
                            ),
                          );
                        },
                        onWillAccept: (item) {
                          debugPrint('================>');
                          willAcceptStream.add(50);
                          _fuctionDrag("================>");
                          return false;
                        },
                        onLeave: (item) {
                          debugPrint('RESET');
                          willAcceptStream.add(0);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: icon,
                        size: 48,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print("Start Pressed");
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: const Icon(
                              Icons.volume_up_rounded,
                              color: Color(0xFF57A519),
                              size: 35,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(
                                () {
                                  background =
                                      background == AppColors.darkBackground
                                          ? AppColors.lightBackground
                                          : AppColors.darkBackground;
                                  text = text == AppColors.darkext
                                      ? AppColors.lightText
                                      : AppColors.darkext;
                                  select = select == AppColors.darkSelect
                                      ? AppColors.lightSelect
                                      : AppColors.darkSelect;
                                  icon = icon == AppColors.darkIcon
                                      ? AppColors.lightIcon
                                      : AppColors.darkIcon;
                                  iconButton =
                                      iconButton == AppColors.darkIconButton
                                          ? AppColors.lightIconButton
                                          : AppColors.darkIconButton;
                                  buttonBackground = buttonBackground ==
                                          AppColors.darkButtonBackground
                                      ? AppColors.lightButtonBackground
                                      : AppColors.darkButtonBackground;
                                  darkMode = darkMode == AppColors.darkDarkMode
                                      ? AppColors.lightDarkMode
                                      : AppColors.darkDarkMode;
                                  uamLogo = uamLogo == AppColors.darkUAM
                                      ? AppColors.lightUAM
                                      : AppColors.darkUAM;
                                },
                              );
                              print("Power Pressed");
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: darkMode,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
