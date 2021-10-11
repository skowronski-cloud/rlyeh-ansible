#!/bin/bash

function getMeasurment {
  echo 'SELECT mean("'$1'") FROM "feinstaub" WHERE  time > now() - 5m;' | \
  influx -host 10.0.5.1 -port 8086 -username {{ influx_grafana_user }} -password {{ influx_grafana_pass }} -database luftdaten -format csv | \
  tail -n1 | awk -F, '{print $3}'
}

echo '{"temp":"'`getMeasurment "BME280_temperature"`'","pm10":"'`getMeasurment "SDS_P1"`'","pressure":"'`getMeasurment "BME280_pressure"`'","humidity":"'`getMeasurment "BME280_humidity"`'"}' > /srv/fridge/dynamic/influx.json

