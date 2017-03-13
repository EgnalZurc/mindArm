with Ada.Text_IO;
with devices; use  devices;

procedure main is

  ProgramName    : String := "MindArm";
  ProgramVersion : String := "1.0";

  type PIN is new integer range 0 .. 29;
  type SPIPIN is new integer range 0 .. 7;

  function LoadPressure (pres : PIN) return integer;
  Pragma Import (C, LoadPressure, "loadPressure");

  function LoadServoMotors (serv : PIN) return integer;
  Pragma Import (C, LoadServoMotors, "loadServoMotor");

  function LoadTemperature (temp : SPIPIN) return integer;
  Pragma Import (C, LoadTemperature, "loadTemperature");

  loadResoult : integer;

  PRESA       : PIN := 0;
  PRESB       : PIN := 2;
  PRESC       : PIN := 3;
  PRESD       : PIN := 4;
  SERVA       : PIN := 1;
  SERVB       : PIN := 24;
  SERVC       : PIN := 6;
  TMPA        : SPIPIN := 0;
  TMPB        : SPIPIN := 1;

begin

  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("Application " & ProgramName & " V " & ProgramVersion & "loaded!!"  );
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");

  -- Pressure sensor
  loadResoult := LoadPressure (PRESA);
  case loadResoult is
    when 0 =>
      Ada.Text_IO.Put_Line ("Pressure sensor A loaded correctly");
    when -2 =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor A, please, press the button");
    when others =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor A");
  end case;
  loadResoult := LoadPressure (PRESB);
  case loadResoult is
    when 0 =>
      Ada.Text_IO.Put_Line ("Pressure sensor B loaded correctly");
    when -2 =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor B, please, press the button");
    when others =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor B");
  end case;
  loadResoult := LoadPressure (PRESC);
  case loadResoult is
    when 0 =>
      Ada.Text_IO.Put_Line ("Pressure sensor C loaded correctly");
    when -2 =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor C, please, press the button");
    when others =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor C");
  end case;
  loadResoult := LoadPressure (PRESD);
  case loadResoult is
    when 0 =>
      Ada.Text_IO.Put_Line ("Pressure sensor D loaded correctly");
    when -2 =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor D, please, press the button");
    when others =>
      Ada.Text_IO.Put_Line ("Error loading pressure sensor D");
  end case;

  -- Servo Motors
  loadResoult := LoadServoMotors(SERVA) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Servo motor A loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading servo motor A");
  end if;
  loadResoult := LoadServoMotors(SERVB) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Servo motor B loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading servo motor B");
  end if;
  loadResoult := LoadServoMotors(SERVC) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Servo motor C loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading servo motor C");
  end if;

  -- Temperature
  loadResoult := LoadTemperature(TMPA) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Temperature sensor A loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading temperature sensor A");
  end if;
  loadResoult := LoadTemperature(TMPB) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Temperature sensor B loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading temperature sensor B");
  end if;

end main;
