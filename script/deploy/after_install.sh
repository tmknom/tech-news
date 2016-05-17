#!/bin/bash
current_dir="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"
/usr/local/bin/fab after_install  -f ${current_dir}/fabfile.py

