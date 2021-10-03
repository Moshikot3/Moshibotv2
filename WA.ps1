<#
Powershell Whatsapp bot integrated with powershell, written by Moshe Tamayev.
#>
#972544911249@s.whatsapp.net

#---------------

# Note: Works in Windows PowerShell only - in PowerShell Core,
# [Text.Encoding]::Default is *invariably* UTF-8.
Write-Host "Moshibot script started"

$whatsappgroup = "972544911249-1633190920@g.us"




$flagspath = "D:\wa2\cache"
$parlist = import-csv $flagspath\participant_test.csv


$Allowedusers = "18083749762@s.whatsapp.net"

#Time to sleep for each loop before checking if a message with the magic word was received
$LoopSleep = 99999999

#Get the Last Message Time at the beginning of the script:When the script is ran the first time, it will ignore any last message received!

$BotUpdates = Invoke-WebRequest -Uri "http://localhost:8080/unread" -TimeoutSec 10
$lirantext = ([array]($BotUpdates.Content | ConvertFrom-Json).response).message.conversation
 $BotUpdatesResults = [array]($BotUpdates.Content | ConvertFrom-Json)
$LastMessageTime_Origin = $BotUpdatesResults[$BotUpdatesResults.Count-1].timestamp


#Get the Last Message Time at the beginning of the script:When the script is ran the first time, it will ignore any last message received!
#$BotUpdates = Invoke-WebRequest -Uri "http://localhost:42069/messages/unread" -TimeoutSec 10

#Read the responses in a while cycle
$DoNotExit = 1

#$PreviousLoop_LastMessageTime is going to be updated at every cycle (if the last message date changes)
$PreviousLoop_LastMessageTime = $LastMessageTime_Origin


$SleepStartTime = [Int] (get-date -UFormat %s) #This will be used to check if the $SleepTime has passed yet before sending a new notification out
While ($DoNotExit)  {

  start-sleep 3
  #Reset variables that might be dirty from the previous cycle

if((test-path "$($flagspath)/started.txt") -eq $true){
$Checklastmodify = ((Get-date) - (ls $flagspath\started.txt).LastWriteTime).TotalMinutes -gt 15



if($Checklastmodify -eq $True){

$joininglist = (get-content $flagspath\joining.txt) -join "`n"
 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "אהלן חברה - רק מזכיר שיש עוד כאלה שלא ענו לי אם הם מגיעים או לא.
ניתן לענות באמצעות הפקודות הבאות בצאט:
*join*
*leave*
מי שלא יענה ימשיך לקבל הודעות בפרטי עד שתצא לו הנשמה.

*מי מגיע בינתיים:*
$($joininglist)
";
}
"flagaddtime" >> $flagspath/started.txt
Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params


foreach($parname in $parlist.user){

    if((get-content $flagspath\joining.txt) -notcontains $parname -or (get-content $flagspath\leaving.txt) -notcontains $parname){
           $params = ""
           $parnoumber = ""
           $parnoumber = ($parlist | ?{$_.user -contains $parname}).wa
            #"contactID"= "$($parnoumber)@s.whatsapp.net";
          $params = @{
 
	        "contactID"= "180837497629@s.whatsapp.net";
	        "text" = "אהלן אח/ אחות, עדיין לא אישרת הגעה ליציאה היום
באפשרותך לאשר או לסרב באמצעות אחד מהפקודות הבאות בקבוצה:
*מגיע*
*לא מגיע*
(בדיוק כמו הטקסט המודגש, אותיות וסימני פיסוק נוספים לא יקלטו במערכת)

המשך יום נעים ומי יתן ולא אחפור לך יותר.
";
        }

        Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params

    }


}
}

}



    # Delete files older than the $limit.
  
  $LastMessageText = ""
  $CommandToRun = ""
  $CommandToRun_Result = ""
  $CommandToRun_SimplifiedOutput = ""
  $Message = ""
  $json = ""
  $ips = ""
  $leavingname = ""
  $joininglist = ""
  $syncsql_Result = ""
  $joiningname = ""
  $ips_result = ""
  $RemoveLastUpdate = ""
  $Messageresult = ""
  $randomnum = ""
  
  #Get the current Bot Updates and store them in an array format to make it easier
  $BotUpdates = Invoke-WebRequest -Uri "http://localhost:8080/unread" -TimeoutSec 10
  $BotUpdatesResults = [array]($BotUpdates.Content | ConvertFrom-Json)
  
  #Get just the last message:
  $LastMessage = $BotUpdatesResults[$BotUpdatesResults.Count-1]
  #Get the last message time
  $LastMessageTime = $LastMessage.timestamp
  
  #If the $LastMessageTime is newer than $PreviousLoop_LastMessageTime, then the user has typed something!
  If ($LastMessageTime -gt $PreviousLoop_LastMessageTime)  {
    #Looks like there's a new message!


	#Update $PreviousLoop_LastMessageTime with the time from the latest message
	$PreviousLoop_LastMessageTime = $LastMessageTime
	#Update the LastMessageTime
	$LastMessageTime = $LastMessage.timestamp
	#Update the $LastMessageText
	$LastMessageText = $LastMessage.message
	Switch -Wildcard ($LastMessageText)  {

 
	  "run *"  { #Important: run with a space
    #Check_If_superadmin


	    #The user wants to run a command
		$CommandToRun = ($LastMessageText -split ("run "))[1] #This will remove "run "
		#$Message = "Ok $($LastMessage.Message.from.first_name), I will try to run the following command: `n<b>$($CommandToRun)</b> `nPlease wait.."
		#$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"
		
		#Run the command
               #$CommandToRun

		 Invoke-Expression $CommandToRun

		  

	  }
	  "!die"  {
		#The user wants to stop the script
		write-host "The script will end in 5 seconds"
 $params = @{
 
	"contactID"= "$($LastMessage.key.remoteJid)";
	"text" = "bye :(";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params
		Sleep -seconds 5
		$DoNotExit = 0
	  }

	  "מי מגיע?"  {
#########################################################
$joininglist = (get-content $flagspath\joining.txt) -join "`n"

 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "*להלן רשימה של מי שאישר הגעה:*
$($joininglist)";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params



#########################################################END

	  }
	  "קובי"  {
#########################################################

      $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "שמע בגדול אני מכיר את ההוראות הבאות:\n*מגיע*\n*לא מגיע*\n*מי מגיע?*\n*לאן יוצאים?*\n*הצעה:<טקסט חופשי>*"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message



#########################################################END

	  }

	  "שלום *"  { #Important: run with a space
		$CommandToRun = ($LastMessageText -split ("שלום "))[1] #This will remove "run "

 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "$CommandToRun";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params

Write-Host $CommandToRun 



#########################################################END

	  }


	  "!start"  {
#########################################################

if((test-path "$($flagspath)/started.txt") -eq $true){

      $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "אני כבר עובד על יציאה."
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message


    continue

}



New-Item $flagspath\started.txt -Force
New-Item $flagspath\joining.txt -Force
New-Item $flagspath\leaving.txt -Force

 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "אהלן חברים יקרים, שמי *קובי הרובוט🤖* - ואני כאן על מנת לעזור לכם להרים יציאה לפנטאון.
כל שעליכם לעשות זה לשתף עמי פעולה ולהשתמש בשתי הפקודות הבאות בקבוצה:
---------
*מגיע*
*לא מגיע*
---------
(בדיוק כמו הטקסט המודגש, אותיות וסימני פיסוק נוספים לא יקלטו במערכת)


בנוסף אני יודע לענות על השאלות הבאות:
*הצעה: <טקסט חופשי>*
*מי מגיע?*
*לאן יוצאים?*


*שימו לב* - מאחר ונודע לי (לא חשוב שמות) שאתם מורחים את הזמן, שאתם לא החלטיים, ושאתם נזכרים בדקה התשעים -
תוכנתתי על מנת לחפור לכם גם בפרטי - *כן כן*, מי שלא יאשר, יקבל חפירה בכל 15 דק..

לידיעתכם - אני עוד בגרסת אלפא, לכן אני גם יכול לצאת אוטיסט מידי פעם 🤷‍

מי יתן ותהיה לכם יציאה לא פחות מאחושרמוטה🔪!";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params



#########################################################END

	  }


	  "!stop"  {
#########################################################

if((test-path "$($flagspath)/started.txt") -eq $false){

      $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "אין יציאה בתכנון כרגע"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message


    continue

}



 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "נהנתי לעזור לכם - שתהיה לכם יציאה מהנה :)";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params

$joininglist = (get-content $flagspath\joining.txt) -join "`n"

 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "*להלן רשימה של מי שאישר הגעה:*
$($joininglist)";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params

remove-Item $flagspath\started.txt -Force
remove-Item $flagspath\joining.txt -Force
remove-Item $flagspath\leaving.txt -Force


#########################################################END

	  }

	  "מגיע"  {

#########################################################START
# Note: Works in Windows PowerShell only - in PowerShell Core,
# [Text.Encoding]::Default is *invariably* UTF-8.

#$($LastMessage.key.remoteJid)

if((test-path "$($flagspath)/started.txt") -eq $false){

      $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "אין יציאה בתכנון כרגע"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message


    continue

}

if((Get-Content $flagspath\leaving.txt) -contains ($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user){

  $LeavingMsg = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "אמנם הודעת שאינך מגיע, אך אני דואג לך בכל זאת..."
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $LeavingMsg

(Get-Content $flagspath\leaving.txt) | select-string -pattern ($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user -notmatch | Out-File $flagspath\leaving.txt


}

$joiningname = ($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user

if($LastMessage.participant -eq $null){

  $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "תרשום בקבוצה, לא פה..."
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message



}elseif((get-content $flagspath\joining.txt) -contains $joiningname){

  $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "כבר רשמתי אותך מה אתה בא לעשות עליי מהלך?"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message

}else{



($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user >> $flagspath/joining.txt

  $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "רשמתי אותך גבר"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message
   

 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "*$($joiningname)* אישר/ה הגעה";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params
}


#$body = [System.Text.Encoding]::UTF8.GetBytes($json)

#########################################################END


	  }

	  "לא מגיע"  {

#########################################################START
$leavingname = ($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user

if((test-path "$($flagspath)/started.txt") -eq $false){

      $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "אין יציאה בתכנון כרגע"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message


    continue

}


if((Get-Content $flagspath\joining.txt) -contains ($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user){

  $LeavingMsg = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "אמנם הודעת שאת/ה מגיע/ה, אך אסיר אותך מרשימת המגיעים..."
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $LeavingMsg

(Get-Content $flagspath\joining.txt) | select-string -pattern ($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user -notmatch | Out-File $flagspath\joining.txt


}


if($LastMessage.participant -eq $null){

  $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "תרשום בקבוצה, לא פה..."
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message



}elseif((get-content $flagspath\leaving.txt) -contains $leavingname){

  $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "טוב הבנתי שאת/ה לא מגיע/ה למה לאכול את הראס?"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message

}else{



($parlist | ?{$_.wa -contains ($LastMessage.participant -replace "@s.whatsapp.net","")}).user >> $flagspath/leaving.txt

  $Message = @"
{
      "contactID" : "$($LastMessage.key.remoteJid)",
      "quotedMessage": {
          "key": {
              "remoteJid": "$($LastMessage.participant)",
              
              "id": "c" 
          },
          "message": { "conversation": "$($LastMessage.message.conversation)" } 
      },
      "text": "התנהגות של ילד קקה"
  }
"@
Invoke-RestMethod -Uri http://localhost:42069/messages/send/text -ContentType 'application/json; charset=utf-8' -Method Post -Body $Message
   

 $params = @{
 
	"contactID"= "$($whatsappgroup)";
	"text" = "*$($leavingname)* לא מגיע/ה";
}

Invoke-WebRequest -Uri http://localhost:42069/messages/send/text -Method POST -Body $params

}


#########################################################

	  }

	  "/blockip *"  {
		$ips = ($LastMessageText -split ("/blockip "))[1] #This will remove "run "
		#The user wants to stop the script
		$Message = "Hi $($LastMessage.Message.from.first_name),Request to block IP as been submited ""$($LastMessageText)""!"
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"


		#Run the command
		Try {
		    $ips = ($LastMessageText -split ("/blockip "))[1] #This will remove "run "
		    Invoke-Expression "Set-NetFirewallRule -DisplayName NBlockIPS -RemoteAddress $ips" | Out-String | %  {
		    $ips_Result += "`n $($_)"
		  }
		}
		Catch  {
		  $ips_Result = $_.Exception.Message
		}


        
	  }

	  default  {
	    #The message sent is unknown
Write-Host "New message recieved"

	  }
        
	}
    }
	
  }
  