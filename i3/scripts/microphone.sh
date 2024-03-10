#!/bin/bash

# Left click
if [[ "${BLOCK_BUTTON}" -eq 4 ]]; then
amixer -q sset Capture 5%+
# Middle click
elif [[ "${BLOCK_BUTTON}" -eq 3 ]]; then
  amixer -q sset Capture toggle
# Right click
elif [[ "${BLOCK_BUTTON}" -eq 5 ]]; then
  amixer -q sset Capture 5%-
fi

statusLine=$(amixer get Capture | tail -n 1)
status=$(echo "${statusLine}" | grep -wo "on")
volume1=$(echo "${statusLine}" | awk -F ' ' '{print $5}' | tr -d '[]%')
volume2=$(echo "${statusLine}" | awk -F ' ' '{print $4}' | tr -d '[]%')

if [[ "${status}" == "on" ]]; then
  if [[ "${volume1}" == "on" ]]; then
    echo "${volume2}%"
    echo ""
  else
    echo "${volume1}%"
    echo ""
  fi
else
  echo "off"
  echo ""
fi
