// Copyright (c) 2017, sven. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'Audio.dart';

Audio audio;

AudioElement player = querySelector("#player");
ButtonElement next = querySelector("#audio-next");
ButtonElement previous = querySelector("#audio-previous");
ButtonElement play = querySelector("#audio-play");
ButtonElement stop = querySelector("#audio-stop");
UListElement audioFiles= querySelector("#files");

void files(List<File> files){

  final FileReader reader = new FileReader();

  for(File f in files){
    reader.onLoad.listen((e){
      sendData(f.name,reader.result);
    });
    if(audio.currentPlay=="")audio.currentPlay=f.name;
    Element bPlay = new ButtonElement();
    bPlay.text="Play";

    Element b = new ButtonElement();
    b.text= "Löschen";

    Element e = new LIElement();
    e.text = f.name;
    e.children.add(b);
    e.children.add(bPlay);
    b.onClick.listen((el){
      final String id = f.name;
      audio.audioFiles.remove(id);
      if(audio.currentPlay==id){
        stopAudio();
      }
      audioFiles.children.remove(e);
    });
    bPlay.onClick.listen((el){
      audio.isPLay=false;
      List<String> buffer = new List.from(audio.audioFiles.keys,growable: false);
      int index = buffer.indexOf(audio.currentPlay);
      removeCss(index);
      audio.currentPlay=f.name;
      playAudio();
    });
    audioFiles.children.add(e);
    reader.readAsDataUrl(f);
  }
}

void sendData(String name,String data){
  audio.audioFiles.putIfAbsent(name,()=>data);
}

void stopAudio(){
  player.pause();
  player.setAttribute("src","");
}



void playAudio([String song]){
  if(audio.isPLay){
    player.pause();
    audio.isPLay=false;
    return;
  }
  if(audio.audioFiles.length==0) return;
  List<String> buffer = new List.from(audio.audioFiles.keys,growable: false);
  int index;
  if(song !=null){
    index = buffer.indexOf(song);
    audioFiles.children[index].setAttribute("style","background: red");
    player.setAttribute("src",audio.audioFiles[song]);
  }else{
    index = buffer.indexOf(audio.currentPlay);
    audioFiles.children[index].setAttribute("style","background: red");
    player.setAttribute("src",audio.audioFiles[audio.currentPlay]);
  }
  audio.isPLay=true;
  player.play();
}

void nextSong(){
  audio.isPLay=false;
  List<String> buffer = new List.from(audio.audioFiles.keys,growable: false);
  int index = buffer.indexOf(audio.currentPlay);
  removeCss(index);
  if(index==buffer.length-1)
    index=0;
  else index++;
  audio.currentPlay= buffer[index];

  playAudio();
}

void previousSong(){
  audio.isPLay=false;
  List<String> buffer = new List.from(audio.audioFiles.keys,growable: false);
  int index = buffer.indexOf(audio.currentPlay);
  removeCss(index);
  if(index==0)
    index=buffer.length-1;
  else index--;
  audio.currentPlay= buffer[index];

  playAudio();
}

void removeCss(int e){
  audioFiles.children[e].setAttribute("style","background: white");
}

void main() {
  audio= new Audio();
  FileUploadInputElement  audioFileElement =querySelector("#audio-file");
  audioFileElement.onChange.listen((e)=>files(audioFileElement.files));
  play.onClick.listen((e)=>playAudio());
  next.onClick.listen((e)=>nextSong());
  previous.onClick.listen((e)=>previousSong());
  player.onEnded.listen((e)=>nextSong());


}





