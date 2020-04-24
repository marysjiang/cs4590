import beads.*;
import org.jaudiolibs.beads.*;
import controlP5.*;
import java.util.*;

//to use text to speech functionality, copy text_to_speech.pde from this sketch to yours
//example usage below

//IMPORTANT (notice from text_to_speech.pde):
//to use this you must import 'ttslib' into Processing, as this code uses the included FreeTTS library
//e.g. from the Menu Bar select Sketch -> Import Library... -> ttslib

TextToSpeechMaker ttsMaker; 

//<import statements here>

//to use this, copy notification.pde, notification_listener.pde and notification_server.pde from this sketch to yours.
//Example usage below.

//name of a file to load from the data directory
String eventDataJSON1 = "smarthome_dinner_at_home.json";
String eventDataJSON2 = "smarthome_parent_night_out.json";
String eventDataJSON3 = "smarthome_party.json";
String eventDataJSON4 = "smarthome_work_at_home.json";

SamplePlayer dinnerSound;
SamplePlayer sp;

ControlP5 p5;

RadioButton context;
//String contextType;

ScrollableList spouse1;
ScrollableList spouse2;
ScrollableList kid1;
ScrollableList kid2;
ScrollableList housekeeper;
ScrollableList babysitter;
ScrollableList guest;

ScrollableList carKeys;
ScrollableList mobilePhone;
ScrollableList tvRemote;
ScrollableList cat;
ScrollableList dog;

Button update;

NotificationServer server;
ArrayList<Notification> notifications;

Context contextType;

PriorityQueue<Notification> queue;
Notification notification;

Example example;

void setup() {
  ac = new AudioContext(); //ac is defined in helper_functions.pde
  p5 = new ControlP5(this);
  
  ac.start();
  
  size(800, 500);
  
  Comparator<Notification> priorityComp = new Comparator<Notification>() {
    public int compare(Notification n1, Notification n2) {
      return min(n1.getPriorityLevel(), n2.getPriorityLevel());
    }
  };
  
  // initialize priority queue
  queue = new PriorityQueue<Notification>(15, priorityComp);
  
  // initialize contextType
  contextType = new DinnerAtHomeFilter();
  
  // create endListener
  endListener = new Bead() {
    public void messageReceived(Bead msg) {
      SamplePlayer sp = (SamplePlayer) msg;
      sp.pause(true);
      sp.setEndListener(null);
      println("=== END LISTENER DESTROYED ===");
    }
  };
  
  sp = new SamplePlayer(ac, 0);
  
  dinnerSound = getSamplePlayer("dinner.wav");
  ac.out.addInput(dinnerSound);
  
  spouse1 = p5.addScrollableList("spouse1")
    .setPosition(5, 5)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
    
  spouse2 = p5.addScrollableList("spouse2")
    .setPosition(135, 5)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
    
  kid1 = p5.addScrollableList("kid1")
    .setPosition(265, 5)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);

  kid2 = p5.addScrollableList("kid2")
    .setPosition(400, 5)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
    
  housekeeper = p5.addScrollableList("housekeeper")
    .setPosition(535, 5)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
  
  babysitter = p5.addScrollableList("babysitter")
    .setPosition(670, 5)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
  
  guest = p5.addScrollableList("guest")
    .setPosition(5, 180)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
    
  carKeys = p5.addScrollableList("carKeys")
    .setPosition(135, 180)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
  
  mobilePhone = p5.addScrollableList("mobilePhone")
    .setPosition(265, 180)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
    
  tvRemote = p5.addScrollableList("tvRemote")
    .setPosition(400, 180)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
    
  cat = p5.addScrollableList("cat")
    .setPosition(535, 180)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
  
  dog = p5.addScrollableList("dog")
    .setPosition(670, 180)
    .setSize(120, 160)
    .setColorForeground(color(220))
    .setColorActive(color(120))
    .setType(ScrollableList.LIST)
    .addItem("Kitchen", 0)
    .addItem("Living Room", 1)
    .addItem("Family Room", 2)
    .addItem("Utility Room", 3)
    .addItem("Garage", 4)
    .addItem("Front Porch", 5)
    .addItem("Back Porch", 6)
    .addItem("Master Bath", 7)
    .addItem("Guest Bath", 8)
    .addItem("Master Bedroom", 9)
    .addItem("Kids Bedroom", 10)
    .addItem("Guest Bedroom", 11);
  
  context = p5.addRadioButton("context")
    .setPosition(20, 400)
    .setSize(120, 40)
    .setColorForeground(color(140))
    .setColorActive(color(200))
    .setLabelPadding(-90, 0)
    .setItemsPerRow(4)
    .setSpacingColumn(20)
    .addItem("Family Dinner", 0)
    .addItem("Parent Night Out", 1)
    .addItem("Party", 2)
    .addItem("Work at Home", 3)
    .activate(0);
  
  update = p5.addButton("update")
    .setPosition(620, 390)
    .setColorForeground(0xff660000)
    .setColorActive(0xffff0000)
    .setSize(140, 60)
    .setLabel("Update");
    
  //this will create WAV files in your data directory from input speech 
  //which you will then need to hook up to SamplePlayer Beads
  ttsMaker = new TextToSpeechMaker();
      
  //START NotificationServer setup
  server = new NotificationServer();
  
  //instantiating a custom class (seen below) and registering it as a listener to the server
  example = new Example();
  server.addListener(example);
  
  //loading the event stream, which also starts the timer serving events
  server.loadEventStream(eventDataJSON1);
  
  //END NotificationServer setup
  
}

void draw() {
  //this method must be present (even if empty) to process events such as keyPressed()  
  background(1);
  
  //SamplePlayer notifPlayer = null;
  
  if (!queue.isEmpty()) {
    notification = queue.poll();
    
    println("DEQUEUED === " + notification + " TYPE === " + notification.getType());
    
    //Notification head = queue.peek();

    // sonify
    if (notification != null && ((notification.getSoundFile().getEndListener() == null) || (sp.getEndListener() == null))) {
      if (notification.ttsText != null) {
        try {
          Thread.sleep(4000);
        } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
        }
        if (notification.getSoundFile() != null) {
          ac.out.addInput(notification.getSoundFile());
          play(notification.soundFile);
        }
        ttsExamplePlayback(notification.ttsText);
      } else if (notification.getSoundFile() != null) {
        try {
          Thread.sleep(2000);
        } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
        }
        ac.out.addInput(notification.getSoundFile());
        //addEndListener(notification.getSoundFile());
        //notification.soundFile.seKillOnEnd(true);
        play(notification.soundFile);
      }
    }
  }
}

// update locations
void update(int val) {
  String[] locations = new String[]{"Kitchen", "Living Room", "Family Room", "Utility Room", "Garage",
    "Front Porch", "Back Porch", "Master Bath", "Guest Bath", "Master Bedroom", "Kids Bedroom", "Guest Bedroom" };
  
  // I'm sorry for the ugly code
  String updatedLocations = "Spouse 1 " + locations[(int) spouse1.getValue()] + " Spouse 2 " + locations[(int) spouse2.getValue()]
    + " Kid 1 " + locations[(int) kid1.getValue()] + " Kid 2 " + locations[(int) kid2.getValue()] + " Housekeeper "
    + locations[(int) housekeeper.getValue()] + " Babysitter " + locations[(int) babysitter.getValue()] + " Guest "
    + locations[(int) guest.getValue()] + " Car Keys " + locations[(int) carKeys.getValue()] + " Mobile phone "
    + locations[(int) mobilePhone.getValue()] + " TV Remote " + locations[(int) tvRemote.getValue()] + " Cat "
    + locations[(int) cat.getValue()] + " Dog " + locations[(int) dog.getValue()];
    
  println(updatedLocations);
  ttsExamplePlayback(updatedLocations);
  //play(catSound);
  //ttsExamplePlayback(locations[(int) dog.getValue()]);
}

// change context
void context(int val) {
  // retrieve context type for notification filtering
  
  if (val == 0) {
    keyPressed(eventDataJSON1);
    contextType = new DinnerAtHomeFilter();
    play(dinnerSound);
  } else if (val == 1) {
    keyPressed(eventDataJSON2);
    contextType = new ParentNightOutFilter();
    dinnerSound.pause(true);
  } else if (val == 2) {
    keyPressed(eventDataJSON3);
    contextType = new PartyFilter();
    dinnerSound.pause(true);
  } else {
    keyPressed(eventDataJSON4);
    contextType = new WorkAtHomeFilter();
    dinnerSound.pause(true);
  }
  
  //println("filter selected " + contextType);
}

void keyPressed(String eventData) {
  //example of stopping the current event stream and loading the second one
  //if (key == RETURN || key == ENTER) {
    server.stopEventStream(); //always call this before loading a new stream
    server.loadEventStream(eventData);
    println("**** New event stream loaded: " + eventData + " ****");
  //}
}

//in your own custom class, you will implement the NotificationListener interface 
//(with the notificationReceived() method) to receive Notification events as they come in
class Example implements NotificationListener {
  
  public Example() {
    //setup here
    
  }
  
  //this method must be implemented to receive notifications
  public void notificationReceived(Notification notification) { 
    println("<Example> " + notification.getType().toString() + " notification received at " 
    + Integer.toString(notification.getTimestamp()) + " ms");
    
    // filter notifications by context
    contextType.filterNotification(notification);
    //println("the context type is " + contextType);
    
    String debugOutput = ">>> ";
    switch (notification.getType()) {
      case Door:
        debugOutput += "Door moved: ";
        break;
      case PersonMove:
        debugOutput += "Person moved: ";
        break;
      case ObjectMove:
        debugOutput += "Object moved: ";
        break;
      case ApplianceStateChange:
        debugOutput += "Appliance changed state: ";
        break;
      case PackageDelivery:
        debugOutput += "Package delivered: ";
        break;
      case Message:
        debugOutput += "New message: ";
        break;
    }
    debugOutput += notification.toString();
    //debugOutput += notification.getLocation() + ", " + notification.getTag();
    
    println(debugOutput);
    
   //You can experiment with the timing by altering the timestamp values (in ms) in the exampleData.json file
    //(located in the data directory)
  }
}

void ttsExamplePlayback(String inputSpeech) {
  //create TTS file and play it back immediately
  //the SamplePlayer will remove itself when it is finished in this case
  
  String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
  println("File created at " + ttsFilePath);
  
  //createTTSWavFile makes a new WAV file of name ttsX.wav, where X is a unique integer
  //it returns the path relative to the sketch's data directory to the wav file
  
  //see helper_functions.pde for actual loading of the WAV file into a SamplePlayer
  
  //SamplePlayer sp = getSamplePlayer(ttsFilePath, true); 
  sp = getSamplePlayer(ttsFilePath, true); 

  //true means it will delete itself when it is finished playing
  //you may or may not want this behavior!
  
  ac.out.addInput(sp);
  sp.setToLoopStart();
  addEndListener(sp);
  println("=== TTS PLAYBLACK HAPPENING ===");
  //play(sp);
  sp.start();
  println("TTS: " + inputSpeech);
}
