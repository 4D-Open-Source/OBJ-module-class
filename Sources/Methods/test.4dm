//%attributes = {}

var $o,$obj : Object
var $path : Text
var $value

$obj:=cs:C1710.cOBJ.new()


$path:="a[3].b[1].c[5]"
$value:=New object:C1471("x";12345)


$o:=New object:C1471()

$obj.setValue($o;$path;$value)

$value.y:=99999

$x:=$obj.getValue($o;$path+".y")


$path:="a[3].b[1].c"
$obj.setValue($o;$path;"new value")
