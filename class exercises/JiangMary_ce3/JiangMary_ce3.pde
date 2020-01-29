import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

ControlP5 p5;
SamplePlayer bgm;
SamplePlayer voice1;
SamplePlayer voice2;

Gain masterGain;
Glide masterGainGlide;

Gain bgmGain;
Glide bgmGainGlide;

void setup() {
  size(320, 240);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  // initialize sounds
  bgm = getSamplePlayer("intermission.wav");
  voice1 = getSamplePlayer("cow.wav");
  voice2 = getSamplePlayer("goat.wav");

  // controls the overall gain
  masterGainGlide = new Glide(ac, 1.0, 50);
  masterGain = new Gain(ac, 1, masterGainGlide);
  
  // triggers bgm to unduck at the end of voice clips
  Bead endListener = new Bead() {
    public void messageReceived(Bead msg) {
      SamplePlayer sp = (SamplePlayer) msg;
      sp.pause(true);
      sp.setToLoopStart();
      bgmGainGlide.setValue(1.0);
    }
  };
  
  voice1.setEndListener(endListener);
  voice2.setEndListener(endListener);
  
  bgm.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);

  bgmGainGlide = new Glide(ac, 1.0, 100);
  bgmGain = new Gain(ac, 1, bgmGainGlide);
  
  voice1.setKillOnEnd(false);
  voice1.pause(true);
  
  voice2.setKillOnEnd(false);
  voice2.pause(true);
  
  bgmGain.addInput(bgm);
  masterGain.addInput(bgmGain);
  masterGain.addInput(voice1);
  masterGain.addInput(voice2);
  ac.out.addInput(masterGain);
  
  p5.addSlider("GainSlider")
    .setRange(10, 100)
    .setValue(50)
    .setPosition(50, 80)
    .setSize(20, 100);
   
  p5.addButton("Voice1")
    .setPosition(200, 70)
    .setSize(70, 50);
  
  p5.addButton("Voice2")
    .setPosition(200, 130)
    .setSize(70, 50);
    
  ac.start();
}


void draw() {
  background(0);
}

void GainSlider(int val) {
  System.out.println("gain slider test");
  masterGainGlide.setValue((int) val / 20);
}

void Voice1(int val) {
  bgmGainGlide.setValue(0.3);
  voice2.pause(true);
  play(voice1);
}

void Voice2(int val) {
  bgmGainGlide.setValue(0.3);
  voice1.pause(true);
  play(voice2);
}

void play(SamplePlayer sp) {
  sp.setToLoopStart();
  sp.start();
}
