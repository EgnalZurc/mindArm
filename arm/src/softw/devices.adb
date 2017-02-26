with Ada.Text_IO;

procedure main is:

  TEMPA   : integer :=  1;
  TEMPB   : integer :=  2;
  TEMPC   : integer :=  3;
  TEMPD   : integer :=  4;
  PRESA   : integer :=  11:
  PRESB   : integer :=  12;
  PRESC   : integer :=  13;
  PRESD   : integer :=  14;
  SERVA   : integer :=  21;
  SERVB   : integer :=  22;
  SERVC   : integer :=  23;

  procedure deviceError (DEVICE : in integer) is
  begin
    case DEVICE is
      when TEMPA => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 1, program will exit...");
      when TEMPB => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 2, program will exit...");
      when TEMPC => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 3, program will exit...");
      when TEMPD => Ada.Text_IO.Put_Line ("Error loading temperature sensor number 4, program will exit...");
      when PRESA => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 1, program will exit...");
      when PRESB => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 2, program will exit...");
      when PRESC => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 3, program will exit...");
      when PRESD => Ada.Text_IO.Put_Line ("Error loading pressure sensor number 4, program will exit...");
      when SERVA => Ada.Text_IO.Put_Line ("Error loading servomotor number 1, program will exit...");
      when SERVB => Ada.Text_IO.Put_Line ("Error loading servomotor number 2, program will exit...");
      when SERVc => Ada.Text_IO.Put_Line ("Error loading servomotor number 3, program will exit...");
    end case;
  end;

begin
  NULL;
end main;
