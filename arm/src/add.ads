with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

package add is

-----------------------------------------------------------------------
------------- Constant variables
----------------------------------------------------------------------- 

-- Task Priority
MAX:        constant integer := 5;
CONTROLP:   constant integer := 4;
SENSORHIGH: constant integer := 3;
SENSORLOW:  constant integer := 2;
DISPLAYP:   constant integer := 1;

-- PIN numbers
type PIN is new integer range 0 .. 29;
type SPIPIN is new integer range 0 .. 7;

TEMPA:      constant SPIPIN := 0;
TEMPB:      constant SPIPIN := 1;

PRESA:      constant PIN := 11;
PRESB:      constant PIN := 12;
PRESC:      constant PIN := 13;
PRESD:      constant PIN := 14;

SERVA:      constant PIN := 0;
SERVB:      constant PIN := 1;
SERVC:      constant PIN := 2;
SERVD:      constant PIN := 3;

LEDTEMPA:   constant PIN := 4;
LEDTEMPB:   constant PIN := 5;

LEDPRESA:   constant PIN := 6;
LEDPRESB:   constant PIN := 7;
LEDPRESC:   constant PIN := 8;
LEDPRESD:   constant PIN := 9;

-- Objets values
type Temp_Value is new integer range -50..125; -- -50ºC a 125º

type Pres_Value is new integer range 0..1;
type Led_Value is new integer range 0..1;

Number_Engines: constant integer := 4;
type Engine_Value is new integer range 1..18;
type Trace_Object is array (0 .. Number_Engines) of Engine_Value;

-- Maximum values
MAX_TEMP:   constant Temp_Value := Temp_Value(80);
MAX_PRES:   constant Pres_Value := Pres_Value(1);

Big_Bang : constant Ada.Real_Time.Time := Ada.Real_Time.Clock;

-----------------------------------------------------------------------
------------- Hardware Tasks
-----------------------------------------------------------------------   

function ReadTempSensor (temp : SPIPIN) return Temp_Value;
function ReadPresSensor (pres : PIN) return Pres_Value;
Pragma Import (C, ReadTempSensor, "readTemp");
Pragma Import (C, ReadPresSensor, "readPres");

procedure ReadTrace (SA, SB, SC, SD : out Engine_Value);
Pragma Import (C, ReadTrace, "readTrace");

procedure WriteLed (led : in PIN; str : in Led_Value);
procedure WriteServo (serv : in PIN; str : in Engine_Value);
Pragma Import (C, WriteLed, "writeLed");
Pragma Import (C, WriteServo, "writeServo");


-----------------------------------------------------------------------
------------- Tasks
-----------------------------------------------------------------------   

Task UpdateTrace is
  pragma Priority (MAX);
end UpdateTrace;
Task Control is
  pragma Priority (CONTROLP);
end Control;
Task UpdatePresSensor is
  pragma Priority (SENSORLOW);
end UpdatePresSensor;
Task UpdateTempSensor is
  pragma Priority (SENSORLOW);
end UpdateTempSensor;
Task Display is
  pragma Priority (DISPLAYP);
end Display;

-----------------------------------------------------------------------
------------- Protected Objects
-----------------------------------------------------------------------
Protected TempAObj is
  pragma Priority(CONTROLP);     
  function GetTemp return Temp_Value;
  procedure SetTemp (Tem : Temp_Value);
  private
  Temp : Temp_Value;
end TempAObj ;
Protected TempBObj is
  pragma Priority(CONTROLP);     
  function GetTemp return Temp_Value;
  procedure SetTemp (Tem : Temp_Value);
  private
  Temp : Temp_Value;
end TempBObj ;

-----------------------------------------------------------------------
Protected PresAObj is
  pragma Priority(CONTROLP);
  function GetPres return Pres_Value;
  procedure SetPresion (Pres : Pres_Value);
  private
  Presion : Pres_Value;
end PresAObj ;
Protected PresBObj is
  pragma Priority(CONTROLP);
  function GetPres return Pres_Value;
  procedure SetPresion (Pres : Pres_Value);
  private
  Presion : Pres_Value;
end PresBObj ;
Protected PresCObj is
  pragma Priority(CONTROLP);
  function GetPres return Pres_Value;
  procedure SetPresion (Pres : Pres_Value);
  private
  Presion : Pres_Value;
end PresCObj ;
Protected PresDObj is
  pragma Priority(CONTROLP);
  function GetPres return Pres_Value;
  procedure SetPresion (Pres : Pres_Value);
  private
  Presion : Pres_Value;
end PresDObj ;

-----------------------------------------------------------------------
Protected TraceObj is
  pragma Priority (MAX);
  function GetTrace return Trace_Object;
  procedure SetTrace (Traz: Trace_Object);
  private
  Traza: Trace_Object;
end TraceObj;

end add;
