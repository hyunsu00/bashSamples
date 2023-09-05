#!/usr/bin/env bash

# 선택문(case)
# 정규식을 지원하며 | 기호로 다중 값을 입력 가능하며 조건의 문장 끝에는 ;; 기호로 끝을 표시한다.
# 참고: 대문자와 소문자는 다른 문자다

# case문 테스트를 위한 반복문
for string in "HELLO" "WORLD" "hello" "world" "s" "start" "end" "etc"; do

    # case문 시작
    case ${string} in
        hello|HELLO)
            echo "${string}: hello 일때"
            ;;
        wo*)
            echo "${string}: wo로 시작하는 단어 일때"
            ;;
        s|start)
            echo "${string}: s 혹은 start 일때"
            ;;
        e|end)
            echo "${string}: e 혹은 end 일때"
            ;;
        *)
            echo "${string}: 기타"
            ;;
    esac
    # //case문 끝

done