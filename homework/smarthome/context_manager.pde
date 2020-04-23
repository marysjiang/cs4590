import java.util.*;

abstract class Context {
  public abstract void filterMessage(Notification notif);
  public abstract void filterApplianceStateChange(Notification notif);
  public abstract void filterDoor(Notification notif);
  public abstract void filterDelivery(Notification notif);
  
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

class DinnerAtHomeFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      ttsExamplePlayback("hello");
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
  }
  
  public void filterDoor(Notification notif) {
  }
  
  public void filterDelivery(Notification notif) {
  }
}

class ParentNightOutFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      ttsExamplePlayback("hello");
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
  }
  
  public void filterDoor(Notification notif) {
  }
  
  public void filterDelivery(Notification notif) {
  }
}

class PartyFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      ttsExamplePlayback("hello");
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
  }
  
  public void filterDoor(Notification notif) {
  }
  
  public void filterDelivery(Notification notif) {
  }
}

class WorkAtHomeFilter extends Context {
  public void filterMessage(Notification notif) {
    if (notif.getPriorityLevel() <= 2) {
      ttsExamplePlayback("hello");
    }
  }
  
  public void filterApplianceStateChange(Notification notif) {
  }
  
  public void filterDoor(Notification notif) {
  }
  
  public void filterDelivery(Notification notif) {
  }
}
