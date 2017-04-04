package body add is

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

Protected body MovementsObj is

  procedure InitMovements is
  begin
    Open (File => Input_File, Mode => In_File, Name => "etc/USR01Param.tr");
    Ada.Text_IO.Put_Line ("Loading Movements List...");
    for I in 1..81 loop
      for J in 1..14 loop
        Ada.Long_Float_Text_IO.Get (File => Input_File, Item => voltaje);
        Movements_List(I).Movement_Trace(J) := voltaje;
      end loop;
        --Ada.Text_IO.Put("Movement " & Integer'image(I) & " ");
      --for J in 1..14 loop
        --Ada.Text_IO.put(" " & Long_Float'image(Movements_List(I).Movement_Trace(J)));
      --end loop;
        --Ada.Text_IO.put_line(" ");
    end loop;
  Close (File => Input_File); 


  end InitMovements;

  function MatchMovement (Mov: Trace) return Integer is
    I : Integer;
  begin
    I := 1;
    for I in 1..81 loop
        -- Ada.Text_IO.put_line("Comparing " & Long_Float'image(Mov(1)) & " with " & Long_Float'image(Movements_List(I).Movement_Trace(1)));
       if (abs(Mov(1) - Movements_List(I).Movement_Trace(1)) < Long_Float(0.0001)) AND
          (abs(Mov(2) - Movements_List(I).Movement_Trace(2)) < Long_Float(0.0001)) AND
          (abs(Mov(3) - Movements_List(I).Movement_Trace(3)) < Long_Float(0.0001)) AND
          (abs(Mov(4) - Movements_List(I).Movement_Trace(4)) < Long_Float(0.0001)) AND
          (abs(Mov(5) - Movements_List(I).Movement_Trace(5)) < Long_Float(0.0001)) AND
          (abs(Mov(6) - Movements_List(I).Movement_Trace(6)) < Long_Float(0.0001)) AND
          (abs(Mov(7) - Movements_List(I).Movement_Trace(7)) < Long_Float(0.0001)) AND
          (abs(Mov(8) - Movements_List(I).Movement_Trace(8)) < Long_Float(0.0001)) AND
          (abs(Mov(9) - Movements_List(I).Movement_Trace(9)) < Long_Float(0.0001)) AND
          (abs(Mov(10) - Movements_List(I).Movement_Trace(10)) < Long_Float(0.0001)) AND
          (abs(Mov(11) - Movements_List(I).Movement_Trace(11)) < Long_Float(0.0001)) AND
          (abs(Mov(12) - Movements_List(I).Movement_Trace(12)) < Long_Float(0.0001)) AND
          (abs(Mov(13) - Movements_List(I).Movement_Trace(13)) < Long_Float(0.0001)) AND
          (abs(Mov(14) - Movements_List(I).Movement_Trace(14)) < Long_Float(0.0001)) then
          Ada.Text_IO.put_line("Movement " & Integer'Image(I));
         return I;
       end if;
    end loop;
    return 90;
  end MatchMovement;

end MovementsObj;

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
  Periodo   : Duration := Duration(1.5);
  Current_M : Trace;
  V1        : Float;
  V2        : Float;
  V3        : Float;
  V4        : Float;
  V5        : Float;
  V6        : Float;
  V7        : Float;
  V8        : Float;
  V9        : Float;
  V10       : Float;
  V11       : Float;
  V12       : Float;
  V13       : Float;
  V14       : Float;
  Current_T : Control_Object;
  Line      : Integer;

begin
  Next_Time := Big_Bang + To_Time_Span(Periodo);

  MovementsObj.InitMovements;

  Line := 0;
  loop
    PrintTime;

    Ada.Text_IO.Put_Line ("Reading new movement...");
    ReadLibTrace (Line, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14);
    --Ada.Text_IO.Put_Line(Float'Image(V1));
    
    Current_M(1) := Long_Float(V1);
    Current_M(2) := Long_Float(V2);
    Current_M(3) := Long_Float(V3);
    Current_M(4) := Long_Float(V4);
    Current_M(5) := Long_Float(V5);
    Current_M(6) := Long_Float(V6);
    Current_M(7) := Long_Float(V7);
    Current_M(8) := Long_Float(V8);
    Current_M(9) := Long_Float(V9);
    Current_M(10) := Long_Float(V10);
    Current_M(11) := Long_Float(V11);
    Current_M(12) := Long_Float(V12);
    Current_M(13) := Long_Float(V13);
    Current_M(14) := Long_Float(V14);
    
    --for I in 1..14 loop
      --Ada.Text_IO.put(" " & Long_Float'image(Current_M(I)));
    --end loop;
    --Ada.Text_IO.Put_Line(" ");

    Ada.Text_IO.Put_Line ("Matching movement...");
    case MovementsObj.MatchMovement (Current_M) is
      when 1 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 2 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 3 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 4 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 5 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 6 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 7 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 8 =>
        Current_T(0) :=  0;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 9 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 10 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 11 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 12 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 13 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 14 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 15 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 16 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 17 =>
        Current_T(0) :=  0;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 18 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 19 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 20 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 21 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 22 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 23 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 24 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 25 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 26 =>
        Current_T(0) :=  0;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 27 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 28 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 29 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 30 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 31 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 32 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 33 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 34 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 35 =>
        Current_T(0) :=  1;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 36 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 37 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 38 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 39 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 40 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 41 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 42 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 43 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 44 =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 45 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 46 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 47 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 48 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 49 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 50 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 51 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 52 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 53 =>
        Current_T(0) :=  1;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 54 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 55 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 56 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 57 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 58 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 59 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 60 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 61 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 62 =>
        Current_T(0) :=  2;
        Current_T(1) :=  0;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 63 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 64 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 65 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 66 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 67 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 68 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 69 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 70 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 71 =>
        Current_T(0) :=  2;
        Current_T(1) :=  1;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when 72 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  0;
      when 73 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  1;
      when 74 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  0;
        Current_t(3) :=  2;
      when 75 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  0;
      when 76 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
      when 77 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  1;
        Current_t(3) :=  2;
      when 78 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  0;
      when 79 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  1;
      when 80 =>
        Current_T(0) :=  2;
        Current_T(1) :=  2;
        Current_T(2) :=  2;
        Current_t(3) :=  2;
      when others =>
        Current_T(0) :=  1;
        Current_T(1) :=  1;
        Current_T(2) :=  1;
        Current_t(3) :=  1;
    end case;

    ControlObj.SetControl (Current_T);
    Ada.Text_IO.Put_Line (" ------ Trace:" & Control_Value'image(Current_T(0)) & Control_Value'image(Current_T(1)) & Control_Value'image(Current_T(2)) & Control_Value'image(Current_T(3)));

    PrintTime;
    Ada.Text_IO.Put_Line ("Movement read!!!");
    delay until Next_Time;
    Next_Time := Next_Time + To_Time_Span(Periodo);
    Line := Line + 1;
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
        if Last_Control(1) = 1 then 
          Current_Control(1) := 2;
        else 
          if Current_Control(1) = 0 then
            Current_Control(1) := 2;
          else
            Current_Control(1) := 0;
          end if;
        end if;
      end if;

    end if;

    if Current_TB > MAX_TEMP AND PresFlag = 1 then

      if Current_TB > LAST_TB then
        if Last_Control(2) = 1 then 
          Current_Control(2) := 2;
        else 
          if Current_Control(2) = 0 then
            Current_Control(2) := 2;
          else
            Current_Control(2) := 0;
          end if;
        end if;
      end if;

    end if;

    --Se establece el voltaje a cada motor

    if Current_Control(0) = Control_Value(0) and Current_Trace(0) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(0)  := Current_Trace(0) - Engine_Value(1);
    elsif Current_Control(0) = Control_Value(2) and Current_Trace(0) < Engine_Value(MAX_ENGINE) then
      Current_Trace(0)  := Current_Trace(0) + Engine_Value(1);
    end if;

    if Current_Control(1) = Control_Value(0) and Current_Trace(1) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(1)  := Current_Trace(1) - Engine_Value(1);
    elsif Current_Control(1) = Control_Value(2) and Current_Trace(1) < Engine_Value(MAX_ENGINE) then
      Current_Trace(1)  := Current_Trace(1) + Engine_Value(1);
    end if;

    if Current_Control(2) = Control_Value(0) and Current_Trace(2) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(2)  := Current_Trace(2) - Engine_Value(1);
    elsif Current_Control(2) = Control_Value(2) and Current_Trace(2) < Engine_Value(MAX_ENGINE) then
      Current_Trace(2)  := Current_Trace(2) + Engine_Value(1);
    end if;

    if Current_Control(3) = Control_Value(0) and Current_Trace(3) > Engine_Value(MIN_ENGINE+1) then
      Current_Trace(3)  := Current_Trace(3) - Engine_Value(1);
    elsif Current_Control(3) = Control_Value(2) and Current_Trace(3) < Engine_Value(MAX_ENGINE) then
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
