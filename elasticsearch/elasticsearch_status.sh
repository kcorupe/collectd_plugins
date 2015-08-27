#!/bin/bash

HOSTNAME="${COLLECTD_HOSTNAME:-localhost}"
INTERVAL="${COLLECTD_INTERVAL:-5}"

get_health_status(){
  HEALTH_STATUS=$(curl -silent http://localhost:9200/_cluster/health)
}

get_color_status() {
  color_status=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $2}' | awk -F ':' '{print $2}' | sed 's/"//g' )
  case $color_status in
	red)
	  color_code="2"
	  ;;
	yellow)
	  color_code="1"
	  ;;
	green)
	  color_code="0"
	  ;;
  esac
}

get_number_of_nodes() {
  number_of_nodes=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $4}' | awk -F ':' '{print $2}')
}

get_number_of_nodes() {
  number_of_nodes=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $4}' | awk -F ':' '{print $2}')
}

get_number_of_data_nodes() {
  number_of_data_nodes=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $5}' | awk -F ':' '{print $2}')
}

get_active_primary_shards() {
  active_primary_shards=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $6}' | awk -F ':' '{print $2}')
}

get_active_shards() {
  active_shards=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $7}' | awk -F ':' '{print $2}')
}

get_relocating_shards() {
  relocating_shards=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $8}' | awk -F ':' '{print $2}')
}

get_initializing_shards() {
  initializing_shards=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $9}' | awk -F ':' '{print $2}')
}

get_unassigned_shards() {
  unassigned_shards=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $10}' | awk -F ':' '{print $2}')
}

get_delayed_unassigned_shards() {
  delayed_unassigned_shards=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $11}' | awk -F ':' '{print $2}')
}

get_number_of_pending_tasks() {
  number_of_pending_tasks=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $12}' | awk -F ':' '{print $2}')
}

get_number_of_in_flight_fetch() {
  number_of_in_flight_fetch=$(echo ${HEALTH_STATUS} | awk -F ',' '{print $13}' | awk -F ':' '{print $2}' | sed 's/}//g')
}

while sleep "$INTERVAL"; do

  # Get Current Status
  get_health_status

  # Get Values
  get_color_status
  get_number_of_nodes
  get_number_of_data_nodes
  get_active_primary_shards
  get_active_shards
  get_relocating_shards
  get_initializing_shards
  get_unassigned_shards
  get_delayed_unassigned_shards
  get_number_of_pending_tasks
  get_number_of_in_flight_fetch

  # Report Values
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-cluster_status interval=$INTERVAL N:$color_code"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-number_of_nodes interval=$INTERVAL N:$number_of_nodes"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-number_of_data_nodes interval=$INTERVAL N:$number_of_data_nodes"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-active_primary_shards interval=$INTERVAL N:$active_primary_shards"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-active_shards interval=$INTERVAL N:$active_shards"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-relocating_shards interval=$INTERVAL N:$relocating_shards"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-initializing_shards interval=$INTERVAL N:$initializing_shards"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-unassigned_shards interval=$INTERVAL N:$unassigned_shards"
  echo "PUTVAL $HOSTNAME/exec-elasticsearch/gauge-number_of_pending_tasks interval=$INTERVAL N:$number_of_pending_tasks"

done

