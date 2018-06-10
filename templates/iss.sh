#!/bin/bash

while true
do
    livestreamer "{{ iss_stream_url }}" "{{ iss_video_format }}" \
        --player omxplayer \
        --fifo \
        --player-args "{% if iss_omx_resolution %}--win \"0 0 {{ iss_omx_resolution[0] }} {{ iss_omx_resolution[1] }}\" {% endif %}{filename}"
done

