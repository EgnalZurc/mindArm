with Ada.Text_IO; use Ada.Text_IO;
with Ada.Long_Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Calendar; 
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones; use Ada.Calendar.Time_Zones;

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

PRESA:      constant PIN := 7;

SERVA:      constant PIN := 4;
SERVB:      constant PIN := 1;
SERVC:      constant PIN := 5;
SERVD:      constant PIN := 6;

LEDTEMPA:   constant PIN := 2;
LEDTEMPB:   constant PIN := 3;

LEDPRESA:   constant PIN := 0;
LEDPRESB:   constant PIN := 0;
LEDPRESC:   constant PIN := 0;
LEDPRESD:   constant PIN := 0;


-- Objets values
type Temp_Value is new integer range -50..125; -- -50ºC a 125º

type Pres_Value is new integer range 0..1;
type Led_Value is new integer range 0..1;

-- Maximum values
MAX_TEMP:   constant Temp_Value   := Temp_Value(80);
MAX_PRES:   constant Pres_Value   := Pres_Value(1);

-- Time values
Big_Bang : constant Ada.Real_Time.Time := Ada.Real_Time.Clock;

-----------------------------------------------------------------------
------------- Trace Objects
----------------------------------------------------------------------- 

MAX_ENGINE: constant Integer := 18;
MIN_ENGINE: constant Integer := 0;
Number_Engines: constant integer := 4;

type Engine_Value is new integer range MIN_ENGINE..MAX_ENGINE;
type Trace_Object is array (0 .. Number_Engines) of Engine_Value;

type Control_Value is new integer range 0..2;
type Control_Object is array (0 .. Number_Engines) of Control_Value;

type Trace is array (1..18) of Long_Float;

type Movement is
     record
        Movement_Trace    : Trace;
     end record;

type Movement_List is array (1..81) of Movement;

-----------------------------------------------------------------------
------------- Hardware Tasks
-----------------------------------------------------------------------   

function ReadTempSensor (temp : SPIPIN) return Temp_Value;
function ReadPresSensor (pres : PIN) return Pres_Value;
Pragma Import (C, ReadTempSensor, "readTemp");
Pragma Import (C, ReadPresSensor, "readPres");

procedure ReadTrace (Current_Movement : out Trace);
Pragma Import (C, ReadTrace, "readTrace");
procedure ReadLibTrace (Line : in Integer; V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14 : out Float);
Pragma Import (C, ReadLibTrace, "readLibTrace");

procedure WriteLed (led : in PIN; str : in Led_Value);
procedure WriteServo (serv : in PIN; str : in Engine_Value);
Pragma Import (C, WriteLed, "writeLed");
Pragma Import (C, WriteServo, "writeServo");

procedure PrintTime;
Pragma Import (C, PrintTime, "printTime");

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

-----------------------------------------------------------------------
Protected MovementsObj is
pragma Priority (MAX);
procedure InitMovements;
function MatchMovement (Mov: Trace) return Integer;
private
  Movements_List: Movement_List;
  Input_File    : File_Type;
  voltaje       : Long_Float;
end MovementsObj;

Protected ControlObj is
pragma Priority (MAX);
function GetControl return Control_Object;
procedure SetControl (CtrlOb: Control_Object);
private
  CtrlObj: Control_Object;
end ControlObj;

end add;
