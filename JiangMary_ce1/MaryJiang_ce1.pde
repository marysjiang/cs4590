import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
ControlP5 p5;
SamplePlayer sp;

Gain g;
Reverb r;
Glide gainGlide;

//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions 
  p5 = new ControlP5(this);
  
  sp = getSamplePlayer("cow.wav");

  gainGlide = new Glide(ac, 1.0, 50);
  g = new Gain(ac, 1, gainGlide);
  
  r = new Reverb(ac, 1);
  
  sp.setKillOnEnd(false);
  
  r.setLateReverbLevel(0);
  
  r.addInput(sp); // audio source -> ugen - > gain
  g.addInput(r); // connect reverb to gain
  ac.out.addInput(g);
  
  //g.addInput(sp);
  //r.addInput(g);
  //ac.out.addInput(r);
  
  p5.addSlider("GainSlider")
    .setRange(10, 100)
    .setValue(50)
    .setPosition(50, 80)
    .setSize(10, 100);
   
  p5.addSlider("ReverbSlider")
    .setRange(0, 100)
    .setValue(0)
    .setPosition(130, 80)
    .setSize(10, 100);
   
  p5.addButton("Play")
    .setPosition(250, 80)
    .setSize(30, 50);
  
  ac.start();
}


void draw() {
  background(0);  //fills the canvas with black (0) each frame
  //gainGlide.setValue(mouseX / (float)width);
  //frequencyGlide.setValue(mouseY);
}

void GainSlider(int val) {
  System.out.println("gain slider test");
  gainGlide.setValue((int) val / 20);
}

void ReverbSlider(int val) {
  System.out.println("reverb slider test");
  r.setLateReverbLevel((int) val / 20);
}

void Play(int val) {
  sp.setToLoopStart();
  sp.start();
}

// create button "Play"
// create method "Play" w/ print statement to test
/* Play(int val) {
    buttonSound.setToLoopStart();
    buttonSound.start();
  }
  CutoffSlider(float val) {
    cutoffGlide.setValue(val);
  }
*/
