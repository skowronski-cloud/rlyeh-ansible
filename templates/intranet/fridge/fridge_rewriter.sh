#!/bin/bash
cd /srv/fridge/dynamic/

/usr/bin/curl 'https://api.openweathermap.org/data/3.0/onecall?lat={{ owm_lat }}&lon={{ owm_lon }}&appid={{ owm_token }}&units=metric' > onecall.json.tmp
mv onecall.json.tmp onecall.json