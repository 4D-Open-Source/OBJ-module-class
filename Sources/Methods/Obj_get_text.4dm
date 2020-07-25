//%attributes = {}
/*  Obj_get_text (object; path) -> text
 Created by: Kirk as Designer, Created: 07/25/20, 10:41:47
 ------------------
 Purpose: example of converting a method from the OBJ Module component

*/
C_OBJECT:C1216($1;$o)
C_TEXT:C284($2;$0)

$o:=cs:C1710.cObj.new()
$0:=String:C10($o.getValue($1;$2))  //  use string in case the value isn't actually text
