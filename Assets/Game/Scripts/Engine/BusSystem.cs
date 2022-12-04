using System;

public static class BusSystem 
{
    public static Action OnPlayerDead;
    public static void CallPlayerDead() { OnPlayerDead?.Invoke(); }
    
    public static Action OnEnemyKilled;
    public static void CallEnemyKilled() { OnEnemyKilled?.Invoke(); }
    
    public static Action OnBossKilled;
    public static void CallBossKilled() { OnBossKilled?.Invoke(); }
    
    public static Action OnPortalTaskDone;
    public static void CallPortalTaskDone() { OnPortalTaskDone?.Invoke(); }
    
    public static Action OnLevelTaskDone;
    public static void CallLevelTaskDone() { OnLevelTaskDone?.Invoke(); }
    
    public static Action OnBossEnterLevel;
    public static void CallBossEnterLevel() { OnBossEnterLevel?.Invoke(); }

}