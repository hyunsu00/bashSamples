#!/usr/bin/env bash

# 클래스 모방을 위한 함수 정의
create_person() {
    local name="$1"
    local age="$2"

    # 객체의 속성 정의 (변수로 표현)
    person_name="$name"
    person_age="$age"

    # 객체의 메서드 정의 (함수로 표현)
    introduce() {
        echo "_안녕하세요, 저는 $name이고, $name살입니다."
        echo "안녕하세요, 저는 $person_name이고, $person_age살입니다."
    }
}

echo $person_name
echo $person_age

# Person 클래스의 인스턴스 생성
create_person "Alice" 25

# 메서드 호출을 통한 객체 동작
introduce

