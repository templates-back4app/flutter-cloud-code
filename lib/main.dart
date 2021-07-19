import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'YOUR_APP_ID_HERE';
  final keyClientKey = 'YOUR_CLIENT_KEY_HERE';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    title: 'Flutter - GeoPoint',
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void doCallCloudCodeHello() async {
    //Executes a cloud function with no parameters that returns a Map object
    final ParseCloudFunction function = ParseCloudFunction('hello');
    final ParseResponse parseResponse = await function.execute();
    if (parseResponse.success && parseResponse.result != null) {
      print(parseResponse.result);
    }
  }

  void doCallCloudCodeSumNumbers() async {
    //Executes a cloud function with parameters that returns a Map object
    final ParseCloudFunction function = ParseCloudFunction('sumNumbers');
    final Map<String, dynamic> params = <String, dynamic>{
      'number1': 10,
      'number2': 20
    };
    final ParseResponse parseResponse =
        await function.execute(parameters: params);
    if (parseResponse.success) {
      print(parseResponse.result);
    }
  }

  void doCallCloudCodeCreateToDo() async {
    //Executes a cloud function that returns a ParseObject type
    final ParseCloudFunction function = ParseCloudFunction('createToDo');
    final Map<String, dynamic> params = <String, dynamic>{
      'title': 'Task 1',
      'done': false
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      if (parseResponse.result['result'] is ParseObject) {
        //Transforms the return into a ParseObject
        final ParseObject parseObject = parseResponse.result['result'];
        print(parseObject.toString());
      }
    }
  }

  void doCallCloudCodeGetListTodo() async {
    //Executes a cloud function with parameters that returns a Map object
    final ParseCloudFunction function = ParseCloudFunction('getListToDo');
    final ParseResponse parseResponse = await function.execute();
    if (parseResponse.success) {
      if (parseResponse.result != null) {
        for (final todo in parseResponse.result) {
          //Use fromJson method to convert map in ParseObject
          print(ParseObject('ToDo').fromJson(todo));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            child: Image.network(
                'https://blog.back4app.com/wp-content/uploads/2017/11/logo-b4a-1-768x175-1.png'),
          ),
          Center(
            child: const Text('Flutter on Back4app - Call Clode Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doCallCloudCodeHello,
                child: Text('Cloud Code - Hello'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doCallCloudCodeSumNumbers,
                child: Text('Cloud Code - sumNumber'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doCallCloudCodeCreateToDo,
                child: Text('Cloud Code - createToDo'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doCallCloudCodeGetListTodo,
                child: Text('Cloud Code - getListToDo'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
        ],
      ),
    ));
  }
}
