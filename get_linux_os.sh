#!/usr/bin/env bash

# 리눅스 OS 이름 반환
get_linux_os_name() {
    local result=`grep '^ID' /etc/os-release | head -n 1 | cut -d= -f2- | sed 's/"//g'`
    echo "${result}"
}

# 리눅스 OS 버전 반환
get_linux_os_version() {
    local result=`grep '^VERSION_ID' /etc/os-release | cut -d= -f2- | sed 's/"//g'`
    echo "${result}"
}

_exe(){
    [ $1 == on  ] && { set -x; return; } 2>/dev/null
    [ $1 == off ] && { set +x; return; } 2>/dev/null
    echo + "$@"
    "$@"
}
exe(){
    { _exe "$@"; } 2>/dev/null
}

main() {
    echo "[main() : begin("${BASH_SOURCE[0]}")]"

    {
        echo "get_linux_os_name = $(get_linux_os_name)"
        echo "get_linux_os_version = $(get_linux_os_version)"
    }
    
    echo "[main() : end("${BASH_SOURCE[0]}")]"
}

# 스크립트를 직접 실행시 또는 bashdb시 main 함수 호출
if [[ "${BASH_SOURCE[0]}" == "${0}" || "${0}" =~ bashdb ]]; then
    main "$@"
fi