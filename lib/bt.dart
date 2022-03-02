// For performing some operations asynchronously
// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// For using PlatformException
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'app_style.dart';
import 'main.dart';

class Bluetooth2 extends StatelessWidget {
  const Bluetooth2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Connection',
      home: Scaffold(
        body: BluetoothPage(),
      ),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  // User Interface
  Color background = AppColors.lightBackground;
  Color text = AppColors.lightSelect;
  Color select = AppColors.lightSelect;
  Color icon = AppColors.lightIcon;
  Color buttonBackground = AppColors.blueButtonBackground;
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

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection!.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
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
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
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

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Container(
        key: _scaffoldKey,
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        color: background,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
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
                            text: 'Conexión',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: text,
                              fontSize: 20,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Bluetooth',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                                  builder: (context) =>
                                      LudovicoControllerApp()),
                            );
                          },
                          child: Container(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: select,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.11,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Habilitar Bluetooth',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: text,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _bluetoothState.isEnabled,
                          onChanged: (bool value) {
                            future() async {
                              if (value) {
                                await FlutterBluetoothSerial.instance
                                    .requestEnable();
                              } else {
                                await FlutterBluetoothSerial.instance
                                    .requestDisable();
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
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  width: size.width,
                  height: size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'DISPOSITIVO EMPAREJADO',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: text,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Dispositivo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: text,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        DropdownButton(
                          items: _getDeviceItems(),
                          onChanged: (value) => setState(
                              () => _device = value as BluetoothDevice),
                          value: _devicesList.isNotEmpty ? _device : null,
                        ),
                        const Spacer(),
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
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: size.height * 0.1,
                  ),
                  width: size.width,
                  height: size.height * 0.15,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'NOTA: Si no puedes encontrar el dispositivo en la lista, empareje el dispositivo en a la configuración de bluetooth',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.red.shade400,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.11,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          FlutterBluetoothSerial.instance.openSettings();
                        },
                        child: const Text('Configuración de Bluetooth'),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NINGUNO'),
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

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('Ningún dispositivo seleccionado');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device!.address)
            .then((_connection) {
          print('Conectado al dispositivo');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print('¡Desconectando localmente!');
            } else {
              print('¡Desconectado remotamente!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('No se puede conectar, ocurrió una excepción');
          print(error);
        });
        show('Dispositivo conectado');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // void _onDataReceived(Uint8List data) {
  //   // Allocate buffer for parsed data
  //   int backspacesCounter = 0;
  //   data.forEach((byte) {
  //     if (byte == 8 || byte == 127) {
  //       backspacesCounter++;
  //     }
  //   });
  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
  //   int bufferIndex = buffer.length;

  //   // Apply backspace control character
  //   backspacesCounter = 0;
  //   for (int i = data.length - 1; i >= 0; i--) {
  //     if (data[i] == 8 || data[i] == 127) {
  //       backspacesCounter++;
  //     } else {
  //       if (backspacesCounter > 0) {
  //         backspacesCounter--;
  //       } else {
  //         buffer[--bufferIndex] = data[i];
  //       }
  //     }
  //   }
  // }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection!.close();
    show('Dispositivo desconectado');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    connection!.output.add(utf8.encode('A') as Uint8List);
    await connection!.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
    });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    connection!.output.add(utf8.encode('B') as Uint8List);
    await connection!.output.allSent;
    show('Dispositivo apagado');
    setState(() {
      _deviceState = -1; // device off
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState!.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
