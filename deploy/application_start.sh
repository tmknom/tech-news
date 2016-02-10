#!/bin/bash
current_dir="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"
/usr/local/bin/fab application_start  -f ${current_dir}/fabfile.py

