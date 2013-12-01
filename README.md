DConsole is a combined logger and command-line interface for Flash 11 ActionScript 3 developers, in development since 2006.

 * Call any function.
 * Poll or change any property.
 * Visually tweak what's on stage.

Enjoy the power a developer _should_ have over his or her own creation.

It functions as an easily-implemented layer that sits on top of your application, using introspection techniques and specifically exposed methods to grant you run-time access to your ActionScript objects. 

	addChild(DConsole.view)

The console allows you to bind AS3 functions to console "commands".

    function getUserByName(name:String):UserData{
    	...
        return foundUser;
    }
	DConsole.createCommand("getUser",getUserByName);
    
These commands can then be invoked from the commandline to execute their functionality and print their returned results.

	>> getUser John User
    << [object UserData]

It also doubles as a flexible logging view, offering a loose coupling with SLF4AS and AS3Commons logging to offer meaningful logging with metadata such as message origin and importance.

	public static const L:ILogger = Logging.getLogger(MyClass);

	L.info("Hello world!");
	L.fatal("OH GOD");

A third purpose is as a layer of visual developer tools for simplifying common Flash developer grievances, such as making run-time visual adjustments to the application frontend before committing them to code.

For more informaton, hit the [wiki](https://github.com/furusystems/DConsole/wiki).
