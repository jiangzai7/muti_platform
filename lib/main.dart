import 'dart:io';

import 'package:contextmenu/contextmenu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            kIsWeb
                ? ColorScheme.fromSeed(seedColor: Colors.yellowAccent)
                : Platform.isMacOS
                ? ColorScheme.fromSeed(seedColor: Colors.tealAccent)
                : ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
          kIsWeb
              ? MyHomePage(title: 'Flutter Demo Home Page')
              : Platform.isMacOS
              ? MyMacosPage(title: "Flutter MacOS")
              : MyHomePage(title: 'Flutter Demo Home Page'),
      // 配置菜单栏
      shortcuts: {
        // 添加快捷键
        LogicalKeySet(LogicalKeyboardKey.keyA, LogicalKeyboardKey.control):
            const ActivateIntent(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isShowLabel = true;
  String _selectedCity = "北京";
  var dateController = TextEditingController(
    text:
        "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
  );

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment:
              kIsWeb
                  ? MainAxisAlignment.end
                  : Platform.isMacOS
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
          children: <Widget>[
            if (kIsWeb) ...[
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '选择城市',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCity,
                items:
                    ['北京', '上海', '广州', '深圳']
                        .map(
                          (city) =>
                              DropdownMenuItem(value: city, child: Text(city)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _selectedCity = value ?? "");
                },
              ),
              // 日期选择器
              TextFormField(
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                  labelText: '选择日期',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    // 处理选择的日期
                    setState(() {
                      dateController.text =
                          "${date.year}/${date.month}/${date.day}";
                    });
                  }
                },
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "这是我的第一个flutter web页面，请您欣赏！\n${dateController.text}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  margin: EdgeInsets.all(5),
                  child: Image.asset("assets/images/work_bg_251.png"),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isShowLabel = !isShowLabel;
                  });
                },
                backgroundColor: Colors.transparent,
                tooltip: isShowLabel ? "隐藏" : "显示",
                child: Image.asset(
                  "assets/images/icon_status_working.png",
                  height: 44,
                  width: 44,
                ),
              ),
            ],

            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (kIsWeb)
              Text(isShowLabel ? 'Web' : "")
            else if (Platform.isMacOS)
              const Text('Macos'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            kIsWeb
                ? Colors.yellow
                : Platform.isMacOS
                ? Colors.red
                : Colors.blue,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyMacosPage extends StatefulWidget {
  const MyMacosPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyMacosPage> createState() => _MyMacosPageState();
}

class _MyMacosPageState extends State<MyMacosPage> {
  int _selectedIndex = 0;
  bool isContained1 = false;
  bool isContained2 = false;
  bool isContained3 = false;
  bool isInHead = false;
  bool isShowLabel = true;
  bool isMouseOnSend = false;
  String _selectedCity = "北京";
  Map<String, Object> chatSelected = {
    "name": "",
    "time": "",
    "message": [""],
  };
  List chats = [
    {
      "name": "lucy",
      "time": "2025/10/24",
      "message": ["1", "2", "3"],
    },
    {
      "name": "lily",
      "time": "2025/10/24",
      "message": ["a", "2g", "3fd"],
    },
    {
      "name": "tom",
      "time": "2025/10/23",
      "message": ["1dfd", "2dfdfd", "32ef"],
    },
    {
      "name": "bluce",
      "time": "2025/10/22",
      "message": ["1", "dfdfdf2", "3"],
    },
  ];
  var inputTextController = TextEditingController();

  var dateController = TextEditingController(
    text:
        "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
  );

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _counter++;
    });
  }

  _sendMessage(String s) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            // title: Text('确认'),
            content: Text('确定要发送吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  // _deleteItem();
                  (chatSelected["message"] as List<String>).add(s);
                  setState(() {});
                  Navigator.pop(context);
                  inputTextController.text = "";
                },
                child: Text('确定'),
              ),
            ],
          ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'app',
          menus: [
            PlatformMenuItem(
              label: '关于 MyApp',
              onSelected: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'MyApp',
                  applicationVersion: '1.0.0',
                );
              },
            ),
            PlatformMenuItemGroup(
              members: [
                PlatformMenuItem(
                  label: '退出',
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyQ,
                    meta: true,
                  ),
                  onSelected: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ],
        ),
        PlatformMenu(
          label: '文件',
          menus: [
            PlatformMenuItem(
              label: '新建',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyN,
                meta: true,
              ),
              onSelected: () {
                _showMessage(context, '新建文件');
              },
            ),
            PlatformMenuItem(
              label: '打开',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyO,
                meta: true,
              ),
              onSelected: () {
                _showMessage(context, '打开文件');
              },
            ),
          ],
        ),
        PlatformMenu(
          label: '编辑',
          menus: [
            PlatformMenuItem(
              label: '撤销',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
              ),
              onSelected: () {
                _showMessage(context, '撤销操作');
              },
            ),
            PlatformMenuItem(
              label: '重做',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
                shift: true,
              ),
              onSelected: () {
                _showMessage(context, '重做操作');
              },
            ),
          ],
        ),
      ],
      child: Scaffold(
        // appBar: AppBar(
        //   // TRY THIS: Try changing the color here to a specific color (to
        //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        //   // change color while the other colors stay the same.
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text(widget.title),
        // ),
        body: Row(
          children: [
            Container(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 40),
                      MouseRegion(
                        // cursor: SystemMouseCursors.click,
                        onEnter: (event) {
                          setState(() {
                            isInHead = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isInHead = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: isInHead ? 80 : 50,
                          height: isInHead ? 80 : 50,
                          child: Image.asset(
                            "assets/images/head.png",
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: MouseRegion(
                          // cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              isContained1 = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              isContained1 = false;
                            });
                          },
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    isContained1
                                        ? Colors.grey.withAlpha(100)
                                        : Colors.grey.withAlpha(40),
                              ),
                              child: Text(
                                "消息",
                                style: TextStyle(
                                  color:
                                      isContained1
                                          ? Colors.black
                                          : Colors.black.withAlpha(120),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: MouseRegion(
                          // cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              isContained2 = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              isContained2 = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  isContained2
                                      ? Colors.grey.withAlpha(100)
                                      : Colors.grey.withAlpha(40),
                            ),
                            child: Text(
                              "邮件",
                              style: TextStyle(
                                color:
                                    isContained2
                                        ? Colors.black
                                        : Colors.black.withAlpha(120),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        child: MouseRegion(
                          // cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              isContained3 = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              isContained3 = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  isContained3
                                      ? Colors.grey.withAlpha(100)
                                      : Colors.grey.withAlpha(40),
                            ),
                            child: Text(
                              "文档",
                              style: TextStyle(
                                color:
                                    isContained3
                                        ? Colors.black
                                        : Colors.black.withAlpha(120),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                ],
              ),
            ),
            firstLevelPage(),
            // Expanded(flex: 5, child: Container(color: Colors.blue)),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              kIsWeb
                  ? Colors.yellow
                  : Platform.isMacOS
                  ? Colors.tealAccent
                  : Colors.blue,
          onPressed: _incrementCounter,
          tooltip: 'Add Friend',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget firstLevelPage() {
    switch (_selectedIndex) {
      case 1:
        return Expanded(
          child: Container(
            color: Colors.green,
            // // child: Expanded(
            // child: Row(
            //   children: [
            //     // Column(children: [
            //     Container(
            //       width: 200,
            //       color: Colors.orange,
            //       child: ListView.builder(
            //         itemCount: 15,
            //         itemBuilder: (context, index) {
            //           return Container(
            //             width: 200,
            //             height: 30,
            //             child: Text("item$index"),
            //           );
            //         },
            //       ),
            //     ),
            //     SizedBox(width: 3),
            //     // Expanded(child: Container(color: Colors.yellow)),
            //     Container(width: double.infinity, color: Colors.brown),
            //     // ]),
            //   ],
            // ),
            // // ),
          ),
        );
      case 0:
        return Expanded(
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 150,
                    // color: Colors.blue,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    width: 40,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  // color: Colors.purple,
                                  width: 30,
                                  height: 30,
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          );
                        } else {
                          Map<String, Object> chat = chats[index - 1];
                          String name = chat["name"] as String;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                chatSelected = chat;
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              height: 40,
                              color: Colors.white,
                              child: Text(name),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          color: Colors.grey.withAlpha(20),
                        );
                      },
                      itemCount: chats.length + 1,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey.withAlpha(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              color: Colors.grey.withAlpha(80),
                              height: 40,
                              child: Text(chatSelected["name"] as String),
                            ),
                            ...(chatSelected["message"] as List<String>).map(
                              (s) => ContextMenuArea(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber.withAlpha(90),
                                  ),
                                  child: Text(s),
                                ),
                                width: 60,
                                verticalPadding: 14,
                                builder: (context) {
                                  return [
                                    GestureDetector(
                                      onTap: () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: s),
                                        );
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text('复制成功')),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text('复制'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        (chatSelected["message"]
                                                as List<String>)
                                            .remove(s);
                                        setState(() {});
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('删除成功'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text('删除'),
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // // 拖拽支持
                            // DragTarget<String>(
                            //   onAcceptWithDetails: (data) {
                            //     print('拖拽数据: $data');
                            //   },
                            //   builder: (context, candidateData, rejectedData) {
                            //     return Container(
                            //       padding: EdgeInsets.all(20),
                            //       color:
                            //           candidateData.isNotEmpty
                            //               ? Colors.blue[100]
                            //               : Colors.grey[200],
                            //       child: Text('拖拽到这里'),
                            //     );
                            //   },
                            // ),
                            ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  print(file.uri);
                                  // 处理文件
                                }
                              },
                              child: Text('选择文件'),
                            ),
                            Container(
                              // alignment: Alignment.center,
                              color: Colors.white,
                              height: 100,
                              child: TextField(
                                controller: inputTextController,
                                cursorColor: Colors.black,
                                cursorWidth: 0.5,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: "请输入要发送的消息",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withAlpha(50),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Shortcuts(
                              shortcuts: {
                                LogicalKeySet(
                                      LogicalKeyboardKey.control,
                                      LogicalKeyboardKey.shift,
                                      LogicalKeyboardKey.keyS,
                                    ):
                                    SendIntent(),
                              },
                              child: Actions(
                                actions: {
                                  SendIntent: CallbackAction(
                                    onInvoke: (intent) {
                                      print('Send Action triggered');
                                      _sendMessage(inputTextController.text);
                                    },
                                  ),
                                },
                                child: Focus(
                                  autofocus: true,
                                  child: Container(
                                    // alignment: Alignment.center,
                                    color: Colors.white,
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Expanded(child: SizedBox()),
                                        GestureDetector(
                                          onTap: () {
                                            _sendMessage(
                                              inputTextController.text,
                                            );
                                          },
                                          child: MouseRegion(
                                            onEnter:
                                                (_) => setState(
                                                  () => isMouseOnSend = true,
                                                ),
                                            onExit:
                                                (_) => setState(
                                                  () => isMouseOnSend = false,
                                                ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 30,
                                                vertical: 10,
                                              ),
                                              color:
                                                  isMouseOnSend
                                                      ? Colors.green.withAlpha(
                                                        40,
                                                      )
                                                      : Colors.transparent,

                                              child: Text(
                                                '发送',
                                                style: TextStyle(
                                                  color:
                                                      isMouseOnSend
                                                          ? Colors.green
                                                          : Colors.grey
                                                              .withAlpha(80),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 20),
                                      ],
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
              ],
            ),
          ),
        );
      case 2:
        return Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                DataTable(
                  columns: [
                    DataColumn(label: Text('姓名')),
                    DataColumn(label: Text('年龄')),
                    DataColumn(label: Text('城市')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('张三')),
                        DataCell(Text('25')),
                        DataCell(Text('北京')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('李四')),
                        DataCell(Text('30')),
                        DataCell(Text('上海')),
                      ],
                    ),
                  ],
                ),
                // // 分页控件
                // PaginatedDataTable(
                //   header: Text('用户列表'),
                //   columns: [
                //     DataColumn(label: Text('ID')),
                //     DataColumn(label: Text('姓名')),
                //   ],
                //   source: _dataSource,
                // ),
                Container(
                  height: 500,
                  width: double.infinity,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        // color: Colors.red,
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("lily"), Text("50"), Text("北京")],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: 0.5,
                      );
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container(color: Colors.yellow);
    }
  }
}

class SendIntent extends Intent {
  const SendIntent();
}
