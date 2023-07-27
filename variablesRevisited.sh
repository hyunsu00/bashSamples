#!/usr/bin/env bash

# 변수 타입 지정(Variables Revisited)
# Bash 변수는 타입을 구분하지 않고 기본적으로 문자열이다. 단 문맥에 따라서 연산 처리한다.
# 그런데 불완전한 형태의 declare, typeset 타입 지정 명령을 지원한다.(두 명령은 동일함)
# 참고: 코멘트에 있는 다른 문법 사용을 추천한다.

# 읽기 전용
# readonly string_variable="hello world" 문법과 동일 함
declare -r string_variable

# 정수
# number_variable=10 문법과 동일 함
declare -i number_variable=10

# 배열
# array_variable=() 문법과 동일 함
declare -a array_variable

# 환경 변수
# export export_variable="hello world" 문법과 동일 함
declare -x export_variable="hello world"

# 현재 스크립트의 전체 함수 출력
declare -f

# 현재 스크립트에서 지정한 함수만 출력
declare -f 함수이름