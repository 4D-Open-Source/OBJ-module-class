# OBJ-module-class
A class to read and write to an object with a dot-notation path. This is a convenient way to create complex objects on the fly as well as to build a complex path to read in a single call.

Can be used as a replacement form Cannon Smith's OBJ Module.

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
## Member functions
### setValue ( object; path; value ) 

  - object: must be an object 
  - path: dot notation text path
  - value: 4D value
 
 The hierarchy will be created if it's not already there. If an existing hierarchy will be overwritten if it doesn't match the path. 
 You may include collections. Collections are sized to accomodate the specified index. 
 
 ### getValue ( object; path ) -> variant
 
 - The hierarchy **is not** created. 
 - Returns **null** if path is not valid. 
 
 NOTE: this is different behavior from the original OBJ Module, which creates the hierarchy and returns a blank or zero value for new values. 
