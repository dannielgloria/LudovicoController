import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rxdart/rxdart.dart';

import 'app_style.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;

  late BehaviorSubject<int> willAcceptStream;

  Color background = AppColors.lightBackground;
  Color text = AppColors.lightText;
  Color select = AppColors.lightSelect;
  Color icon = AppColors.lightIcon;
  Color buttonBackground = AppColors.lightButtonBackground;
  Color iconButton = AppColors.lightIconButton;
  Icon darkMode = AppColors.lightDarkMode;
  AssetImage uamLogo = AppColors.lightUAM;

  int? _deviceState;

  bool isDisconnecting = false;

  Map<String, Color>? colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green.shade700,
    'offTextColor': Colors.red.shade700,
    'neutralTextColor': Colors.blue,
  };

  bool get isConnected => connection != null && connection!.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  Future<bool> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: ' Habilitar Bluetooth',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: text,
                      fontSize: 20,
                    ),
                  ),
                ),
                Switch(
                  value: _bluetoothState.isEnabled,
                  onChanged: (bool value) {
                    future() async {
                      if (value) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }

                      await getPairedDevices();
                      _isButtonUnavailable = false;

                      if (_connected) {
                        _disconnect();
                      }
                    }

                    future().then((_) {
                      setState(() {});
                    });
                  },
                ),
                const Spacer(),
                const Icon(Icons.bluetooth_searching),
                RichText(
                  text: const TextSpan(text: ' '),
                ),
                DropdownButton(
                  items: _getDeviceItems(),
                  onChanged: (value) =>
                      setState(() => _device = value as BluetoothDevice),
                  value: _devicesList.isNotEmpty ? _device : null,
                ),
                ElevatedButton(
                  onPressed: _isButtonUnavailable
                      ? null
                      : _connected
                          ? _disconnect
                          : _connect,
                  child: Text(_connected ? 'Desconectar' : 'Conectar'),
                  style: ElevatedButton.styleFrom(
                      primary: buttonBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: iconButton,
                        fontSize: 20,
                      )),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text(
          'Dispositivos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name as String),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection!.close();
    // show('Dispositivo desconectado');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      // show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        // show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }
}
