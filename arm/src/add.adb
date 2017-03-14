with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

package body add is

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
Protected body PresBObj is

  function GetPres return Pres_Value is
  begin
    return Presion;
  end GetPres;
  
  procedure SetPresion (Pres : Pres_Value) is
  begin
    Presion := Pres;
  end SetPresion;

end PresBObj;
Protected body PresCObj is

  function GetPres return Pres_Value is
  begin
    return Presion;
  end GetPres;
  
  procedure SetPresion (Pres : Pres_Value) is
  begin
    Presion := Pres;
  end SetPresion;

end PresCObj;
Protected body PresDObj is

  function GetPres return Pres_Value is
  begin
    return Presion;
  end GetPres;
  
  procedure SetPresion (Pres : Pres_Value) is
  begin
    Presion := Pres;
  end SetPresion;

end PresDObj;

-----------------------------------------------------------------------
Protected body TraceObj is

  function GetTrace return Trace_Object is
  begin
    return Traza;
  end GetTrace;
  
  procedure SetTrace (Traz: Trace_Object) is
  begin
    Traza := Traz;
  end SetTrace ;

end TraceObj;


-----------------------------------------------------------------------
------------- Periodic Tasks
-----------------------------------------------------------------------

Task body UpdateTempSensor is
  Next_Time : Time;
  Periodo : Duration := Duration(3);
  Current_T: Temp_Value;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    Current_T := ReadTempSensor (TEMPA);
    TempAObj.SetTemp (Current_T);
    Current_T := ReadTempSensor (TEMPB);
    TempBObj.SetTemp (Current_T);
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end UpdateTempSensor;

---------------------------------------------------------------------
Task body UpdatePresSensor is
  Next_Time : Time;
  Periodo : Duration := Duration(0.7);
  Current_P: Pres_Value;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    Current_P := ReadPresSensor (PRESA);
    PresAObj.SetPresion (Current_P);
    Current_P := ReadPresSensor (PRESB);
    PresBObj.SetPresion (Current_P);
    Current_P := ReadPresSensor (PRESC);
    PresCObj.SetPresion (Current_P);
    Current_P := ReadPresSensor (PRESD);
    PresDObj.SetPresion (Current_P);
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end UpdatePresSensor;

-----------------------------------------------------------------------
Task body UpdateTrace is
  Next_Time : Time;
  Periodo : Duration := Duration(0.3);
  Current_SA: Engine_Value;
  Current_SB: Engine_Value;
  Current_SC: Engine_Value;
  Current_SD: Engine_Value;
  Current_T : Trace_Object;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    ReadTrace (Current_SA, Current_SB, Current_SC, Current_SD);
    Current_T(0) := Engine_Value(Current_SA);
    Current_T(1) := Engine_Value(Current_SB);
    Current_T(2) := Engine_Value(Current_SC);
    Current_T(3) := Engine_Value(Current_SD);
    TraceObj.SetTrace (Current_T);
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end UpdateTrace;

-----------------------------------------------------------------------
Task body Display is
  Next_Time : Time;
  Periodo   : Duration := Duration(1);
  Current_T : Temp_Value;
  Current_P : Pres_Value;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop
    --Se enciende warning si detecta más de 80º
    Current_T := TempAObj.GetTemp;
    if Current_T > MAX_TEMP then
      WriteLed(LEDTEMPA, 1);
    else 
      WriteLed(LEDTEMPA, 0);
    end if;
    Current_T := TempBObj.GetTemp;
    if Current_T > MAX_TEMP then
      WriteLed(LEDTEMPB, 1);
    else 
      WriteLed(LEDTEMPB, 0);
    end if;
    --Se enciende warning si detecta demasiada presión
    Current_P := 0;
    Current_P := Current_P + PresAObj.GetPres;
    Current_P := Current_P + PresBObj.GetPres;
    Current_P := Current_P + PresCObj.GetPres;
    Current_P := Current_P + PresDObj.GetPres;
    if Current_P > MAX_PRES then
      WriteLed(LEDPRESA, 1);
    else 
      WriteLed(LEDPRESA, 0);
    end if;

  delay until Next_Time;
  Next_Time := Next_Time + To_Time_Span(Periodo);
end loop;
end Display;

-----------------------------------------------------------------------
Task body Control is
  Next_Time : Time;
  Periodo : Duration := 0.5;

  Current_Traza: Trace_Object;

  Current_TA: Temp_Value;
  Current_TB: Temp_Value;

  Current_PA : Pres_Value ;
  Current_PB : Pres_Value ;
  Current_PC : Pres_Value ;
  Current_PD : Pres_Value ;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);
  loop

    Current_Traza := TraceObj.GetTrace;
    Current_TA := TempAObj.GetTemp;
    Current_TB := TempBObj.GetTemp;

    Current_PA := PresAObj.GetPres;
    Current_PB := PresBObj.GetPres;
    Current_PC := PresCObj.GetPres;
    Current_PD := PresDObj.GetPres;

    --Si se excede la temperatura y el movimiento actual hace
    --que esta siga incrementando, se invierte el movimiento
    if Current_TA > MAX_TEMP then

      if Current_Traza(0) = 1 then
        Current_Traza(0) := 1;
      end if;
      
    else
      --Si se excede la presión y el movimiento actual hace
      --que esta siga incrementando, se invierte el movimiento
      if Current_PA >= MAX_PRES then

        if Current_Traza(0) = 1 then
          Current_Traza(0) := 1;
        end if;

      end if;
    end if;

    --Se establece el voltaje a cada motor
    WriteServo(SERVA, Current_Traza(0));
    WriteServo(SERVB, Current_Traza(1));
    WriteServo(SERVC, Current_Traza(2));
    WriteServo(SERVD, Current_Traza(3));

    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
  end loop;
end Control;

-----------------------------------------------------------------------
begin
  null;
end add;
