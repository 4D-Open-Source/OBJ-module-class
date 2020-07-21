//%attributes = {}
/*  __readMe ()
 Created by: Kirk as Designer, Created: 07/17/20, 13:03:15
 ------------------
 Purpose: 

*/


C_OBJECT:C1216($o)
C_TEXT:C284($path;$key;$valueKey)
C_LONGINT:C283($i;$indx)
//$o:=New object("a";New collection(New collection(New object("value";1234))))
//$o.a[0][0].value:=666


//$o:=New object("a";New collection(111;New collection))
//$o.a[1][2]:=666




$path:="a[3].b[1].c"

var $value
$value:=12345

var $temp_c : Collection
$temp_c:=Split string:C1554($path;".")

$valueKey:=$temp_c[$temp_c.length-1]
$temp_c:=$temp_c.slice(0;$temp_c.length-1)


$src:=New object:C1471("a";New collection:C1472(\
1;2;3;New object:C1471(\
"b";New collection:C1472(Null:C1517;New object:C1471("c";0)))))

ARRAY LONGINT:C221($aPos;0)
ARRAY LONGINT:C221($aLen;0)
var $subObj,$src
$subObj:=Null:C1517


For ($i;0;$temp_c.length-1)
	$key:=$temp_c[$i]
	
	//  is this a collection
	If (Match regex:C1019("([\\w\\$]+)\\[(\\d+)\\]";$key;1;$aPos;$aLen))
		$indx:=Num:C11(Substring:C12($key;$aPos{2};$aLen{2}))
		$key:=Substring:C12($key;$aPos{1};$aLen{1})
	Else 
		$indx:=-1
	End if 
	
	
	
	Case of 
		: ($i=0) & ($indx=-1)
			If ($src[$key]=Null:C1517)
				$src[$key]:=New object:C1471()
			End if 
			$subObj:=$src[$key]
			
		: ($i=0)  // a collection
			Case of 
				: ($src[$key]=Null:C1517)
					$src[$key]:=New collection:C1472()
				: (Value type:C1509($src[$key])#Is collection:K8:32)
					$src[$key]:=New collection:C1472()
			End case 
			
			Case of 
				: ($src[$key].length<$indx)
					$src[$key][$indx]:=New object:C1471()
				: (Value type:C1509($src[$key][$indx])#Is collection:K8:32) & (Value type:C1509($src[$key][$indx])#Is object:K8:27)
					$src[$key][$indx]:=New object:C1471()
			End case 
			
			$subObj:=$src[$key][$indx]
			
		: ($indx=-1)
			If ($subObj[$key]=Null:C1517)
				$subObj[$key]:=New object:C1471()
			End if 
			$subObj:=$subObj[$key]  //  tricky
			
		Else 
			If ($subObj[$key]=Null:C1517)
				$subObj[$key]:=New collection:C1472()
			End if 
			
			If ($subObj[$key].length<$indx)
				$subObj[$key][$indx]:=New object:C1471()
			End if 
			$subObj:=$subObj[$key][$indx]
			
	End case 
	
End for 

//  set the value
//  is this a collection
If (Match regex:C1019("([\\w\\$]+)\\[(\\d+)\\]";$valueKey;1;$aPos;$aLen))
	$indx:=Num:C11(Substring:C12($valueKey;$aPos{2};$aLen{2}))
	$valueKey:=Substring:C12($valueKey;$aPos{1};$aLen{1})
Else 
	$indx:=-1
End if 

$subObj[$valueKey]:=$value




