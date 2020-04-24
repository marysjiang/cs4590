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
      notif.ttsText = "Message to " + notif.getTag() + notif.getNote();
      notif.soundFile = null;
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
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote();
      notif.soundFile = null;
      queue.add(notif);
    } else if (notif.getPriorityLevel() == 2) {
      notif.soundFile = getSamplePlayer("stove.wav");
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
      notif.soundFile = getSamplePlayer("doorbell.wav");
      notif.ttsText = null;
      //notif.ttsText = "Delivery for " + notif.getTag();
      queue.add(notif);
    }
    
    println("queue " + queue);
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        println("door type");
        filterDoor(notif);
        break;
      case ApplianceStateChange:
        println("appliance type");
        filterApplianceStateChange(notif);
        break;
      case Message:
        println("message type");
        filterMessage(notif);
        break;
      case PackageDelivery:
        println("package delivery type");
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
      notif.ttsText = "Message to " + notif.getTag() + notif.getNote();
      queue.add(notif);
    } else if (notif.getPriorityLevel() <= 2) {
      notif.soundFile = getSamplePlayer("message.wav");
      queue.add(notif);
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote();
      queue.add(notif);
    } else if (notif.getPriorityLevel() <= 2) {
      notif.soundFile = getSamplePlayer("stove.wav");
      queue.add(notif);
    }
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() <= 1) {
      notif.soundFile = getSamplePlayer("door.wav");
      queue.add(notif);
    }
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.soundFile = getSamplePlayer("doorbell.wav");
      //notif.ttsText = "Package at the " + notif.getLocation();
      queue.add(notif);
    }
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        println("door type");
        filterDoor(notif);
      case ApplianceStateChange:
        println("appliance type");
        filterApplianceStateChange(notif);
      case Message:
        println("message type");
        filterMessage(notif);
      case PackageDelivery:
        println("package delivery type");
        filterDelivery(notif);
      default:
        break;
    }
  }
}

class PartyFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() <= 1) {
      notif.ttsText = "Message received";
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote();
      queue.add(notif);
    }
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() <= 1) {
      notif.soundFile = getSamplePlayer("door.wav");
      queue.add(notif);
    }
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.soundFile = getSamplePlayer("doorbell.wav");
      //notif.ttsText = "Delivery at the " + notif.getLocation();
      queue.add(notif);
    }
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        println("door type");
        filterDoor(notif);
      case ApplianceStateChange:
        println("appliance type");
        filterApplianceStateChange(notif);
      case Message:
        println("message type");
        filterMessage(notif);
      case PackageDelivery:
        println("package delivery type");
        filterDelivery(notif);
      default:
        break;
    }
  }
}

class WorkAtHomeFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = "Message to " + notif.getTag() + notif.getNote();
      queue.add(notif);
    } else if (notif.getPriorityLevel() <= 2) {
      notif.soundFile = getSamplePlayer("message.wav");
      queue.add(notif);
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.ttsText = notif.getTag() + " has an error " + notif.getNote();
      queue.add(notif);
    } else if (notif.getPriorityLevel() == 2) {
      notif.soundFile = getSamplePlayer("stove.wav");
      queue.add(notif);
    }
  }
  
  public void filterDoor(Notification notif) {
    if (notif.getPriorityLevel() <= 1) {
      notif.soundFile = getSamplePlayer("door.wav");
      queue.add(notif);
    }
  }
  
  public void filterDelivery(Notification notif) {
    if (notif.getPriorityLevel() == 1) {
      notif.soundFile = getSamplePlayer("doorbell.wav");
      //notif.ttsText = "Delivery at the " + notif.getLocation();
      queue.add(notif);
    }
  }
  
  public void filterNotification(Notification notif) {
    NotificationType type = notif.getType();
    
    switch (type) {
      case Door:
        println("door type");
        filterDoor(notif);
      case ApplianceStateChange:
        println("appliance type");
        filterApplianceStateChange(notif);
      case Message:
        println("message type");
        filterMessage(notif);
      case PackageDelivery:
        println("package delivery type");
        filterDelivery(notif);
      default:
        break;
    }
  }
}
