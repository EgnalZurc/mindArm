package body add is

-----------------------------------------------------------------------
------------- Support task
-----------------------------------------------------------------------

procedure Time_of_Day is

  type DayInteger is range 0..86400;

  CurrentTime      : Ada.Calendar.Time;
  SecsPastMidnight : DayInteger;
  MinsPastMidnight : Natural;
  Secs             : Natural;
  Mins             : Natural;
  Hrs              : Natural;

begin

  CurrentTime := Ada.Calendar.Clock;

  SecsPastMidnight := DayInteger(Ada.Calendar.Seconds(CurrentTime));
  MinsPastMidnight := Natural(SecsPastMidnight/60);
  Secs             := Natural(SecsPastMidnight REM 60);
  Mins             := MinsPastMidnight REM 60;
  Hrs              := MinsPastMidnight / 60;

  --Put (Trim(integer'image(Hrs), Ada.Strings.Left) & ":");

  --if Mins < 10 then
  --  Put ("0");
  --end if;
  --Put (Trim(integer'image(Mins), Ada.Strings.Left) & ":");

  --if Secs < 10 then
  --  Put ("0");
  --end if;
  --Put (Trim(integer'image(Secs), Ada.Strings.Left) & "  ");

   Put(Image(Date => Ada.Calendar.Clock, Time_Zone => Ada.Calendar.Time_Zones.UTC_Time_Offset) & "  ");

end Time_of_Day;

-----------------------------------------------------------------------
------------- Protected Objects Bodies
-----------------------------------------------------------------------

Protected body TempAObj is

  function GetTemp return Temp_Value is
  begin
    return Temp;
  end GetTemp;

  procedure SetTemp (Tem : Temp_Value) is
  begin
    Temp := Tem;
  end SetTemp ;

end TempAObj;
Protected body TempBObj is

  function GetTemp return Temp_Value is
  begin
    return Temp;
  end GetTemp;

  procedure SetTemp (Tem : Temp_Value) is
  begin
    Temp := Tem;
  end SetTemp ;

end TempBObj;

-----------------------------------------------------------------------
Protected body PresAObj is

  function GetPres return Pres_Value is
  begin
    return Presion;
  end GetPres;
  
  procedure SetPresion (Pres : Pres_Value) is
  begin
    Presion := Pres;
  end SetPresion;

end PresAObj;

-----------------------------------------------------------------------
Protected body ControlObj is

  function GetControl return Control_Object is
  begin
    return CtrlObj;
  end GetControl;
  
  procedure SetControl (CtrlOb: Control_Object) is
  begin
    CtrlObj := CtrlOb;
  end SetControl ;

end ControlObj;


-----------------------------------------------------------------------
------------- Periodic Tasks
-----------------------------------------------------------------------

Task body UpdateTempSensor is
  Next_Time : Time;
  Periodo : Duration := Duration(5);
  Current_T: Temp_Value;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    PrintTime;
    Ada.Text_IO.Put_Line ("Measuring Temperature...");

    Current_T := ReadTempSensor (TEMPA);
    TempAObj.SetTemp (Current_T);
    Ada.Text_IO.Put_Line (" ------ Temperature sensor" & SPIPIN'image(TEMPA) & ":" & Temp_Value'image(Current_T));
    Current_T := ReadTempSensor (TEMPB);
    TempBObj.SetTemp (Current_T);
    Ada.Text_IO.Put_Line (" ------ Temperature sensor" & SPIPIN'image(TEMPB) & ":" & Temp_Value'image(Current_T));

    PrintTime;
    Ada.Text_IO.Put_Line ("Temperature Measured!!!");
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end UpdateTempSensor;

---------------------------------------------------------------------
Task body UpdatePresSensor is
  Next_Time : Time;
  Periodo : Duration := Duration(5);
  Current_P: Pres_Value;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    PrintTime;
    Ada.Text_IO.Put_Line ("Measuring Pressure...");

    Current_P := ReadPresSensor (PRESA);
    PresAObj.SetPresion (Current_P);
    Ada.Text_IO.Put_Line (" ------ Pressure sensor" & PIN'image(PRESA) & ":" & Pres_Value'image(Current_P));

    PrintTime;
    Ada.Text_IO.Put_Line ("Pressure Measured!!!");
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end UpdatePresSensor;

-----------------------------------------------------------------------
Task body UpdateTrace is
  Next_Time : Time;
  Periodo : Duration := Duration(1.5);
  Current_SA: Control_Value;
  Current_SB: Control_Value;
  Current_SC: Control_Value;
  Current_SD: Control_Value;
  Current_T : Control_Object;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    PrintTime;
    Ada.Text_IO.Put_Line ("Reading new movement...");

    ReadTrace (Current_SA, Current_SB, Current_SC, Current_SD);
    Current_T(0) := Control_Value(Current_SA);
    Current_T(1) := Control_Value(Current_SB);
    Current_T(2) := Control_Value(Current_SC);
    Current_T(3) := Control_Value(Current_SD);
    ControlObj.SetControl (Current_T);
    Ada.Text_IO.Put_Line (" ------ Trace:" & Control_Value'image(Current_T(0)) & Control_Value'image(Current_T(1)) & Control_Value'image(Current_T(2)) & Control_Value'image(Current_T(3)));

    PrintTime;
    Ada.Text_IO.Put_Line ("Movement read!!!");
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end UpdateTrace;

-----------------------------------------------------------------------
Task body Display is
  Next_Time : Time;
  Periodo   : Duration := Duration(5);
  Current_T : Temp_Value;
  Current_P : Pres_Value;
  Led_TempA : integer := 0;
  Led_TempB : integer := 0;
  Led_PresA : integer := 0;
  Led_PresB : integer := 0;
  Led_PresC : integer := 0;
  Led_PresD : integer := 0;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    PrintTime;
    Ada.Text_IO.Put_Line ("Updating Display...");

    --Se enciende warning si detecta más de 80º
    Current_T := TempAObj.GetTemp;
    if Current_T > MAX_TEMP then
      if Led_TempA = 0 then
        Led_TempA := 1;
        WriteLed(LEDTEMPA, 1);
        Ada.Text_IO.Put_Line (" ------ Temperature LED" & PIN'image(LEDTEMPA) & " ON");
      end if;
    else
      if Led_TempA = 1 then
        Led_TempA := 0;
        WriteLed(LEDTEMPA, 0);
        Ada.Text_IO.Put_Line (" ------ Temperature LED" & PIN'image(LEDTEMPA) & " OFF");
      end if;
    end if;

    Current_T := TempBObj.GetTemp;
    if Current_T > MAX_TEMP then
      if Led_TempB = 0 then
        Led_TempB := 1;
        WriteLed(LEDTEMPB, 1);
        Ada.Text_IO.Put_Line (" ------ Temperature LED" & PIN'image(LEDTEMPB) & " ON");
      end if;
    else
      if Led_TempB = 1 then
        Led_TempB := 0;
        WriteLed(LEDTEMPB, 0);
        Ada.Text_IO.Put_Line (" ------ Temperature LED" & PIN'image(LEDTEMPB) & " OFF");
      end if;
    end if;

    --Se enciende warning si detecta demasiada presión
    Current_P := 0;
    Current_P := Current_P + PresAObj.GetPres;
    if Current_P >= MAX_PRES then
      if Led_PresA = 0 then
        Led_PresA := 1;
        WriteLed(LEDPRESA, 1);
        Ada.Text_IO.Put_Line (" ------ Pressure LED" & PIN'image(LEDPRESA) & " ON");
      end if;
    else 
      if Led_PresA = 1 then
        Led_PresA := 0;
        WriteLed(LEDPRESA, 0);
        Ada.Text_IO.Put_Line (" ------ Pressure LED" & PIN'image(LEDPRESA) & " OFF");
      end if;
    end if;

    PrintTime;
    Ada.Text_IO.Put_Line ("Display Updated!!!");
  delay until Next_Time;
  Next_Time := Next_Time + To_Time_Span(Periodo);
end loop;
end Display;

-----------------------------------------------------------------------
Task body Control is
  Next_Time : Time;
  Periodo   : Duration := 1.0;
  PresFlag  : Integer := 0;

  Current_Control : Control_Object;
  Last_Control    : Control_Object;
  Current_Trace   : Trace_Object;

  Current_TA      : Temp_Value;
  Current_TB      : Temp_Value;
  Last_TA         : Temp_Value;
  Last_TB         : Temp_Value;

  Current_PA      : Pres_Value;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  Last_TA := Temp_Value(0);
  Last_TB := Temp_Value(0);
  Current_Trace(0)  := 9;
  Current_Trace(1)  := 9;
  Current_Trace(2)  := 9;
  Current_Trace(3)  := 9;
  Last_Control(0)   := 0;
  Last_Control(1)   := 0;
  Last_Control(2)   := 0;
  Last_Control(3)   := 0;
  loop
    PrintTime;
    Ada.Text_IO.Put_Line ("Updating arm position...");
    Current_Control := ControlObj.GetControl;
    Current_TA := TempAObj.GetTemp;
    Current_TB := TempBObj.GetTemp;

    Current_PA := PresAObj.GetPres;

    --Si se excede la presión y el movimiento actual hace
    --que esta siga incrementando, se invierte el movimiento
    if Current_PA >= MAX_PRES then
      PresFlag := 1;
    end if;

    --Si se excede la temperatura y el movimiento actual hace
    --que esta siga incrementando, se invierte el movimiento
    if Current_TA > MAX_TEMP AND PresFlag = 1 then

      if Current_TA > LAST_TA then
        if Last_Control(1) = 0 then 
          Current_Control(1) := 1;
        else 
          Current_Control(1) := Current_Control(1)*(-1);
        end if;
      end if;

    end if;

    if Current_TB > MAX_TEMP AND PresFlag = 1 then

      if Current_TB > LAST_TB then
        if Last_Control(2) = 0 then 
          Current_Control(2) := 1;
        else 
          Current_Control(2) := Current_Control(2)*(-1);
        end if;
      end if;

    end if;

    --Se establece el voltaje a cada motor

    if Current_Control(0) = Control_Value(-1) and Current_Trace(0) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(0)  := Current_Trace(0) - Engine_Value(1);
    elsif Current_Control(0) = Control_Value(1) and Current_Trace(0) < Engine_Value(MAX_ENGINE) then
      Current_Trace(0)  := Current_Trace(0) + Engine_Value(1);
    end if;

    if Current_Control(1) = Control_Value(-1) and Current_Trace(1) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(1)  := Current_Trace(1) - Engine_Value(1);
    elsif Current_Control(1) = Control_Value(1) and Current_Trace(1) < Engine_Value(MAX_ENGINE) then
      Current_Trace(1)  := Current_Trace(1) + Engine_Value(1);
    end if;

    if Current_Control(2) = Control_Value(-1) and Current_Trace(2) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(2)  := Current_Trace(2) - Engine_Value(1);
    elsif Current_Control(2) = Control_Value(1) and Current_Trace(2) < Engine_Value(MAX_ENGINE) then
      Current_Trace(2)  := Current_Trace(2) + Engine_Value(1);
    end if;

    if Current_Control(3) = Control_Value(-1) and Current_Trace(3) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(3)  := Current_Trace(3) - Engine_Value(1);
    elsif Current_Control(3) = Control_Value(1) and Current_Trace(3) < Engine_Value(MAX_ENGINE) then
      Current_Trace(3)  := Current_Trace(3) + Engine_Value(1);
    end if;

    WriteServo(SERVA, Current_Trace(0));
    WriteServo(SERVB, Current_Trace(1));
    WriteServo(SERVC, Current_Trace(2));
    WriteServo(SERVD, Current_Trace(3));

    Ada.Text_IO.Put_Line (" ------ New Position:" & Engine_Value'image(Current_Trace(0)) & Engine_Value'image(Current_Trace(1)) & Engine_Value'image(Current_Trace(2)) & Engine_Value'image(Current_Trace(3)));

    Last_TA := TempAObj.GetTemp;
    Last_TB := TempBObj.GetTemp;
    Last_Control := Current_Control;

    PrintTime;
    Ada.Text_IO.Put_Line ("Arm positioned!!!");
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end Control;

-----------------------------------------------------------------------
begin
  null;
end add;
