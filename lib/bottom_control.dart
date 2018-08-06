import 'package:flutter/material.dart';
import 'package:podcast_new/next_button.dart';
import 'package:podcast_new/play_pause_button.dart';
import 'package:podcast_new/prev_button.dart';
import 'package:podcast_new/theme.dart';

class BottomControl extends StatelessWidget {
  const BottomControl({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Material(
        color: accentColor,
        shadowColor: const Color(0x44000000),
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
          child: new Column(
            children: <Widget>[
              new RichText(
                text: new TextSpan(text: '', children: [
                  new TextSpan(
                      text: 'Song Title\n',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        height: 1.5,
                      )),
                  new TextSpan(
                      text: 'Artist Name',
                      style: new TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.0,
                        letterSpacing: 3.0,
                        height: 1.5,
                      )),
                ]),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: new Row(
                  //iki geje sek mikir
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new PrevButton(),
                    new Expanded(child: new Container()),
                    new PlayAndPauseButton(),
                    new Expanded(child: new Container()),
                    new NextButton(),
                    new Expanded(child: new Container()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



