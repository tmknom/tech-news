#!/bin/bash
current_dir="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"
/usr/local/bin/fab application_stop  -f ${current_dir}/fabfile.py

