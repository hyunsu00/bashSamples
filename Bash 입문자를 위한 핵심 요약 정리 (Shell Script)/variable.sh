#!/usr/bin/env bash

# 변수(Variable)
# 변수 사용시에는 "=" 기호 앞뒤로 공백이 없이 입력하면 대입연산자가 된다.
# 그리고 선언된 변수는 기본적으로 전역 변수(global variable)다. 단 함수 안에서만 지역 변수(local variable)를 사용할 수 있는데 
# 사용할려면 변수 명 앞에 local을 붙여주면 된다.
# 그런데 전역 변수는 현재 실행된 스크립트 파일에서만 유효하다. 자식 스크립트에서는 사용 할 수 없는 변수다.
# 변수 명 앞에 export을 붙여주면 환경 변수(environment variable)로 설정되어 자식 스크립트에서 사용 가능하다.
# 환경 변수 사용시 예약 변수(reserved variable)에 주의하자.(참고로 환경 변수는 .bash_profile에서 정의한다.)

# 전역 변수 지정
string="hello world"
echo ${string}

# 지역 변수 테스트 함수
string_test() {
    # 전역 변수와 동일하게 사용함. 만약 local 뺀다면 전역 변수에 덮어씌어지게 됨
    local string="local"
    echo ${string}
}
# 지역 변수 테스트 함수 호출
string_test
# 지역 변수 테스트 함수에서 동일한 변수 명을 사용했지만 값이 변경되지 않음
echo ${string}

# 환경 변수 선언
export hello_world="hello world..."
# 자식 스크립트 호출은 스크립트 경로을 쓰면된다.
/home/export_test.sh

#환경 변수를 테스트하기 위해 export_test.sh 파일을 만들고 선언한 변수를 확인해본다.
echo ${hello_world}