with Ada.Text_IO;

package devices is

  TEMPA   : integer :=  1;
  TEMPB   : integer :=  2;
  TEMPC   : integer :=  3;
  TEMPD   : integer :=  4;
  PRESA   : integer :=  11;
  PRESB   : integer :=  12;
  PRESC   : integer :=  13;
  PRESD   : integer :=  14;
  SERVA   : integer :=  21;
  SERVB   : integer :=  22;
  SERVC   : integer :=  23;

  procedure deviceError (DEVICE: in integer);

end devices;
