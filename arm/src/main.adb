with Ada.Text_IO;
with devices; use  devices;

procedure main is

  ProgramName    : String := "MindArm";
  ProgramVersion : String := "1.0";

  type PIN is new integer range 0 .. 29;
  type SPIPIN is new integer range 0 .. 7;

  procedure LoadServoMotors (serv : in PIN; returnCode: out integer);
  Pragma Import (C, LoadServoMotors, "loadServoMotor");

  procedure LoadTemperature (serv : in SPIPIN; returnCode: out integer);
  Pragma Import (C, LoadTemperature, "loadTemperature");

  loadResoult : integer;

  SERVA       : PIN := 1;
  SERVB       : PIN := 16;
  SERVC       : PIN := 17;
  TMPA        : SPIPIN := 0;
  TMPB        : SPIPIN := 1;

begin

  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("Application " & ProgramName & " V " & ProgramVersion & "loaded!!"  );
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");

  -- Servo Motors
  LoadServoMotors(SERVA, loadResoult) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Servo motor A loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading servo motor A");
  end if;
  LoadServoMotors(SERVB, loadResoult) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Servo motor B loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading servo motor B");
  end if;
  LoadServoMotors(SERVC, loadResoult) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Servo motor C loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading servo motor C");
  end if;

  -- Temperature
  LoadTemperature(TMPA, loadResoult) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Temperature sensor A loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading temperature sensor A");
  end if;
  LoadTemperature(TMPB, loadResoult) ;
  if loadResoult = 0 then
    Ada.Text_IO.Put_Line ("Temperature sensor B loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading temperature sensor B");
  end if;

end main;
