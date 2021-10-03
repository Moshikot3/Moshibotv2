
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$RootPassword = ConvertTo-SecureString -String "moshL33TXD!noder" -AsPlainText -Force
$whatsappgroup = "972542526264-1609074582@g.us"
$SuperAdmins = "544911249@c.us"
$Allowedusers = "544911249@c.us","test1234556688","eBotWeb","liran_aviani","Alkobi6199","Psyduckkkkkkkkk"
#https://api.telegram.org/bot2038438953:AAGeEN8MtBj772QVn_4kMy_R1f_luUMGG0o/getUpdates

$BotToken = "2038438953:AAGeEN8MtBj772QVn_4kMy_R1f_luUMGG0o"
$ChatID = "-501284879"

#Time to sleep for each loop before checking if a message with the magic word was received
$LoopSleep = 5


#Get the Last Message Time at the beginning of the script:When the script is ran the first time, it will ignore any last message received!

$BotUpdates = Invoke-WebRequest -Uri "http://localhost:8080/unread" -TimeoutSec 10
$BotUpdatesResults = [array]($BotUpdates | ConvertFrom-Json)
$LastMessageTime_Origin = $BotUpdatesResults[$BotUpdatesResults.Count-1].timestamp


#Read the responses in a while cycle
$DoNotExit = 1
#$PreviousLoop_LastMessageTime is going to be updated at every cycle (if the last message date changes)
$PreviousLoop_LastMessageTime = $LastMessageTime_Origin

$SleepStartTime = [Int] (get-date -UFormat %s) #This will be used to check if the $SleepTime has passed yet before sending a new notification out
While ($DoNotExit)  {

  start-sleep 3
  #Reset variables that might be dirty from the previous cycle

    # Delete files older than the $limit.
  Get-ChildItem -Path D:\xampp\htdocs\Telegram -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt ((Get-Date).AddMinutes(-1)) } | Remove-Item -Exclude Index.html -Force
  $LastMessageText = ""
  $CommandToRun = ""
  $CommandToRun_Result = ""
  $CommandToRun_SimplifiedOutput = ""
  $Message = ""
  $ips = ""
  $syncsql_Result = ""
  $ips_result = ""
  $RemoveLastUpdate = ""
  $Messageresult = ""
  $randomnum = ""
  
  #Get the current Bot Updates and store them in an array format to make it easier
  $BotUpdates = Invoke-WebRequest -Uri "http://localhost:8080/unread" -TimeoutSec 10
  $BotUpdatesResults = [array]($BotUpdates | ConvertFrom-Json)
  
  #Get just the last message:
  $LastMessage = $BotUpdatesResults[$BotUpdatesResults.Count-1]
  #Get the last message time
  $LastMessageTime = $LastMessage.timestamp
  
  #If the $LastMessageTime is newer than $PreviousLoop_LastMessageTime, then the user has typed something!
  If ($LastMessageTime -gt $PreviousLoop_LastMessageTime)  {
    #Looks like there's a new message!

    #Removing getUpdates requests
    #$RemoveLastUpdate = ($LastMessage.update_id)+1
    #Invoke-WebRequest -Uri "https://api.telegram.org/bot$($BotToken)/getUpdates?offset=$RemoveLastUpdate" -TimeoutSec 10


	#Update $PreviousLoop_LastMessageTime with the time from the latest message
	$PreviousLoop_LastMessageTime = $LastMessageTime
	#Update the LastMessageTime
	$LastMessageTime = $LastMessage.timestamp
	#Update the $LastMessageText
	$LastMessageText = $LastMessage.message
	if($Allowedusers -contains ($LastMessage.messageid -replace "(?s)^.*_972","")){
	Switch -Wildcard ($LastMessageText)  {

 
	  "!run *"  { #Important: run with a space
    #Check_If_superadmin
       if($SuperAdmins -contains ($LastMessage.messageid -replace "(?s)^.*_972","")){

	    #The user wants to run a command
		$CommandToRun = ($LastMessageText -split ("/run "))[1] #This will remove "run "
		#$Message = "Ok $($LastMessage.sender), I will try to run the following command: `n*$($CommandToRun)* `nPlease wait.."
		#$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"

        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "Ok $($LastMessage.sendername), I will try to run the following command: `n*$($CommandToRun)* `nPlease wait.."
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
        }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)

		
		#Run the command
		Try {
		  Invoke-Expression $CommandToRun | Out-String | %  {
		    $CommandToRun_Result += "`n $($_)"
		  }
		}
		Catch  {
		  $CommandToRun_Result = $_.Exception.Message
		}

		
		#$Message = "$($LastMessage.sender), I've ran *$($CommandToRun)* and this is the output:`n$CommandToRun_Result"
		#$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"

        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername), I`ve ran *$($CommandToRun)* and this is the output:`n$CommandToRun_Result"
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
        }else{
        		#$Message = "$($LastMessage.sender), Get da fuck out of here you are not a super admin..."
		        #$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"
                $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername), Get da fuck out of here you are not a super admin..."
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                }
                $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
                }
	  }
	  "!quit_script"  {
		#The user wants to stop the script
		write-host "The script will end in 5 seconds"
        $ExitMessage = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername) has requested the script to be terminated. It will need to be started again in order to accept new messages!"
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $ExitRestResponse = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($ExitMessage | ConvertTo-Json)
		Sleep -seconds 5
		$DoNotExit = 0
	  }

	  "!syncnoip"  {
		#The user wants to stop the script
        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername) has requested to sync no-ip for mysql"
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
        

		 .'C:\Tasks\ps1\sqlddns.ps1' | Out-String | %{$syncsql_Result += "`n $($_)"}


        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername), The following no-ips has been synced: `n$syncsql_Result "
           "token"= "8s8d9s9fs991"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)

	  }

	  "!fivemdumps"  {
		#The user wants to stop the script

        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername) has requested to get a list of all the available fivem backups."
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)

        $fivemdumpscmd  = get-childitem -path 'F:\Fivem_Database_backup' -Name | sort-object -Descending | %{$_.replace(".sql","")}
        #Get-ChildItem D:\xampp\htdocs\Telegram\*.txt | foreach { Remove-Item -Path $_.FullName -Force}
        $randomnum = get-random -Minimum 100000 -Maximum 999999
        $fivemdumpscmd | out-file "D:\xampp\htdocs\Telegram\Fivem$($randomnum).txt"

        
        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername), The following backups are available:`n*http://gamers-il.com/telegram/Fivem$($randomnum).txt*`n(Available for 1 minute)"
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)

	  }

	  "!fivemdbbu *"  {
		#The user wants to stop the script
		$backupfile = ($LastMessageText -split ("/fivemdbbu "))[1] #This will remove "run "
        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername) has requested to upload backup for Gamers-IL Fivem RP server"
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
        

		 		#Run the command

            
            if((test-path F:\Fivem_Database_backup\$backupfile.sql) -eq $true){
            #Connecting to MYSQL
             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername), I'm Connecting to MySQ"
                   "token"= "8s8d9s9fs991"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)

            Connect-MySqlServer -Server localhost -UserName root -Password $RootPassword



            

            #Delete fivemtest Schema
             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername), I'm Deleting fivemnewserver schema and recreating it. "
                   "token"= "8s8d9s9fs991"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)


            Invoke-MySqlQuery –Query “drop database fivemnewserver”;
            Invoke-MySqlQuery –Query “create database fivemnewserver”;
            
            #Uploading database backup
             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername), I'm Importing the database backup "
                   "token"= "8s8d9s9fs991"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
            
            cmd.exe /c "D:\xampp\mysql\bin\mysql.exe -u root -pmoshL33TXD!noder fivemnewserver < F:\Fivem_Database_backup\$backupfile.sql" | Out-String | %  {
		    $backupfile_Result += "`n $($_)"
		  }
            Disconnect-MySqlServer
            

             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername), Backup should be uploaded, you can now turn on the service. "
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)


}else{
             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername),  backup name is wrong "
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)

}




	  }

	  "!blockip *"  {
		$ips = ($LastMessageText -split ("/blockip "))[1] #This will remove "run "
		#The user wants to stop the script


             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "Hi $($LastMessage.sendername), Request to block IP as been submited ""$($LastMessageText)""!"
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)


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

	  "!help"  {
		#The user wants to stop the script

             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "$($LastMessage.sendername), I'v listed the available commands below: `n *!run* * (Run commands on the dedicated server).`n *!syncnoip* (Sync the no-ip list). `n *!fivemdumps* (List all available fivem SQL backups). `n *!fivemdbbu [FIVEMDUMP]* (Restore fivem SQL Backup). `n *!blockip [IP]* (Block spesific IP, may not work. contact with mosh if so)."
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)


	  }

	  default  {
	    #The message sent is unknown
             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "Sorry $($LastMessage.sendername), but I don't understand ""$($LastMessageText)""!"
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
	  }
        
	}
   }else{

             $Message = @{
                   "destination"= "$($whatsappgroup)"
                   "message"= "Sorry $($LastMessage.sendername), but nice try running ""$($LastMessageText)""(btw your ip name and username and Phone number has reported to mosh :)!"
                   "token"= "8s8d9s9fs991"
                   "messageid"= "$($LastMessage.messageid)"
                    }
            $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
    }
	
  }
  
}

pause