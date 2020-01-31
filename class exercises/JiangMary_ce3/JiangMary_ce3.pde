import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

private static final int BIQUAD_FILTER = 400;

ControlP5 p5;
SamplePlayer bgm;
SamplePlayer voice1;
SamplePlayer voice2;

Gain masterGain;
Glide masterGainGlide;

BiquadFilter filter;
Glide filterGlide;

Gain bgmGain;
Glide bgmGainGlide;

void setup() {
  size(320, 240);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  bgm = getSamplePlayer("intermission.wav"); // source material
  voice1 = getSamplePlayer("v1.wav");
  voice2 = getSamplePlayer("v2.wav");

  masterGainGlide = new Glide(ac, 1.0, 100);
  masterGain = new Gain(ac, 1, masterGainGlide);
  
  // triggers bgm to unduck at the end of voice clips
  Bead endListener = new Bead() {
    public void messageReceived(Bead msg) {
      SamplePlayer sp = (SamplePlayer) msg;
      sp.pause(true);
      sp.setToLoopStart();
      bgmGainGlide.setValue(1.0);
      if (isTalking()) {
        filterGlide.setValue(BIQUAD_FILTER);
      } else {
        filterGlide.setValue(1.0);
      }
    }
  };
  
  voice1.setEndListener(endListener);
  voice2.setEndListener(endListener);
  
  bgm.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);

  bgmGainGlide = new Glide(ac, 1.0, 300);
  bgmGain = new Gain(ac, 1, bgmGainGlide);
  
  filter = new BiquadFilter(ac, BiquadFilter.Type.HP, filterGlide, 0.8); // frequency as a UGen and Q as a float
  filterGlide = new Glide(ac, 1.0, 800);
  
  voice1.setKillOnEnd(false);
  voice1.pause(true);
  
  voice2.setKillOnEnd(false);
  voice2.pause(true);
  
  filter.addInput(bgm);
  bgmGain.addInput(filter);
  masterGain.addInput(bgmGain);
  masterGain.addInput(voice1);
  masterGain.addInput(voice2);
  ac.out.addInput(masterGain);
  
  p5.addSlider("GainSlider")
    .setRange(10, 100)
    .setValue(50)
    .setPosition(50, 80)
    .setSize(20, 100)
    .setLabel("Master Gain");
   
  p5.addButton("Voice1")
    .setPosition(200, 70)
    .setSize(70, 50)
    .setLabel("Voice 1");
  
  p5.addButton("Voice2")
    .setPosition(200, 130)
    .setSize(70, 50)
    .setLabel("Voice 2");
    
  ac.start();
}


void draw() {
  background(0);
}

void GainSlider(int val) {
  System.out.println("gain slider test");
  masterGainGlide.setValue((int) val / 35);
}

void Voice1(int val) {
  bgmGainGlide.setValue(0.2);
  voice2.pause(true);
  play(voice1);
  filterGlide.setValue(BIQUAD_FILTER);
}

void Voice2(int val) {
  bgmGainGlide.setValue(0.2);
  voice1.pause(true);
  play(voice2);
  filterGlide.setValue(BIQUAD_FILTER);
}

void play(SamplePlayer sp) {
  sp.setToLoopStart();
  sp.start();
}

boolean isTalking() {
  return !voice1.isPaused() || !voice2.isPaused();
}
