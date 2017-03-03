with Ada.Text_IO;
package body devices is

  procedure deviceError (DEVICE: in integer) is
  begin
    case DEVICE is
      when 15 => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 1, program will exit...");
      when 1 => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 2, program will exit...");
      when 2 => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 3, program will exit...");
      when 3 => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 4, program will exit...");
      when 11 => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 1, program will exit...");
      when 12 => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 2, program will exit...");
      when 13 => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 3, program will exit...");
      when 14 => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 4, program will exit...");
      when 21 => Ada.Text_IO.Put_Line ("Error loading servomotor number 1, program will exit...");
      when 22 => Ada.Text_IO.Put_Line ("Error loading servomotor number 2, program will exit...");
      when 23 => Ada.Text_IO.Put_Line ("Error loading servomotor number 3, program will exit...");
      when others => null;
    end case;
  end;
end devices;
