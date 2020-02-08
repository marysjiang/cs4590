import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;
SamplePlayer music;
SamplePlayer click1;
SamplePlayer click2;
SamplePlayer click3;
SamplePlayer click4;
SamplePlayer click5;

double musicLength;

Bead endListener;
UGen musicRateGlide;

void setup() {
  size(320, 240);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  music = getSamplePlayer("summersamba2.wav"); // source material
  click1 = getSamplePlayer("click1.wav"); // button click sounds
  click2 = getSamplePlayer("click2.wav");
  click3 = getSamplePlayer("click3.wav");
  click4 = getSamplePlayer("click4.wav");
  click5 = getSamplePlayer("click5.wav");

  musicLength = music.getSample().getLength();
  
  musicRateGlide = new Glide(ac, 1, 500);
  
  music.setRate(musicRateGlide);
  music.setToLoopStart();
  
  music.setKillOnEnd(false);
  click1.setKillOnEnd(false);
  click2.setKillOnEnd(false);
  click3.setKillOnEnd(false);
  click4.setKillOnEnd(false);
  click5.setKillOnEnd(false);

  music.pause(true);
  click1.pause(true);
  click2.pause(true);
  click3.pause(true);
  click4.pause(true);
  click5.pause(true);

  endListener = new Bead() {
    public void messageReceived(Bead msg) {
      SamplePlayer sp = (SamplePlayer) msg;
      sp.setEndListener(null);
      setPlaybackRate(0);
    }
  };
  
  ac.out.addInput(music);
  ac.out.addInput(click1);
  ac.out.addInput(click2);
  ac.out.addInput(click3);
  ac.out.addInput(click4);
  ac.out.addInput(click5);


  p5.addButton("Play")
    .setPosition(110, 25)
    .setSize(100, 30)
    .setLabel("Play");
    
  p5.addButton("Stop")
    .setPosition(110, 65)
    .setSize(100, 30)
    .setLabel("Stop");
    
  p5.addButton("FastForward")
    .setPosition(110, 105)
    .setSize(100, 30)
    .setLabel("Fast Forward");
   
  p5.addButton("Rewind")
    .setPosition(110, 145)
    .setSize(100, 30)
    .setLabel("Rewind");
  
  p5.addButton("Reset")
    .setPosition(110, 185)
    .setSize(100, 30)
    .setLabel("Reset");
    
  ac.start();
}


void draw() {
  background(0);
}

void Play(int val) {
  play(click1);
  if (music.getPosition() < musicLength) {
    setPlaybackRate(1);
    addEndListener();
    music.start();
  }
}

void Stop(int val) {
  play(click2);
  music.pause(true);
}

void FastForward(int val) {
  play(click3);
  if (music.getPosition() < musicLength) {
    setPlaybackRate(1.5);
    addEndListener();
    music.start();
  }
}

void Rewind(int val) {
  play(click4);
  if (music.getPosition() > 0) {
    setPlaybackRate(-1.5);
    addEndListener();
    music.start();
  }
}

void Reset(int val) {
  play(click5);
  music.pause(true);
  music.reset();
}

public void addEndListener() {
  if (music.getEndListener() == null) {
    music.setEndListener(endListener);
  }
}

public void setPlaybackRate(float rate) {
  if (music.getPosition() >= musicLength) {
    System.out.println("end of tape");
    music.setToEnd();
  }
  if (music.getPosition() < 0) {
    System.out.println("beginning of tape");
    music.reset();
  }
  
  musicRateGlide.setValue(rate);
}

void play(SamplePlayer sp) {
  sp.start();
  sp.setToLoopStart();
}
