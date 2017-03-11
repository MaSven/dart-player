import 'dart:collection';


class Audio{
  Map<String,String> audioFiles;
  String currentPlay="";
  bool isPLay=false;

  Audio(){
    audioFiles= new LinkedHashMap();
  }
}