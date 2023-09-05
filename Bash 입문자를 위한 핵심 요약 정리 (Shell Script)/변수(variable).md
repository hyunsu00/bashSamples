## 변수(Variable)
변수 사용시에는 "=" 기호 앞뒤로 공백이 없이 입력하면 대입연산자가 된다.  
그리고 선언된 변수는 기본적으로 전역 변수(global variable)다. 단 함수 안에서만 지역 변수(local variable)를 사용할 수 있는데  
사용할려면 변수 명 앞에 **local**을 붙여주면 된다.  
그런데 전역 변수는 현재 실행된 스크립트 파일에서만 유효하다. 자식 스크립트에서는 사용 할 수 없는 변수다.  
변수 명 앞에 **export**을 붙여주면 환경 변수(environment variable)로 설정되어 자식 스크립트에서 사용 가능하다.  
환경 변수 사용시 예약 변수(reserved variable)에 주의하자.(참고로 환경 변수는 **.bash_profile**에서 정의한다.)  

## 예약 변수(Reserved Variable)

 **문자** | **설명** 
---|---
 HOME | 사용자의 홈 디렉토리 
 PATH | 실행 파일을 찾을 경로 
 LANG | 프로그램 사용시 기본 지원되는 언어 
 PWD | 사용자의 현재 작업중인 디렉토리 
 FUNCNAME | 현재 함수 이름 
 SECONDS | 스크립트가 실행된 초 단위 시간 
 SHLVL | 쉘 레벨(중첩된 깊이를 나타냄) 
 SHELL | 로그인해서 사용하는 쉘 
 PPID | 부모 프로세스의 PID 
 BASH | BASH 실행 파일 경로 
 BASH_ENV | 스크립트 실행시 BASH 시작 파일을 읽을 위치 변수 
 BASH_VERSION | 설치된 BASH 버전 
 BASH_VERSINFO | BASH_VERSINFO[0]~BASH_VERSINFO[5]배열로 상세정보 제공 
 MAIL | 메일 보관 경로 
 MAILCHECK | 메일 확인 시간 
 OSTYPE | 운영체제 종류 
 TERM | 로긴 터미널 타입 
 HOSTNAME | 호스트 이름 
 HOSTTYPE | 시스템 하드웨어 종류 
 MACHTYPE | 머신 종류(HOSTTYPE과 같은 정보지만 조금더 상세하게 표시됨) 
 LOGNAME | 로그인 이름 
 UID | 사용자 UID 
 EUID | su 명령에서 사용하는 사용자의 유효 아이디 값(UID와 EUID 값은 다를 수 있음) 
 USER | 사용자의 이름 
 USERNAME | 사용자 이름 
 GROUPS | 사용자 그룹(/etc/passwd 값을 출력) 
 HISTFILE | history 파일 경로 
 HISTFILESIZE | history 파일 크기 
 HISTSIZE | history 저장되는 개수 
 HISTCONTROL | 중복되는 명령에 대한 기록 유무 
 DISPLAY | X 디스플레이 이름 
 IFS | 입력 필드 구분자(기본값: &nbsp; - 빈칸) 
 VISUAL | VISUAL 편집기 이름 
 EDITOR | 기본 편집기 이름 
 COLUMNS | 현재 터미널이나 윈도우 터미널의 컬럼 수 
 LINES | 터미널의 라인 수 
 LS_COLORS | ls 명령의 색상 관련 옵션 
 PS1 | 기본 프롬프트 변수(기본값: bash\$) 
 PS2 | 보조 프롬프트 변수(기본값: &gt;), 명령을 "\"를 사용하여 명령 행을 연장시 사용됨 
 PS3 | 쉘 스크립트에서 select 사용시 프롬프트 변수(기본값: #?) 
 PS4 | 쉘 스크립트 디버깅 모드의 프롬프트 변수(기본값: +) 
 TMOUT | 0이면 제한이 없으며 time시간 지정시 지정한 시간 이후 로그아웃 

## 위치 매개 변수(Positional Parameters)

 **문자** | **설명** 
---|---
 $0 | 실행된 스크립트 이름 
 $1 | $1 $2 $3...${10}인자 순서대로 번호가 부여된다. 10번째부터는 "{}"감싸줘야 함 
 $* | 전체 인자 값 
 $@ | 전체 인자 값($* 동일하지만 쌍따옴표로 변수를 감싸면 다른 결과 나옴) 
 $# | 매개 변수의 총 개수 

## 특수 매개 변수(Special Parameters)

 **문자** | **설명** 
---|---
 $\$ | 현재 스크립트의 PID 
 $? | 최근에 실행된 명령어, 함수, 스크립트 자식의 종료 상태 
 $! | 최근에 실행한 백그라운드(비동기) 명령의 PID 
 $- | 현재 옵션 플래그 
 $_ | 지난 명령의 마지막 인자로 설정된 특수 변수 

## 매개 변수 확장(Parameter Expansion)
> [!IMPORTANT]
> 아래 예를 테스트하기 위한 변수: string="abc-efg-123-abc"

 **문자** | **설명** 
---|---
 ${변수} | $변수와 동일하지만 {} 사용해야만 동작하는 것들이 있음(예: echo ${string}) 
 ${변수:위치} | 위치 다음부터 문자열 추출(예: echo ${string:4}) 
 ${변수:위치:길이} | 위치 다음부터 지정한 길이 만큼의 문자열 추출(예: echo ${string:4:3}) 
 ${변수:-단어} | 변수 미선언 혹은 NULL일때 기본값 지정, 위치 매개 변수는 사용 불가(예: echo ${string:-HELLO}) 
 ${변수-단어} | 변수 미선언시만 기본값 지정, 위치 매개 변수는 사용 불가(예: echo ${string-HELLO}) 
 ${변수:=단어} | 변수 미선언 혹은 NULL일때 기본값 지정, 위치 매개 변수 사용 가능(예: echo ${string:=HELLO}) 
 ${변수=단어} | 변수 미선언시만 기본값 지정, 위치 매개 변수 사용 가능(예: echo ${string=HELLO}) 
 ${변수:?단어} | 변수 미선언 혹은 NULL일때 단어 출력 후 스크립트 종료,(예: echo ${string:?HELLO}) 
 ${변수?단어} | 변수 미선언시만 단어 출력 후 스크립트 종료(예: echo ${string?HELLO}) 
 ${변수:+단어} | 변수 선언시만 단어 사용(예: echo ${string:+HELLO}) 
 ${변수+단어} | 변수 선언 혹은 NULL일때 단어 사용(예: echo ${string+HELLO}) 
 ${#변수} | 문자열 길이(예: echo ${#string}) 
 ${변수#단어} | 변수의 앞부분부터 짧게 일치한 단어 삭제(예: echo ${string#a*b}) 
 ${변수##단어} | 변수의 앞부분부터 길게 일치한 단어 삭제(예: echo ${string##a*b}) 
 ${변수%단어} | 변수의 뒷부분부터 짧게 일치한 단어 삭제(예: echo ${string%b*c}) 
 ${변수%%단어} | 변수의 뒷부분부터 길게 일치한 단어 삭제(예: echo ${string%%b*c}) 
 ${변수/찾는단어/변경단어} | 처음 일치한 단어를 변경(예: echo ${string/abc/HELLO}) 
 ${변수//찾는단어/변경단어} | 일치하는 모든 단어를 변경(예: echo ${string//abc/HELLO}) 
 ${변수/#찾는단어/변경단어} | 앞부분이 일치하면 변경(예: echo ${string/#abc/HELLO}) 
 ${변수/%찾는단어/변경단어} | 뒷부분이 일치하면 변경(예: echo ${string/%abc/HELLO}) 
 ${!단어*}, ${!단어@} | 선언된 변수중에서 단어가 포함된 변수 명 추출(예: echo ${!string*}, echo ${!string@}) 

## 배열(Array Variable)
배열 변수 사용은 반드시 괄호를 사용해야 한다.(예: ${array[1]})  
참고: 1차원 배열만 지원함