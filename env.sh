#!/usr/bin/env bash

# 검사할 환경 변수 이름
target_variable="MY_ENV_VAR"

# 환경 변수의 존재 여부 확인
if [ -n "${!target_variable}" ]; then
  echo "환경 변수 '$target_variable'의 값은: ${!target_variable}"
else
  echo "환경 변수 '$target_variable'이(가) 정의되지 않았습니다."
fi

if [[ "${string1}" == "${string2}" ]]; then
    echo "The two strings are the same"
fi

if [ "$(command -v command)" ]; then
    echo "command \"command\" exists on system"
fi

HNC_BIN_PATH=$PWD"./Bin";
echo $HNC_BIN_PATH