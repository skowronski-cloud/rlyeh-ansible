#!/bin/bash
date=`date +%s`
curl -s https://justjoin.it/api/offers > /jjit/api_$date.json
