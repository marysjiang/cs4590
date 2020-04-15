// FFT_01.pde
// This example is based in part on an example included with
// the Beads download originally written by Beads creator
// Ollie Bown. It draws the frequency information for a
// sound on screen.
import beads.*;
import controlP5.*;

private static final int BIQUAD_MIN = 100;
private static final int BIQUAD_MAX = 800;

PowerSpectrum ps;
ControlP5 p5;

Glide lpfGlide;
BiquadFilter lpf;

Glide hpfGlide;
BiquadFilter hpf;

Glide bpfGlide;
BiquadFilter bpf;

RadioButton filterSelect;
int currentFilter = 0;

color fore = color(255, 255, 255);
color back = color(0,0,0);

void setup() {

  size(600,600);
  
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  filterSelect = p5.addRadioButton("FilterSelect")
    .setPosition(300, 30)
    .setSize(45, 20)
    .setColorActive(color(250))
    .setItemsPerRow(2)
    .setSpacingColumn(90)
    .setSpacingRow(20)
    .addItem("No Filter", 0)
    .addItem("Low Pass Filter", 1)
    .addItem("High Pass Filter", 2)
    .addItem("Band Pass Filter", 3);
    
  filterSelect.activate(0);
  
  // set up a master gain object
  Gain g = new Gain(ac, 2, 0.3);
  ac.out.addInput(g);
  
  // set up low pass filter
  lpfGlide = new Glide(ac, BIQUAD_MIN);
  lpf = new BiquadFilter(ac, BiquadFilter.Type.LP, lpfGlide, 0.8);
  
  // set up high pass filter
  hpfGlide = new Glide(ac, BIQUAD_MIN);
  hpf = new BiquadFilter(ac, BiquadFilter.Type.HP, hpfGlide, 0.8);
  
  // set up band pass filter
  bpfGlide = new Glide(ac, BIQUAD_MIN);
  bpf = new BiquadFilter(ac, BiquadFilter.Type.BP_SKIRT, bpfGlide, 0.8);
  
  // load up a sample included in code download
  SamplePlayer player = null;
  
  try {
    player = getSamplePlayer("game.wav", false);
     
    g.addInput(player); // connect the SamplePlayer to the master Gain
  } catch(Exception e) { 
    e.printStackTrace();
  }
  
  lpf.addInput(player);
  hpf.addInput(player);
  bpf.addInput(player);
  
  // In this block of code, we build an analysis chain
  // the ShortFrameSegmenter breaks the audio into short,
  // discrete chunks.
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  
  // FFT stands for Fast Fourier Transform
  // all you really need to know about the FFT is that it
  // lets you see what frequencies are present in a sound
  // the waveform we usually look at when we see a sound
  // displayed graphically is time domain sound data
  // the FFT transforms that into frequency domain data
  FFT fft = new FFT();
  // connect the FFT object to the ShortFrameSegmenter
  sfs.addListener(fft);
  
  // the PowerSpectrum pulls the Amplitude information from
  // the FFT calculation (essentially)
  ps = new PowerSpectrum();
   
  // connect the PowerSpectrum to the FFT
  fft.addListener(ps);
   
  // list the frame segmenter as a dependent, so that the
  // AudioContext knows when to update it.
  ac.out.addDependent(sfs);
   
  // start processing audio
  ac.start();
}

void FilterSelect(int a) {
  if (a == 0) {
    filterSelect.activate(0);
  } else if (a == 1) {
    filterSelect.activate(1);
    lpfGlide.setValue(BIQUAD_MIN);
  } else if (a == 2) {
    filterSelect.activate(2);
    hpfGlide.setValue(BIQUAD_MIN);
  } else if (a == 3) {
    filterSelect.activate(3);
  }
}

// In the draw routine, we will interpret the FFT results and
// draw them on screen.
void draw() {
  background(back);
  stroke(fore);

  // The getFeatures() function is a key part of the Beads
  // analysis library. It returns an array of floats
  // how this array of floats is defined (1 dimension, 2
  // dimensions ... etc) is based on the calling unit
  // generator. In this case, the PowerSpectrum returns an
  // array with the power of 256 spectral bands.
  float[] features = ps.getFeatures();
  
  // if any features are returned
  if(features != null) {
  // for each x coordinate in the Processing window
    for (int x = 0; x < width; x++) {
       // figure out which featureIndex corresponds to this x-
       // position
       int featureIndex = (x * features.length) / width;
       
       // calculate the bar height for this feature
       int barHeight = Math.min((int)(features[featureIndex] * height), height - 1);
       
       // draw a vertical line corresponding to the frequency
       // represented by this x-position
       line(x, height, x, height - barHeight);
    }
  }
}
