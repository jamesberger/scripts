#!/bin/bash

load=$(uptime | cut -d' ' -f 15 | tr -d ",")

echo $load
