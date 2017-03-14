with Ada.Text_IO;
with devices; use  devices;
with add; use  add;

procedure main is

  ProgramName    : String := "MindArm";
  ProgramVersion : String := "1.0";

  OK : integer :=  1;
  KO : integer := -1;

begin

  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("Application " & ProgramName & " V " & ProgramVersion & "loaded!!"  );
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");

  if LoadDevices = OK then
    Ada.Text_IO.Put_Line ("Devices loaded correctly");
  else
    Ada.Text_IO.Put_Line ("Error loading devices");
  end if;

end main;
