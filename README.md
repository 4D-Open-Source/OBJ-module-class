# OBJ-module-class
A class to read and write to an object with a dot-notation path. This is a convenient way to create complex objects on the fly as well as to build a complex path to read in a single call.

Can be used as a replacement for Cannon Smith's OBJ Module.

When I started on this I assumed it was going to be fairly easy with the new tools available in v18. It was not. The reason is this is essentially a dot-notation parser and parsers are tricky. This is not a complete implementation. For example, it doesn't handle straight collections or collections of collections. eg:
```
	$a[1][2]
```
The root must be an object and each collection must be a property of an object.

Adding the ability to push values onto collections was another wrinkle and required storing and updating the original path to make it available after the call. Being able to push a value on a collection several levels deep would be as useful without being able to read it right away.

## Why would you want to do this?
The question did come up of why even do this. Why not just recompile the original move on? It's a valid question. Being able to push onto collections is useful. Reducing the footprint to a single class is an improvement as well. And the ability to construct complex objects quickly with a single string is really useful in situations where these objects are being built.

## Installation and Use
You can copy the `cObj.4dm` file to the Classes folder of your Project.
You may compile into a component. Classes can not be shared directly between a compoent and the host database. The `get_cObj` method is a shared method that can be called from the host database, including binary databases. Use this method to create instances of `cObj` in the Host.

It is more efficient to create a single instance of `cObj` for reuse. Do not do this in **Storage**. Because the class retains data while its processing **Storage** will result in poor performance and other issues if called from multiple processes simultaneously. At the least create an instance once in each method. See the Test method. It's not necessary or useful to create a separate instance of the class for every object you want to use it on.

## Examples
```
	$OBJ:=cs.cOBJ.new()
	$path:="a[3].b[1].c[5]"
	$value:=New object("x";12345)

	$OBJ.setValue($o;$path;$value)  //  $o = {a:[null,null,null,{b:[null,{c:[null,null,null,null,null,{x:12345}]}]}]}
	$value.y:=99999

	$x:=$OBJ.getValue($o;$path+".y") //  $x = 99999

	$path:="a[3].b[1].c"
	$OBJ.setValue($o;$path;"new value") //  $o = {a:[null,null,null,{b:[null,{c:new value}]}]}
  ```

You can also push elements onto a collection by passing empty brackets:

	```
		$o:=New object()
		$path:="col[]"
		$OBJ.setValue($o;$path;"a")
		$OBJ.setValue($o;$path;"b")
		$OBJ.setValue($o;$path;"c")  //  $o = {col:[a,b,c]}
	```

If you want to get the path to the element pushed you can read the .path propert of the class:

	```
	$path:=$OBJ.path   /*  $path = "col[2]"	*/
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

## Replacing OBJ Module methods
A couple of example methods are included that will replace the original compoent methods of the same name. The easiest way to make the replacements you need is to simply remove the OBJ Module component and check the compiler for missing methods. Some methods, such as the ones involving dates, will warrant some attention for the date conversions most appropriate for your database.
