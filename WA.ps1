Invoke-WebRequest -Uri http://localhost:8080/ -Method POST -Body $Message


#Web get english format
#http://localhost:8080/send?destination=972544911249@c.us&message=test&token=8s8d9s9fs991


$Message = '{"destination": "972544911249@c.us","message": "sup", "token": "8s8d9s9fs991", "messageid": "false_972544911249@c.us_3AE17BEEC99938ED9F6D"}'

$Message = '{"destination": "972544911249@c.us","message": "sup", "token": "8s8d9s9fs991"}'
