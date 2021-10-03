$Message = '{"destination": "972544911249@c.us","message": "sup", "token": "8s8d9s9fs991", "messageid": "false_972544911249@c.us_3AE17BEEC99938ED9F6D"}'
Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body $Message


#Web get english format
#http://localhost:8080/send?destination=972544911249@c.us&message=test&token=8s8d9s9fs991


$Message = '{"destination": "972544911249@c.us","message": "sup", "token": "8s8d9s9fs991", "messageid": "false_972544911249@c.us_3AE17BEEC99938ED9F6D"}'

$Message = '{"destination": "972544911249@c.us","message": "sup", "token": "8s8d9s9fs991"}'

		$ExitMessage = "$($LastMessage.sender) has requested the script to be terminated. It will need to be started again in order to accept new messages!"
		$ExitRestResponse = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($ExitMessage)&parse_mode=html"




        $Message = "$($LastMessage.sender) has requested to sync no-ip for mysql."
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"



        $Message = @{
           "destination"= "$($whatsappgroup)"
           "message"= "$($LastMessage.sendername), The following backups are available:`n*http://gamers-il.com/telegram/Fivem$($randomnum).txt*`n(Available for 1 minute)"
           "token"= "8s8d9s9fs991"
           "messageid"= "$($LastMessage.messageid)"
            }
        $SendMessage = Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body ($Message | ConvertTo-Json)
      


        $Message = "$($LastMessage.sender), The following no-ips has been synced: `n$syncsql_Result "
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"



		$Message = "$($LastMessage.sendername) has requested to get a list of all the available fivem backups."
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"


		$Message = "$($LastMessage.sender), The following backups are available:`n <a href='http://gamers-il.com/telegram/Fivem$($randomnum).txt'>Click Here (Available for 1 minute)</a>"
		$SendMessage = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($BotToken)/sendMessage?chat_id=$($ChatID)&text=$($Message)&parse_mode=html"