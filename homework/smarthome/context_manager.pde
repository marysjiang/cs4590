import java.util.*;

ContextManager DINNER_AT_HOME = new DinnerAtHomeManager();
ContextManager PARENT_NIGHT_OUT = new ParentNightOutManager();
ContextManager PARTY = new PartyManager();
ContextManager WORK_AT_HOME = new WorkAtHomeManager();
  
ContextManager getContext(int type) {
  switch (type) {
    case 0:
      return DINNER_AT_HOME;
    case 1:
      return PARENT_NIGHT_OUT;
    case 2:
      return PARTY;
    case 3:
      return WORK_AT_HOME;
    default:
      throw new RuntimeException("Unavailable");
  }
}

abstract class ContextManager {
  public abstract SamplePlayer filterMessage(Notification notif);
  public abstract SamplePlayer filterApplianceStateChange(Notification notif);
  public abstract SamplePlayer filterDoor(Notification notif);
  public abstract SamplePlayer filterDelivery(Notification notif);
  
}

class DinnerAtHomeManager extends ContextManager {
}

class ParentNightOutManager extends ContextManager {
}

class PartyManager extends ContextManager {
}

class WorkAtHomeManager extends ContextManager {
}
