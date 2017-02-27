with Ada.Text_IO;
with devices; use  devices;

procedure main is

  ProgramName    : String := "MindArm";
  ProgramVersion : String := "1.0";

  function LoadHardwareLibs return integer;
  Pragma Import (C, LoadHardwareLibs, "loadDevices");

  procedure GetTemp (result : in integer ; decive : out integer);
  Pragma Import (C, PrintTemp, "getTemperature");

  loadResoult : integer;
  temp : double;

begin

  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("Application " & ProgramName & " V " & ProgramVersion & "loaded!!"  );
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");

  loadResoult := LoadHardwareLibs;
  if loadResoult > 0 then
    deviceError(loadResoult);
  else if loadResoult < 0 then
    Ada.Text_IO.Put_Line ("ERROR configurating the Raspberry!!");
  else
    Ada.Text_IO.Put_Line ("Devices started correctly!!");
    temp = GetTemp(0);
    Ada.Text_IO.Put_Line ("Temperature of sensor 0 = " & temp);
  end if;

end main;
