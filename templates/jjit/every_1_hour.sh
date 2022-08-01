#!/bin/bash
date=`date +%s`
zip /jjit/hourly_api_$date.zip /jjit/api_*.json
rm /jjit/api_*.json
