#!/bin/bash
current_dir="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"
/usr/local/bin/fab validate_service  -f ${current_dir}/fabfile.py

