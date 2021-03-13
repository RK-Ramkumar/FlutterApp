import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:diya/models/speechModel.dart';
import 'package:diya/restIntegration/dnn.dart';

import 'package:url_launcher/url_launcher.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  final inputController = TextEditingController();

  final List<Facts> messageList = <Facts>[];
  final TextEditingController _textController = new TextEditingController();

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
     }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Available !!'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme
            .of(context)
            .primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child :
          FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          )

      ),
      body: Column(children: <Widget>[
                  Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true, //To keep the latest messages at the bottom
                  itemBuilder: (_, int index) => messageList[index],
                  itemCount: messageList.length,
                )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child:  TextField(
                      controller:   inputController,
                      decoration: InputDecoration(
                      suffixIcon: IconButton(
                            onPressed: (){
                              print('Manual Input');
                              String input = inputController.text;
                              _submitQuery(input);
                              inputController.text = "";
                            },
                            padding: const EdgeInsetsDirectional.only(end: 12.0),
                            icon: new Icon(Icons.send), // myIcon is a 48px-wide widget.
                            ),
                     ),
                    ),

               ),

          ]),

      );
      }

  void _listen() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => _submitQuery(val.recognizedWords)
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _submitQuery (String text ) {

    _textController.clear();
    if(text.startsWith('call') || text.endsWith('hello') || text.endsWith('please')) {
      Facts message = new Facts(
        text: text,
        name: "User",
        type: true,
      );
      setState(() {
        messageList.insert(0, message);
      });
      if (text.contains('hello') || text.contains('hey')) {
        Facts aiMessage = new Facts(
          text: 'Hi, I\'m Diya',
          name: "digi",
          type: false,
        );
        setState(() {
          messageList.insert(0, aiMessage);
        });
      } else if(text.startsWith('call')){
        _makingPhoneCall();
      }else if(text.endsWith('please')){
        Facts bot = new Facts(
          text: processedData(text),
          name: "digi",
          type: false,
        );
        setState(() {
          messageList.insert(0, bot);
        });
        if(bot.text.startsWith('http')) {
          _launchURL(bot.text);
        }
      }     else {
        Facts bot = new Facts(
          text: 'processing',
          name: "digi",
          type: false,
        );
        setState(() {
          messageList.insert(0, bot);
        });
      }
    } else {

      Facts bot = new Facts(
        text: """
        Thanks, for Reaching out 
        Unfortunately, I'm still in dev phase\n
        Soon, my creator Mr.RK  
        Will finish the AI Part to address your queries 
        """   ,
        name: "digi",
        type: false,
      );
      setState(() {
        messageList.insert(0, bot);
      });

    }
  }

  _makingPhoneCall() async {
    const url = 'tel:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String dnnProcessedValue = "";

  String processedData(String msg){
    fetchPost(msg).then((value) => print(value));
    return dnnProcessedValue;
  }

  Future<String> fetchPost(String msg) async {
    print('Here we go !!!');
    await fetchAlbum(msg).then((value) => {
      dnnProcessedValue = value.result,
    });
    return dnnProcessedValue;
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}



