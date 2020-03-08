#!/bin/bash

ONLINE_API="" # Define your Online API key. You can find it at https://console.online.net/fr/api/access
DOMAIN="" ## Your domain name, eg : example.com
SUB="" ## Your subdomain you want to update. For example, "home" for "home.example.com"

# Now son, don't touch the following.
TYPE="A"
IPYET=$(dig +short $SUB.$DOMAIN)
ADDRESS=$(curl -s ifconfig.me)

#Check if there is a new IP to update, if not the API will not be called.
if [ "$IPYET" != "$ADDRESS" ]
then
	# Check if address is IPv4 or IPv6.
	if [[ $ADDRESS =~ ":" ]]
	then
        	TYPE="AAAA"
	fi

	# Call Online API
	curl -H "Authorization: Bearer $ONLINE_API" -X PATCH --data "[{\"name\": \"$SUB\",\"type\": \"$TYPE\",\"changeType\": \"REPLACE\",\"records\": [{\"name\": \"$SUB\",\"type\": \"$TYPE\",\"priority\": 0,\"ttl\": 3600,\"data\": \"$ADDRESS\"}]}]" "https://api.online.net/api/v1/domain/$DOMAIN/version/active"

else
	echo Ip stay the same !
fi

#End.
