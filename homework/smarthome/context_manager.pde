import java.util.*;

double soundLength;
Bead endListener;

abstract class Context {
  public abstract void filterMessage(Notification notif);
  public abstract void filterApplianceStateChange(Notification notif);
  public abstract void filterDoor(Notification notif);
  public abstract void filterDelivery(Notification notif);
  
  public abstract void filterNotification(Notification notif);
}

class DinnerAtHomeFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = "Message to " + notif.getTag() + notif.getNote().replace(":", "");
      //notif.soundFile = null;
      queue.add(notif);
    } else if (notif.getPriorityLevel() == 2) {
      notif.soundFile = getSamplePlayer("message.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote().replace(":", "");
      //notif.soundFile = null;
      queue.add(notif);
    } else if (notif.getPriorityLevel() == 2) {
      notif.soundFile = getSamplePlayer("stoveOn.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() >= 2) {
      notif.soundFile = getSamplePlayer("door.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      //notif.soundFile = getSamplePlayer("doorbell.wav");
      //notif.ttsText = null;
      notif.ttsText = "Delivery for " + notif.getTag();
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        filterDoor(notif);
        break;
      case ApplianceStateChange:
        filterApplianceStateChange(notif);
        break;
      case Message:
        filterMessage(notif);
        break;
      case PackageDelivery:
        filterDelivery(notif);
        break;
      default:
        break;
    }
  }
}

class ParentNightOutFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = "Message to " + notif.getTag() + notif.getNote().replace(":", "");
      //notif.soundFile = null;
      queue.add(notif);
    } else if (notif.getPriorityLevel() >= 2) {
      notif.soundFile = getSamplePlayer("message.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote().replace(":", "");
      //notif.soundFile = null;
      queue.add(notif);
    } else if (notif.getPriorityLevel() >= 2) {
      notif.soundFile = getSamplePlayer("stoveOn.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() >= 1) {
      notif.soundFile = getSamplePlayer("door.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = "Delivery at " + notif.getLocation();
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        filterDoor(notif);
        break;
      case ApplianceStateChange:
        filterApplianceStateChange(notif);
        break;
      case Message:
        filterMessage(notif);
        break;
      case PackageDelivery:
        filterDelivery(notif);
        break;
      default:
        break;
    }
  }
}

class PartyFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() >= 1) {
      notif.soundFile = getSamplePlayer("message.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getFlag().equals("error")) {
      if (notif.getTag().equals("wifi")) {
        notif.ttsText = notif.getTag() + " has an error";
        queue.add(notif);
      } else if (notif.getTag().equals("sink") || notif.getTag().equals("stove")) {
        notif.ttsText = notif.getNote().replace(":", "");
        queue.add(notif);
      } else if (notif.getTag().equals("lights")) {
        notif.ttsText = "Lights left on in " + notif.getLocation();
        queue.add(notif);
      }
    }
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      notif.soundFile = getSamplePlayer("door.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() >= 1) {
      notif.soundFile = getSamplePlayer("doorbell.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
  }
  
  public void filterObjectMove(Notification notif) {
    if (notif.getPriorityLevel() >= 1) {
      if (notif.getTag().equals("dog") || notif.getTag().equals("cat")) {
        notif.ttsText = "Pet moving to " + notif.getLocation();
        queue.add(notif);
      }
    }
  }
  
  public void filterPersonMove(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      notif.ttsText = notif.getTag() + " moving to " + notif.getLocation();
      queue.add(notif);
    }
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        filterDoor(notif);
        break;
      case ApplianceStateChange:
        filterApplianceStateChange(notif);
        break;
      case Message:
        filterMessage(notif);
        break;
      case PackageDelivery:
        filterDelivery(notif);
        break;
      case ObjectMove:
        filterObjectMove(notif);
        break;
      case PersonMove:
        filterPersonMove(notif);
        break;
      default:
        break;
    }
  }
}

class WorkAtHomeFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = "Message to " + notif.getTag() + notif.getNote().replace(":", "");
      queue.add(notif);
    } else if (notif.getPriorityLevel() >= 2) {
      notif.soundFile = getSamplePlayer("message.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote().replace(":", "");
      queue.add(notif);
    } else if (notif.getPriorityLevel() >= 2) {
      if (notif.getTag().equals("stove")) {
        notif.soundFile = getSamplePlayer("stoveOn.wav");
        notif.ttsText = null;
        queue.add(notif);
      } else if (notif.getTag().equals("washing machine")) {
        notif.soundFile = getSamplePlayer("washer.wav");
        notif.ttsText = null;
        queue.add(notif);
      } else if (notif.getTag().equals("sink")) {
        notif.soundFile = getSamplePlayer("sink.wav");
        notif.ttsText = null;
        queue.add(notif);
      }
    }
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      notif.soundFile = getSamplePlayer("door.wav");
      notif.ttsText = null;
      queue.add(notif);
    }
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = "Delivery for " + notif.getTag() + " on " + notif.getLocation();
      queue.add(notif);
    }
  }
  
  public void filterObjectMove(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      if (notif.getTag().equals("dog") || notif.getTag().equals("cat")) {
        notif.ttsText = "Pet moving to " + notif.getLocation();
        queue.add(notif);
      }
    }
  }
  
  public void filterPersonMove(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      notif.ttsText = notif.getTag() + " in " + notif.getLocation();
      queue.add(notif);
    }
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        filterDoor(notif);
        break;
      case ApplianceStateChange:
        filterApplianceStateChange(notif);
        break;
      case Message:
        filterMessage(notif);
        break;
      case PackageDelivery:
        filterDelivery(notif);
        break;
      case ObjectMove:
        filterObjectMove(notif);
        break;
      case PersonMove:
        filterPersonMove(notif);
        break;
      default:
        break;
    }
  }
}
