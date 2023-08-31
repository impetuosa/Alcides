# Alce IDE
IDE extentions for Alce

Please, address [https://github.com/impetuosa/alce](https://github.com/impetuosa/alce) to learn how to load a Microsoft Access Alce model. 


## Architecture 

![resources/alce-stack.jpg](resources/alce-stack.jpg)


## Loading 

To load Alce IDE, just run the following metacello script. 

```smalltalk
Metacello new
    	 repository: 'github://impetuosa/Alcides/src';
    	baseline: 'AlcIDE';
    	onWarningLog;
    	load
```


Add Alce IDE as dependency as follow:
```smalltalk
	spec
		baseline: 'AlcIDE'
		with: [ spec repository: 'github://impetuosa/Alcides/src' ].

```

