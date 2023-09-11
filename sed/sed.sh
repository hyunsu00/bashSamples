#!/usr/bin/env bash

# `#` 문자를 포함하는 줄 삭제
# ${FILTER_SERVER_HOME} 을 ./Bin으로 치환
sed -i '/#/d; s/\${FILTER_SERVER_HOME}/.\/Bin/' "text copy.txt"
