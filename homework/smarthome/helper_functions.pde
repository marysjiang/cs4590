//helper functions
AudioContext ac; //needed here because getSamplePlayer() uses it below

Sample getSample(String fileName) {
 return SampleManager.sample(dataPath(fileName)); 
}

SamplePlayer getSamplePlayer(String fileName, Boolean killOnEnd) {
  SamplePlayer player = null;
  try {
    player = new SamplePlayer(ac, getSample(fileName));
    player.setKillOnEnd(killOnEnd);
    player.setName(fileName);
  }
  catch(Exception e) {
    println("Exception while attempting to load sample: " + fileName);
    e.printStackTrace();
    exit();
  }
  
  return player;
}

SamplePlayer getSamplePlayer(String fileName) {
  return getSamplePlayer(fileName, false);
}

public void addEndListener(SamplePlayer sp) {
  if (sp.getEndListener() == null) {
    println("==== END LISTENER ATTACHED ====" + sp);
    sp.setEndListener(endListener);
  }
}

public void play(SamplePlayer sp) {
  sp.setToLoopStart();
  if (sp.getPosition() < sp.getSample().getLength()) {
    sp.start();
  }
}

boolean isPlaying(SamplePlayer sp) {
  return !sp.isPaused();
}

public void wavePlayer() {
  Glide sineFundamental = new Glide(ac, 440.0, 200);
  WavePlayer wp = new WavePlayer(ac, sineFundamental, Buffer.SINE);
  masterGain.addInput(wp);
  
  long time = millis();
  long end = time + 800;
  
  while (true) {
    if (millis() > end) {
      masterGain.removeConnection(0, (UGen)wp, 0);
      break;
    }
  }
}
