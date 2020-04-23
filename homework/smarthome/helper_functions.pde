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
    sp.setEndListener(endListener);
  }
}

public void play(SamplePlayer sp) {
  sp.setToLoopStart();
  if (sp.getPosition() < sp.getSample().getLength()) {
    addEndListener(sp);
    sp.start();
  }
}

boolean isPlaying(SamplePlayer sp) {
  return !sp.isPaused();
}
