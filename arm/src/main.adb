with Ada.Text_IO;
with devices; use  devices;

procedure main is

  ProgramName    : String := "MindArm";
  ProgramVersion : String := "1.0";

  function LoadHardwareLibs return integer;
  Pragma Import (C, LoadHardwareLibs, "loadDevices");

  procedure GetTemp (result : in integer ; device : out float);
  Pragma Import (C, GetTemp, "getTemperature");

  loadResoult : integer;
  temp : float;

begin

  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("Application " & ProgramName & " V " & ProgramVersion & "loaded!!"  );
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");

  loadResoult := LoadHardwareLibs;
  if loadResoult > 0 then
    deviceError(loadResoult);
  elsif loadResoult < 0 then
    Ada.Text_IO.Put_Line ("ERROR configurating the Raspberry!!");
  else
    Ada.Text_IO.Put_Line ("Devices started correctly!!");
    GetTemp(0, temp);
    Ada.Text_IO.Put_Line ("Temperature of sensor 0 = " & float'image(temp) & " ºC ");
  end if;

end main;
