import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:video_callapp/HomePage.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Call',
      home: HomePage(),
    );
  }
}

final String userID = Random().nextInt(900000 + 10000).toString();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveIdController = TextEditingController(
        text: Random().nextInt(900000 + 100000).toString());

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 100, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/background.png'),
              SizedBox(
                height: 5,
              ),
              Text(
                'User ID : $userID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: liveIdController,
                decoration: InputDecoration(
                  labelText: 'Join or Start a Live by Input an Id',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  BounceToLivePage(context,
                      liveId: liveIdController.text, isHost: true);
                },
                child: Text(
                  'Start a Live',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  BounceToLivePage(context,
                      liveId: liveIdController.text, isHost: false);
                },
                child: Text(
                  'Join a Live',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  BounceToLivePage(BuildContext context,
      {required String liveId, required bool isHost}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LivePage(liveID: liveId, isHost: isHost)));
  }
}

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  LivePage({super.key, required this.liveID, this.isHost = false});
  final int appId = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltLiveStreaming(
      appID: appId,
      appSign: appSign,
      userID: userID,
      userName: 'user_$userID',
      liveID: liveID,
      config: isHost
          ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
          : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
    ));
  }
}
