/*  cOBJ ()
 Created by: Kirk as Designer, Created: 07/17/20, 12:34:32
 ------------------
 Support:    objects, collections : static or object
 No support: collections of collectons

use
$obj:=cs.cOBJ.new()
$path:="a[3].b[1].c[5]"
$value:=New object("x";12345)

$obj.setValue($o;$path;$value)  //  $o = {a:[null,null,null,{b:[null,{c:[null,null,null,null,null,{x:12345}]}]}]}
$value.y:=99999

$x:=$obj.getValue($o;$path+".y") //  $x = 99999

$path:="a[3].b[1].c"
$obj.setValue($o;$path;"new value") //  $o = {a:[null,null,null,{b:[null,{c:new value}]}]}

*/

Class constructor
	This:C1470.fullPath:=""
	This:C1470.valueKey:=""
	
	This:C1470.key:=""
	This:C1470.indx:=-1
	
	
Function getValue  //  (var; text) -> var
	var $1,$subObj : Variant  //  the object or collection
	var $2 : Text  //    path
	var $0
	var $i : Integer
	
	This:C1470.__parsePath($2)
	
	For ($i;0;This:C1470.fullPath.length-1)
		This:C1470.__key(This:C1470.fullPath[$i])
		
		If ($i=0)
			$subObj:=This:C1470.__getSubObj($1)
		Else 
			$subObj:=This:C1470.__getSubObj($subObj)
		End if 
		
	End for 
	
	$0:=This:C1470.__readValue($subObj)
	
Function setValue  // ( var; text; var )  sets $3 to $1
	//  WILL CREATE the heirarchy to the value
	var $1,$subObj : Variant  //  the object or collection
	var $2 : Text  //    path
	var $3  // the value - if setting
	var $i : Integer
	
	If ($1#Null:C1517)
		This:C1470.__parsePath($2)
		
		For ($i;0;This:C1470.fullPath.length-1)
			This:C1470.__key(This:C1470.fullPath[$i])
			
			If ($i=0)
				$subObj:=This:C1470.__subObj($1)
			Else 
				$subObj:=This:C1470.__subObj($subObj)
			End if 
			
		End for 
		
		This:C1470.__writeValue($subObj;$3)
	End if 
	
Function __parsePath  // ( text )
	var $1 : Text
	var $temp_c : Collection
	
	$temp_c:=Split string:C1554($1;".")
	
	This:C1470.valueKey:=$temp_c[$temp_c.length-1]
	This:C1470.fullPath:=$temp_c.slice(0;$temp_c.length-1)
	
Function __subObj  // (obj|collection) -> obj
	var $1,$subObj,$0
	var $indx : Integer
	var $key : Text
	
	$indx:=This:C1470.indx
	$key:=This:C1470.key
	
	
	If ($indx=-1)
		If ($1=Null:C1517)
			$1:=New object:C1471()
		End if 
		
		If ($1[$key]=Null:C1517)
			$1[$key]:=New object:C1471()
		End if 
		$0:=$1[$key]  //  tricky
		
	Else   //  a collection
		If ($1=Null:C1517)
			$1:=New object:C1471()
		End if 
		
		If ($1[$key]=Null:C1517)
			$1[$key]:=New collection:C1472()
		End if 
		
		If ($1[$key].length<$indx)
			$1[$key][$indx]:=New object:C1471()
		End if 
		$0:=$1[$key][$indx]
	End if 
	
Function __key
	var $1,$key : Text
	
	ARRAY LONGINT:C221($aPos;0)
	ARRAY LONGINT:C221($aLen;0)
	
	$key:=$1
	
	//  is this a collection
	If (Match regex:C1019("([\\w\\$]+)\\[(\\d+)\\]";$key;1;$aPos;$aLen))
		This:C1470.indx:=Num:C11(Substring:C12($key;$aPos{2};$aLen{2}))
		$key:=Substring:C12($key;$aPos{1};$aLen{1})
	Else 
		This:C1470.indx:=-1
	End if 
	
	This:C1470.key:=$key
	
Function __writeValue  // $1 is obj to write value to
	var $1,$subObj
	var $2  //  the value
	
	This:C1470.__key(This:C1470.valueKey)
	$subObj:=$1
	
	Case of 
		: (This:C1470.indx>-1)  //  writing to a collection
			If (Value type:C1509($subObj)#Is collection:K8:32)
				$subObj[This:C1470.key]:=New collection:C1472
			End if 
			$subObj[This:C1470.key][This:C1470.indx]:=$2
			
		: (Value type:C1509($subObj)=Is object:K8:27)
			$subObj[This:C1470.key]:=$2
			
	End case 
	
Function __getSubObj  // 
	// only returns an object that is valid
	
	var $1,$subObj,$0
	var $indx : Integer
	var $key : Text
	
	$indx:=This:C1470.indx
	$key:=This:C1470.key
	
	If ($indx=-1)
		Case of 
			: ($1=Null:C1517)
				$1:=Null:C1517
			: ($1[$key]=Null:C1517)
				$0:=Null:C1517
			Else 
				$0:=$1[$key]
		End case 
		
	Else   //  a collection
		Case of 
			: ($1=Null:C1517)
				$0:=Null:C1517
			: ($1[$key]=Null:C1517)
				$0:=Null:C1517
			: ($1[$key].length<$indx)
				$0:=Null:C1517
			Else 
				$0:=$1[$key][$indx]
		End case 
	End if 
	
Function __readValue
	var $1,$subObj
	var $0  //  the value
	
	This:C1470.__key(This:C1470.valueKey)
	$subObj:=$1
	
	Case of 
		: (This:C1470.indx>-1)  //  reading a collection
			Case of 
				: (Value type:C1509($subObj)#Is collection:K8:32)
					$0:=Null:C1517
				: ($subObj.length<(This:C1470.indx+1))
					$0:=Null:C1517
				Else 
					$0:=$subObj[This:C1470.key][This:C1470.indx]
			End case 
			
		: (Value type:C1509($subObj)=Is object:K8:27)
			If ($subObj[This:C1470.key]#Null:C1517)
				$0:=$subObj[This:C1470.key]
			Else 
				$0:=Null:C1517
			End if 
			
	End case 
	