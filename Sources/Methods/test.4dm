//%attributes = {}

var $o,$OBJ : Object
var $path : Text
var $value,$x

$OBJ:=cs:C1710.cObj.new()  //  instantiate the class
// --------------------------------------------------------

$o:=New object:C1471()

$path:="a"
$OBJ.setValue($o;$path;1234)  // $o = {a:1234}
$x:=$OBJ.getValue($o;$path)  //  $x = 1234

$path:="a.b.c.d.e"
$OBJ.setValue($o;$path;1234)  // $o = {a:{b:{c:{d:{e:1234}}}}}  -- note that a was overwritten

$o.a.b.c.q:=8888  //             $o = {a:{b:{c:{d:{e:1234},q:8888}}}}
$x:=$OBJ.getValue($o;$path)  //  $x = 1234

//------------------
/* collections are supported also
*/
$o:=New object:C1471
$path:="a[3].b[1].c[5]"
$value:=New object:C1471("x";12345)  //  we will set an object instead of a scalar value

$OBJ.setValue($o;$path;$value)  // $o = {a:[null,null,null,{b:[null,{c:[null,null,null,null,null,{x:12345}]}]}]}

$value.y:=99999/*  adding another property to $value 
   $o={a:[null,null,null,{b:[null,{c:[null,null,null,null,null,{x:12345,y:99999}]}]}]}
*/

$x:=$OBJ.getValue($o;$path+".y")  //  $x = 99999

/*  You can push values onto a collection using []
*/

$o:=New object:C1471()
$path:="col[]"  //  'naked' collections are not supported - yet
$OBJ.setValue($o;$path;"a")
$OBJ.setValue($o;$path;"b")
$OBJ.setValue($o;$path;"c")  //  $o = {col:[a,b,c]}

$path:=$OBJ.path/* the .path property is updated to show the actual path the value was written to
    $path = "col[2]"
*/

$path:="a[3].b[1].c[]"
$OBJ.setValue($o;$path;"new value")
$OBJ.setValue($o;$path;"another value")
/* $o = {col:[a,b,c],a:[null,null,null,{b:[null,{c:[new value,another value]}]}]} */

$path:=$OBJ.path
/*  $path = "a[3].b[1].c[1]" which is the path the last value was written to...*/

$x:=$OBJ.getValue($o;$path)  //  $x = 'another value'

/* --------------------------------------------------------
  Converting methods from the OBJ Module component
 --------------------------------------------------------
If you want to update methods from Cannon's component it's pretty easy. 
The two sample methods illustrate what's required. 
Such converted methods will handle the new paths - such as the push syntax. 
*/

$o:=New object:C1471()
OBJ_SET_TEXT($o;"a.b.c.d";"Hello World!")
//  $o = {a:{b:{c:{d:Hello World!}}}}

$o.a:="Nice!"

$t:=Obj_get_text($o;"a")


