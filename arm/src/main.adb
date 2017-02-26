with Ada.Text_IO;

procedure main is:

  ProgramName    : String := "MindArm";
  ProgramVersion : String := "1.0";

  Pragma Import (C, LoadHardwareLibs, "loadComponents");

begin
  
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("Application " & ProgramName & " V " & ProgramVersion & "loaded!!"  );
  Ada.Text_IO.Put_Line (" ");
  Ada.Text_IO.Put_Line ("------------------------------------------------------------------");

  if !LoadHardwareLibs then
    Ada.Text_IO.Put_Line ("Hardware components can't be loaded, exxiting!!!");
  else
     Ada.Text_IO.Put_Line ("Hardware components loaded!! ");
  end if;

end main;

