#!/usr/bin/env bash

# 반복문(for, while, until)
# 반목문 작성 시 아래 명령어(흐름제어)을 알아두면 좋다.
# 반복문을 빠져 나갈때: break
# 현재 반복문이나 조건을 건너 뛸때: continue

# 지정된 범위 안에서 반복문 필요 시 좋음
for string in "hello" "world" "..."; do
    echo ${string};
done

# 수행 조건이 true 일때 실행됨 (실행 횟수 지정이 필요하지 않은 반복문 필요 시 좋음)
count=0
while [ ${count} -le 5 ]; do
    echo ${count}
    count=$(( ${count}+1 ))
done

# 수행 조건이 false 일때 실행됨 (실행 횟수 지정이 필요하지 않은 반복문 필요 시 좋음)
count2=10
until [ ${count2} -le 5 ]; do
    echo ${count2}
    count2=$(( ${count2}-1 ))
done