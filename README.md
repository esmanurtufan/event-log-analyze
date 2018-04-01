This project can follow and analyze the windows event log. 

In the Event Log, both the application log and the system log contain errors, warnings, and informational events that are related to the operation of Exchange Server, and other applications. To identify the cause of message flow issues, carefully review the data that is contained in the application log and system log.
In this project, we are intered in Security Logs. We used that site to follow event log id. Event Id means: A Windows identification number that specifies the event type. 

https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/default.aspx 


Before the specify event id you should decide what you need. You can analyze the "An account was successfully logged on" or "Special privileges assigned to new logon".. etc.

You can find "security","application","setup" and "system" logs. You can choose the log level "critical","error","warning","information" or "verbose". You can run this code at your localhost or another pc. 

We are 2 examples of usage.

----------------------------------------------------------------------------------------------------------------------

**1) localhost event log**

You are admin at your pc to run this code. 

***Event id:4624 
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/4624.PNG)

.\get_eventlog.ps1 -sunucu localhost -log_cesidi security -zaman 60 -eventid 4624

Start with running code at the file path. We find event which id is 4624 (you can choose another critical id) on localhost pc. We find the logs within the specified time (parameter:zaman). We choose the time 60 min in this example.

***Or Event id:4672 

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/4672.PNG)
.\get_eventlog.ps1 -sunucu localhost -log_cesidi security -zaman 60 -eventid 4672


The iportant point is how can we analyze/report the output. 

**Analyze time!
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/1.PNG)

$events=.\get_evenlog.ps1 -sunucu btbtest -log_cesidi security -zaman 5 -eventid 4672 

We assing the output to variable (events). 

$events[0].Id

This command writes Id parameter in events id,

$events[0].Message

and this cammand writes Messages parameter.

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/2.PNG)

$mesaj=$events[0].Message

We assing the $events[0].Message to variable $mesaj and split it.


![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/3.PNG)

$events|%{$_.message -split "\n" }|%{if($_ -like "*Account Name:*"){(($_ -split "\:")[1]).trim()}} 

We split the events variable to messages like Account Name.

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/4.PNG)
$events|%{$_.message -split "\n" }|%{if($_ -like "*Account Name:*"){(($_ -split "\:")[1]).trim()}}|Group-Object |select count,name

Then finally we found the goups who change the pirivilages.
