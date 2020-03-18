import controlP5.*;
import beads.*;
import java.util.Arrays; 

AudioContext ac;
ControlP5 p5;

int sineCount = 10;
float baseFrequency = 440.0;
float sineIntensity = 1.0;

// Array of Glide UGens for series of harmonic frequency coefficients for each wave type (fundamental sine, square, triangle, sawtooth)
Glide[] sineGainGlide = new Glide[sineCount];

// Array of Gain UGens for harmonic frequency series amplitudes (i.e. baseFrequency + (1/3)*(baseFrequency*3) + (1/5)*(baseFrequency*5) + ...)
Gain[] sineGain = new Gain[sineCount];
Gain masterGain;
Glide masterGainGlide;

// Array of sine wave generator UGens - will be summed by masterGain to additively synthesize square, triangle, sawtooth waves
WavePlayer[] sineTone = new WavePlayer[sineCount];

void setup() {
  //float sineIntensity = 1.0;
  size(400,400);
  ac = new AudioContext();
  p5 = new ControlP5(this);
  
  masterGainGlide = new Glide(ac, .5, 200);  
  masterGain = new Gain(ac, 1, masterGainGlide);
  ac.out.addInput(masterGain);

  // create a UGen graph to synthesize a square wave from a base/fundamental frequency and 9 odd harmonics with amplitudes = 1/n
  // square wave = base freq. and odd harmonics with intensity decreasing as 1/n
  // square wave = baseFrequency + (1/3)*(baseFrequency*3) + (1/5)*(baseFrequency*5) + ...
  
  for (int i = 0, n = 1; i < sineCount; i++, n++) {
    // Create harmonic frequency WavePlayer - i.e. baseFrequency * 3, baseFrequency * 5, ...
    sineTone[i] = new WavePlayer(ac, baseFrequency * n, Buffer.SINE);
    
    // Create gain for each harmonic - i.e. 1/3, 1/5, 1/7, ...
    // For a square wave, we only want odd harmonics, so set all even harmonics to 0 gain/intensity
    sineIntensity = (n % 2 == 1) ? (float) (1.0 / n) : 0;
    println(sineIntensity, " * ", baseFrequency * n);
    
    // create the glide that will control this WavePlayer's gain (harmonic coefficient)
    // create an array of Glides in anticipation of connecting them with ControlP5 sliders
    sineGainGlide[i] = new Glide(ac, sineIntensity, 200);   
    
    //sineGain[i] = new Gain(ac, 1, sineIntensity); // create the gain object
    sineGain[i] = new Gain(ac, 1, sineGainGlide[i]); // create the gain object
    sineGain[i].addInput(sineTone[i]); // then connect the waveplayer to the gain
  
    // finally, connect the gain to the master gain
    // masterGain will sum all of the sine waves, additively synthesizing a square wave tone
    masterGain.addInput(sineGain[i]);
  }
  
  p5.addRadioButton("radioButton")
    .setPosition(50, 80)
    .setSize(50, 30)
    .setSpacingRow(40)
    .setColorForeground(color(200))
    .setColorActive(color(250))
    .addItem("Fundamental", 0)
    .addItem("Triangle", 1)
    .addItem("Sawtooth", 2)
    .addItem("Square", 3);
  
  ac.start();
}

void radioButton(int a) {
  masterGain.clearInputConnections();
  
  if (a == 0) {
    fundamentalWave();
  } else if (a == 1) {
    triangleWave();
  } else if (a == 2) {
    sawtoothWave();
  } else if (a == 3) {
    squareWave();
  }
}

void fundamentalWave() {
  Glide sineFundamental = new Glide(ac, baseFrequency, 200);
  WavePlayer wp = new WavePlayer(ac, sineFundamental, Buffer.SINE);
  Gain gain = new Gain(ac, 1, 1);
  
  gain.addInput(wp);
  masterGain.addInput(gain);
}

void triangleWave() {
  for (int i = 0, n = 1; i < sineCount; i++, n++) {
    sineIntensity = (n % 2 == 1) ? (float) (1.0 / (n * n)) : 0;
    println(sineIntensity, " * ", baseFrequency * n);
    
    sineTone[i] = new WavePlayer(ac, baseFrequency * n, Buffer.SINE);
    sineGainGlide[i] = new Glide(ac, sineIntensity, 200);
    sineGain[i] = new Gain(ac, 1, sineIntensity);
    
    sineGain[i].addInput(sineTone[i]);
    masterGain.addInput(sineGain[i]);
  }
}

void sawtoothWave() {
  for (int i = 0, n = 1; i < sineCount; i++, n++) {
    sineIntensity = (float) (1.0 / n);
    println(sineIntensity, " * ", baseFrequency * n);
    
    sineTone[i] = new WavePlayer(ac, baseFrequency * n, Buffer.SINE);
    sineGainGlide[i] = new Glide(ac, sineIntensity, 200);
    sineGain[i] = new Gain(ac, 1, sineIntensity);
    
    sineGain[i].addInput(sineTone[i]);
    masterGain.addInput(sineGain[i]);
  }
}
    
void squareWave() {
  for (int i = 0, n = 1; i < sineCount; i++, n++) {
    sineIntensity = (n % 2 == 1) ? (float) (1.0 / n) : 0;
    println(sineIntensity, " * ", baseFrequency * n);
    
    sineTone[i] = new WavePlayer(ac, baseFrequency * n, Buffer.SINE);
    sineGainGlide[i] = new Glide(ac, sineIntensity, 200);
    sineGain[i] = new Gain(ac, 1, sineGainGlide[i]);
    
    sineGain[i].addInput(sineTone[i]);    
    masterGain.addInput(sineGain[i]);
  }
}

void draw() {
  background(1);
}
