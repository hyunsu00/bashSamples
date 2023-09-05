#!/usr/bin/env bash

# 배열(Array Variable)
# 배열 변수 사용은 반드시 괄호를 사용해야 한다.(예: ${array[1]})
# 참고: 1차원 배열만 지원함

# 배열의 크기 지정없이 배열 변수로 선언
# 참고: 'declare -a' 명령으로 선언하지 않아도 배열 변수 사용 가능함
declare -a array

# 4개의 배열 값 지정
array=("hello" "test" "array" "world")

# 기존 배열에 1개의 배열 값 추가(순차적으로 입력할 필요 없음)
array[4]="variable"

# 기존 배열 전체에 1개의 배열 값을 추가하여 배열 저장(배열 복사 시 사용)
array=(${array[@]} "string")

# 위에서 지정한 배열 출력
echo "hello world 출력: ${array[0]} ${array[3]}"
echo "배열 전체 출력: ${array[@]}"
echo "배열 전체 개수 출력: ${#array[@]}"

printf "배열 출력: %s\n" ${array[@]}

# 배열 특정 요소만 지우기
unset array[4]
echo "배열 전체 출력: ${array[@]}"

# 배열 전체 지우기
unset array
echo "배열 전체 출력: ${array[@]}"