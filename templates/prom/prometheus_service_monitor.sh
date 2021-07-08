#!/bin/bash
DATE=`date +"%s"`
PROMETHEUS_URL=http://10.0.9.1:9090/status
ALERTMANAGER_URL=http://10.0.9.1:9093/-/healthy
PD_URL=https://events.pagerduty.com/v2/enqueue
FAIL_FILE=/tmp/prometheus_is_dead

PROMETHEUS_RESP_CODE=`curl -s -o /dev/null -w "%{http_code}" $PROMETHEUS_URL`
ALERTMANAGER_RESPONSE=`curl -s $ALERTMANAGER_URL | grep OK`

if [[ $PROMETHEUS_RESP_CODE -ne 200 || $ALERTMANAGER_RESPONSE != "OK" ]];
then
  echo "** PROMETHEUS_IS_DEAD **"
  if [[ -f $FAIL_FILE ]];
  then
    echo "** THIS_IS_ONGOING_INCIDENT **"
    EVENT_ID=`cat $FAIL_FILE`
  else
    echo "** THIS_IS_NEW_INCIDENT **"
    echo '{"routing_key": "{{ prometheus_service_monitor_pd_key }}", "event_action":"trigger", "payload": {"summary": "[CRITICAL] PROMETHEUS OR ALERTMANAGER SERVICE IS DEAD", "source":"{{ ansible_host }}", "severity":"critical", "custom_details": { "PROMETHEUS_RESPONSE": "'$PROMETHEUS_RESP_CODE'", "ALERTMANAGER_RESPONSE": "'$ALERTMANAGER_RESPONSE'" } }, "dedup_key":"prometheus_is_dead_'$DATE'"}' > "${FAIL_FILE}_payload"
    cat "${FAIL_FILE}_payload"
    /usr/bin/curl -X POST $PD_URL -H "Content-Type: application/json" --data-binary @"${FAIL_FILE}_payload"
    echo $DATE > $FAIL_FILE
  fi

else
  echo "** PROMETHEUS_IS_ALIVE **"
  if [[ -f $FAIL_FILE ]];
  then  
    echo "** RESOLVING_INCIDENT **"
    EVENT_ID=`cat $FAIL_FILE`
    echo '{"routing_key": "{{ prometheus_service_monitor_pd_key }}", "event_action":"resolve","dedup_key":"prometheus_is_dead_'$EVENT_ID'"}' > "${FAIL_FILE}_payload"
    cat "${FAIL_FILE}_payload"
    /usr/bin/curl -X POST $PD_URL -H "Content-Type: application/json" --data-binary @"${FAIL_FILE}_payload"
    rm $FAIL_FILE "${FAIL_FILE}_payload"
  fi
fi