#!/usr/bin/env bash


xtrace_on() {
    { set -x; return; } 2>/dev/null
}

xtrace_off() {
    { set +x; return; } 2>/dev/null
}

_xtrace() {
    # 매개변수가 'on' 일 경우 셀스크립트 디버깅 모드로 설정 및 표준에러 메시지는 출력하지 않는다.
    [ $1 == on  ] && { set -x; return; } 2>/dev/null

    # 매개변수가 'off' 일 경우 셀스크립트 디버깅 모드 해제 및 표준에러 메시지는 출력하지 않는다.
    [ $1 == off ] && { set +x; return; } 2>/dev/null

    echo + "$@"
    "$@"
}

xtrace() {
    { _xtrace "$@"; } 2>/dev/null
}

main() {
    echo "[main() : begin("${BASH_SOURCE[0]}")]"

    {
        xtrace on
        echo "123"
        xtrace off
    }
    
    echo "[main() : end("${BASH_SOURCE[0]}")]"
}

# 스크립트를 직접 실행시 또는 bashdb시 main 함수 호출
if [[ "${BASH_SOURCE[0]}" == "${0}" || "${0}" =~ bashdb ]]; then
    main "$@"
fi