## 디버깅(Debugging)

간단하게는 **echo**, **exit** 명령나 **tee** 명령어로 디버깅한다.
다른 방법으로 실행 시 옵션을 주거나 코드에 한줄만 추가하면 해볼수 있다.

 **Bash 옵션(스크립트 실행 시)** | **set 옵션(스크립트 코드 삽입)** | **설명** 
---|---|---
 bash -n | set -n, set -o noexec | 스크립트 실행없이 단순 문법 오류만 검사(찾지 못하는 문법 오류가 있을수 있음) 
 bash -v | set -v, set -o verbose | 명령어 실행전 해당 명령어 출력(echo) 
 bash -x | set -x, set -o xtrace | 명령어 실행후 해당 명령어 출력(echo) 
 &nbsp;  | set -u, set -o nounset | 미선언된 변수 발견시 "unbound variable" 메시지 출력 

## 마무리하며
여기서 인자(argument)와 매개변수(parameter)는 이름만 다를 뿐 의미는 같다.
Bash는 공백에 민감하다.
변수 사용은 생각하지 말고 ${변수} 이렇게 쓰자.