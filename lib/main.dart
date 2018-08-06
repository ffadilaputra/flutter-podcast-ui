import 'dart:math';

import 'package:flutter/material.dart';
import 'package:podcast_new/bottom_control.dart';
import 'package:podcast_new/circle_clipper.dart';
import 'package:podcast_new/songs.dart';
import 'package:podcast_new/theme.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Podcast',
      debugShowCheckedModeBanner: false,
      home: new MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylist(
      //audioUrl: demoPlaylist.songs[0].audioUrl,
      playlist: demoPlaylist.songs.map((DemoSong song){
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
            ),
            color: const Color(0xFFDDDDDDD),
            onPressed: () {},
          ),
          title: new Text(''),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {},
              color: const Color(0xFFDDDDDDD),
            )
          ],
        ), //AppBar
        body: new Column(
          children: <Widget>[
            // Berisi Seek bar
            new Expanded(
              child: new AudioPlaylistComponent(
                playlistBuilder: (BuildContext context,Playlist playlist,Widget child){
                    String albumArtUrl = demoPlaylist.songs[playlist.activeIndex].albumArtUrl;
                new AudioRadialSeekBar(
                  //  / albumArtUrl:albumArtUrl,
                );
              },
            ),
            // Visualizer
            new Container(
              width: double.infinity,
              height: 125.0,
            ),
            // Titile , Artist
            new BottomControl(),
          ],
        ),
      ),
    );
  }
}

class AudioRadialSeekBar extends StatefulWidget {

  @override
  AudioRadialSeekBarState createState() {
    return new AudioRadialSeekBarState();
  }
}

class AudioRadialSeekBarState extends State<AudioRadialSeekBar> {

  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
        updateMe: [
          WatchableAudioProperties.audioPlayhead,
          WatchableAudioProperties.audioSeeking,
        ],
        playerBuilder:
            (BuildContext context, AudioPlayer player, Widget child) {
          double playbackProgress = 0.0;

          if (player.audioLength != null &&
              player.position != null) {
                   playbackProgress = player.position.inMilliseconds/player.audioLength.inMilliseconds;
              }
          _seekPercent = player.isSeeking ? _seekPercent:null;

          return new RadialSeekBar(
            progress: playbackProgress,
            seekPercent: _seekPercent,
            onSeekRequested: (double seekPercent){
                setState(()=> _seekPercent = seekPercent );
                final seekMilis = (player.audioLength.inMilliseconds * seekPercent).round();
                player.seek(new Duration(milliseconds: seekMilis));
            },
          );
        },
        child: new RadialSeekBar());
  }
}

class RadialSeekBar extends StatefulWidget {
  final double seekPercent;
  final double progress;
  final Function(double) onSeekRequested;

  RadialSeekBar({
    this.progress = 0.0,
    this.seekPercent = 0.0,
    this.onSeekRequested,
  });

  @override
  RadialSeekBarState createState() {
    return new RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {

  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _progress = 0.0;
  double currentDragPercent;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidet) {
    super.didUpdateWidget(oldWidet);
    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord startCoord) {
    _startDragCoord = startCoord;
    _startDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord updateCoord) {
    final dragAngle = updateCoord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(
        () => currentDragPercent = (_startDragPercent + dragPercent) % 1.0);
  }

  void _onDragEnd() {

    if(widget.onSeekRequested != null){
        widget.onSeekRequested(currentDragPercent);
    }
    setState(() {
      // _progress = currentDragPercent;
      currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;

    if(currentDragPercent != null){
        thumbPosition = currentDragPercent;
    }else if(widget.seekPercent != null){
        thumbPosition = widget.seekPercent;
    }

    return new RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: new Center(
          child: new Container(
            width: 125.0,
            height: 125.0,
            //color: Colors.green,
            child: new RadialProgessBar(
              progressColor: accentColor,
              trackColor: const Color(0xFFDDDDDD),
              thumbColor: lightAccentColor,
              progressPercent: _progress,
              thumbPosition: thumbPosition,
              innerPadding: const EdgeInsets.all(8.0),
              //outerPadding: const EdgeInsets.all(10.0),
              custom: new ClipOval(
                clipper: new CircleClipper(),
                child: new Image.network(
                  demoPlaylist.songs[0].albumArtUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialProgessBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final Widget custom;
  final EdgeInsets innerPadding;
  final EdgeInsets outerPadding;

  RadialProgessBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbPosition = 0.0,
    this.custom,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
  });

  @override
  _RadialProgessBarState createState() => _RadialProgessBarState();
}

class _RadialProgessBarState extends State<RadialProgessBar> {
  EdgeInsets _insetsForPainter() {
    final outerThickness = max(
          widget.trackWidth,
          max(
            widget.progressWidth,
            widget.thumbSize,
          ),
        ) /
        2;
    return new EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: widget.outerPadding,
      child: new CustomPaint(
        foregroundPainter: new RadiarSeekBarPainter(
            progressColor: widget.progressColor,
            progressPercent: widget.progressPercent,
            progressWidth: widget.progressWidth,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition,
            thumbSize: widget.thumbSize,
            trackColor: widget.trackColor,
            trackWidth: widget.progressWidth),
        child: new Padding(
            padding: _insetsForPainter() + widget.innerPadding,
            child: widget.custom),
      ),
    );
  }
}

class RadiarSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Color trackColor;
  final Paint trackPaint;
  final double progressWidth;
  final Color progressColor;
  final Paint progressPaint;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final Paint thumbPaint;
  final double thumbPosition;

  RadiarSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.thumbSize,
    @required thumbColor,
    @required this.progressPercent,
    @required this.thumbPosition,
  })  : trackPaint = new Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
        progressPaint = new Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = new Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize =
        new Size(size.width - outerThickness, size.height - outerThickness);
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;
    canvas.drawCircle(center, radius, trackPaint);
    final sweepAngle = 2 * pi * progressPercent;
    final startAngle = -pi / 2;

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, progressPaint);
    //Paint Thumbnail
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;
    final thumbRad = thumbSize / 2.0;
    canvas.drawCircle(thumbCenter, thumbRad, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
