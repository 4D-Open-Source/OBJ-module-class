# OBJ-module-class
A class to read and write to an object  with a string path. Can be used as a replacement form Cannon Smith's OBJ Module.

## Example
```
	$obj:=cs.cOBJ.new()
	$path:="a[3].b[1].c[5]"
	$value:=New object("x";12345)

	$obj.setValue($o;$path;$value)  //  $o = {a:[null,null,null,{b:[null,{c:[null,null,null,null,null,{x:12345}]}]}]}
	$value.y:=99999

	$x:=$obj.getValue($o;$path+".y") //  $x = 99999

	$path:="a[3].b[1].c"
	$obj.setValue($o;$path;"new value") //  $o = {a:[null,null,null,{b:[null,{c:new value}]}]}
  ```
