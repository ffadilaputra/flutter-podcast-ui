import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:podcast_new/theme.dart';

class PlayAndPauseButton extends StatelessWidget {
  const PlayAndPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],
      playerBuilder: (BuildContext context,AudioPlayer player,Widget child){
        IconData ico = Icons.music_note;
        Function onPressed;
        Color btnColor = lightAccentColor;

        if(player.state == AudioPlayerState.playing){
          ico = Icons.pause;
          onPressed = player.pause;
          btnColor = Colors.white;
        }else if(player.state == AudioPlayerState.paused || player.state == AudioPlayerState.completed){
          ico = Icons.play_arrow;
          onPressed = player.play;
          btnColor = Colors.white;
        }

      return new RawMaterialButton(
        shape: new CircleBorder(),
        fillColor: btnColor,
        splashColor: lightAccentColor,
        highlightColor: lightAccentColor.withOpacity(0.5),
        elevation: 10.0,
        highlightElevation: 5.0,
        onPressed: onPressed,
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Icon(
            ico,
            color: darkAccentColor,
            size: 35.0,
          ),
        ),
      );
      },
    );
  }
}
