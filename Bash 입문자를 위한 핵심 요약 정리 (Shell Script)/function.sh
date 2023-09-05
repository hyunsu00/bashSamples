#!/usr/bin/env bash

# 함수(Function)
# 형식은 다른 언어와 차이는 없다. 그러나 function는 생략해도 된다.
# 함수 명을 쓰면 함수가 호출이 되는데 주의할 것은 호출 코드가 함수 코드보다 반드시 뒤에 있어야 된다. 
# 함수 코드 보다 앞에서 호출 시 오류가 발생한다.
string_test() {
    echo 'string_test'
}

function string_test2 () {
    echo "string_test2 begin"
    # 모든 인자 출력
    echo "인자값: ${@}"
    echo "인자값: $@"
    echo "string_test2 end"
}

function string_test3 () {
    echo "string_test3 begin"
    # 모든 인자 출력
    echo "인자값: ${@}"
    echo "인자값: $@"
    # 1, 2 인자 출력
    echo "인자값: $1 $2"
    echo "string_test3 end"
}

function name () {
    echo "$1" # arguments are accessible through $1, $2,...
}

string_test
string_test2
string_test3

# 함수에 인자값 전달하기(공백의로 뛰어서 2개의 인자값을 넘김)
string_test2 "hello" "world"
string_test3 "hello" "world"