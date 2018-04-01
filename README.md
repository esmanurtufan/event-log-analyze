This project can follow and analyze the windows event log. 

In the Event Log, both the application log and the system log contain errors, warnings, and informational events that are related to the operation of Exchange Server, and other applications. To identify the cause of message flow issues, carefully review the data that is contained in the application log and system log.
In this project, we are intered in Security Logs. We used that site to follow event log id. Event Id means: A Windows identification number that specifies the event type. 

https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/default.aspx 


Before the specify event id you should decide what you need. You can analyze the "An account was successfully logged on" or "Special privileges assigned to new logon".. etc.

You can find "security","application","setup" and "system" logs. You can choose the log level "critical","error","warning","information" or "verbose". You can run this code at your localhost or another pc. 

We are 2 examples of usage.

----------------------------------------------------------------------------------------------------------------------

**1) localhost event log**

You are admin at your pc to run this code. (localhost name:omer1 & user:decoder) 

***Event id:4624***

.\get_eventlog.ps1 -sunucu localhost -log_cesidi security -zaman 60 -eventid 4624

Start with running code at the file path. We find event which id is 4624 (you can choose another critical id) on localhost pc. We find the logs within the specified time (parameter:zaman). We choose the time 60 min in this example.
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/4624.PNG)


***Or Event id:4672** *
.\get_eventlog.ps1 -sunucu localhost -log_cesidi security -zaman 60 -eventid 4672

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/4672.PNG)


The iportant point is how can we analyze/report the output. 

**Analyze time!**

$events=.\get_evenlog.ps1 -sunucu btbtest -log_cesidi security -zaman 5 -eventid 4672 
We assing the output to variable (events). 

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/1.PNG)


$events[0].Id          This command writes Id parameter in events id,
$events[0].Message      and this cammand writes Messages parameter.

$mesaj=$events[0].Message
We assing the $events[0].Message to variable $mesaj and split it.
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/2.PNG)

$events|%{$_.message -split "\n" }|%{if($_ -like "*Account Name:*"){(($_ -split "\:")[1]).trim()}} 

We split the events variable to messages like Account Name.

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/3.PNG)

$events|%{$_.message -split "\n" }|%{if($_ -like "*Account Name:*"){(($_ -split "\:")[1]).trim()}}|Group-Object |select count,name

Then finally we found the groups who changed the privilages.

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/4.PNG)

----------------------------------------------------------------------------------------------------------------------

**1) remote computer event log**

Now there is a new computer in this example. (local host:omer1 & remote computer:ESMA) We find security logs' at omer1 pc with ESMA.

.\get_eventlog.ps1 -sunucu omer1 -log_cesidi security -zaman 60 -eventid 4624 
We run the same code previous example. The diffrence is: we are in another computer(ESMA) and again we find the omer1's 4624 event id logs. And we save the output to test.txt file.

![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/remote.pc.1.PNG)

Then we repeat the previous code in previous example and we find 


![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/remote.pc.2.PNG)
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/remote.pc.3.PNG)
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/remote.pc.4.PNG)
![alt text](https://github.com/esmanurtufan/event-log-analyze/blob/master/screenshots/remote.pc.5.PNG)








