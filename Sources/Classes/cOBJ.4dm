/*  cOBJ ()
 Created by: Kirk as Designer, Created: 07/25/20
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


Pushing values onto a collection
 $path:="z.a[].b[]" 
 $obj.setValue($o;$path;1234)  //  $o = {z:{a:[{b:[1234]}]}}
 $obj.path = "z.a[0].b[0]"
The collections may be empty or non-existant. 
$obj.path will be updated to reflect the position of the value created

*/

Class constructor
	This:C1470.path:=""
	This:C1470.pathCol:=""
	This:C1470.valueKey:=""
	
	This:C1470.key:=""
	This:C1470.indx:=-1
	This:C1470.keyType:=Is object:K8:27
	
	
Function getValue  //  (var; text) -> var
	var $1,$subObj : Variant  //  the object or collection
	var $2 : Text  //    path
	var $0 : Variant
	var $i : Integer
	
	This:C1470.__parsePath($2)
	
	If (This:C1470.pathCol.length>0)
		For ($i;0;This:C1470.pathCol.length-1)
			This:C1470.__key(This:C1470.pathCol[$i])
			
			If ($i=0)
				$subObj:=This:C1470.__getSubObj($1)
			Else 
				$subObj:=This:C1470.__getSubObj($subObj)
			End if 
			
		End for 
		
	Else   // $1 is the subObj
		$subObj:=$1
	End if 
	
	$0:=This:C1470.__readValue($subObj)
	
Function setValue  // ( var; text; var )  sets $3 to $1
	//  WILL CREATE the heirarchy to the value
	var $1,$subObj : Variant  //  the object or collection
	var $2 : Text  //    path
	var $3  // the value - if setting
	var $i : Integer
	
	If ($1#Null:C1517)
		This:C1470.__parsePath($2)
		
		If (This:C1470.pathCol.length>0)
			For ($i;0;This:C1470.pathCol.length-1)
				This:C1470.__key(This:C1470.pathCol[$i])
				
				If ($i=0)
					$subObj:=This:C1470.__subObj($1)
				Else 
					$subObj:=This:C1470.__subObj($subObj)
				End if 
				
			End for 
			
		Else 
			$subObj:=$1
		End if 
		
		This:C1470.__writeValue($subObj;$3)
	End if 
	
Function __parsePath  // ( text )
	var $1 : Text
	var $temp_c : Collection
	
	This:C1470.path:=$1
	$temp_c:=Split string:C1554($1;".")
	
	This:C1470.valueKey:=$temp_c[$temp_c.length-1]
	This:C1470.pathCol:=$temp_c.slice(0;$temp_c.length-1)
	
Function __subObj  // (obj|collection) -> obj
	var $1,$subObj,$0
	var $indx : Integer
	var $key : Text
	
	$indx:=This:C1470.indx
	$key:=This:C1470.key
	
	If (This:C1470.keyType=Is object:K8:27)
		If ($1=Null:C1517)
			$1:=New object:C1471()
		End if 
		
		Case of 
			: ($1[$key]=Null:C1517)
				$1[$key]:=New object:C1471()
				
			: (Value type:C1509($1[$key])#Is object:K8:27) & (Value type:C1509($1[$key])#Is collection:K8:32)
				// we will have nothing to write to otherwise
				$1[$key]:=New object:C1471()
				
		End case 
		
		$0:=$1[$key]  //  tricky
		
	Else   //  a collection
		If ($1=Null:C1517)
			$1:=New object:C1471()
		End if 
		
		If ($1[$key]=Null:C1517)
			$1[$key]:=New collection:C1472()
		End if 
		
		Case of 
			: ($indx=-2)  // push
				$1[$key].push(New object:C1471())
				$indx:=$1[$key].length-1
				
				This:C1470.__updatePath($key;$indx)
				
			: ($1[$key].length<$indx)
				$1[$key][$indx]:=New object:C1471()
				
			Else 
		End case 
		
		$0:=$1[$key][$indx]
	End if 
	
Function __key
	var $1,$key : Text
	
	ARRAY LONGINT:C221($aPos;0)
	ARRAY LONGINT:C221($aLen;0)
	
	$key:=$1
	
	//  is this a collection
	Case of 
		: (Match regex:C1019("([\\w\\$]+)\\[(\\d+)\\]";$key;1;$aPos;$aLen))  //  get the index
			This:C1470.indx:=Num:C11(Substring:C12($key;$aPos{2};$aLen{2}))
			$key:=Substring:C12($key;$aPos{1};$aLen{1})
			This:C1470.keyType:=Is collection:K8:32
			
		: (Match regex:C1019("([\\w\\$]+)\\[\\]";$key;1;$aPos;$aLen))  //  push 
			This:C1470.indx:=-2
			$key:=Substring:C12($key;$aPos{1};$aLen{1})
			This:C1470.keyType:=Is collection:K8:32
			
		Else 
			This:C1470.indx:=-1
			This:C1470.keyType:=Is object:K8:27
	End case 
	
	This:C1470.key:=$key
	
Function __writeValue  // $1 is obj to write value to
	var $1,$subObj : Object
	var $2 : Variant  //  the value
	var $indx : Integer
	
	This:C1470.__key(This:C1470.valueKey)
	$subObj:=$1
	
	Case of 
		: (This:C1470.indx=-2)  //  push collection
			If (Value type:C1509($subObj[This:C1470.key])#Is collection:K8:32)
				$subObj[This:C1470.key]:=New collection:C1472
			End if 
			$subObj[This:C1470.key].push($2)
			
			$indx:=$subObj[This:C1470.key].length-1
			
			This:C1470.__updatePath(This:C1470.key;$indx)
			
		: (This:C1470.indx>-1)  //  writing to a collection
			If (Value type:C1509($subObj)#Is collection:K8:32)
				$subObj[This:C1470.key]:=New collection:C1472
			End if 
			$subObj[This:C1470.key][This:C1470.indx]:=$2
			
		: (Value type:C1509($subObj)=Is object:K8:27)
			$subObj[This:C1470.key]:=$2
			
	End case 
	
Function __getSubObj  // reading the path
	// only returns an object that is valid
	
	var $1,$subObj,$0
	var $indx : Integer
	var $key : Text
	
	$indx:=This:C1470.indx
	$key:=This:C1470.key
	
	If (This:C1470.keyType=Is object:K8:27)
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
	var $1,$subObj : Object
	var $0 : Variant  //  the value
	
	This:C1470.__key(This:C1470.valueKey)
	$subObj:=$1
	
	Case of 
		: (This:C1470.indx>-1)  //  reading a collection
			Case of 
				: (Value type:C1509($subObj[This:C1470.key])#Is collection:K8:32)
					$0:=Null:C1517
				: ($subObj[This:C1470.key].length<(This:C1470.indx+1))
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
	
Function __updatePath  // (key; index)
	var $1,$path : Text
	var $2,$pos,$len : Integer
/* I know the path is 'key[]' ...*/
	
	$path:=$1+"[]"
	$pos:=Position:C15($path;This:C1470.path;1;$len;*)
	This:C1470.path:=Delete string:C232(This:C1470.path;$pos;$len)
	
	$path:=$1+"["+String:C10($2)+"]"
	This:C1470.path:=Insert string:C231(This:C1470.path;$path;$pos)
	