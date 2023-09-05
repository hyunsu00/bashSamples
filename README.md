# bashSamples

## 참고)
[Bash 입문자를 위한 핵심 요약 정리 (Shell Script)](https://blog.gaerae.com/2015/01/bash-hello-world.html)  
[Bash Shell - 조건문(if-else)](https://codechacha.com/ko/shell-script-if-else/)  
[고급 Bash 스크립팅 가이드](https://wiki.kldp.org/HOWTO/html/Adv-Bash-Scr-HOWTO/)  
[Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)  
[Uinx/Linux: Shebang과 env에 대한 설명 (#!/usr/bin/env)](https://blog.gaerae.com/2015/10/what-is-the-preferred-bash-shebang.html)  

## 주의사항

1. **Shebang 사용**: 스크립트 파일의 첫 번째 줄에 Shebang (`#!`)을 사용하여 스크립트가 실행될 해석기를 지정하세요. 
    - 예를 들어, Bash 스크립트를 작성하면 `#!/bin/bash`를 사용하여 Bash 해석기를 지정합니다.
2. **변수 할당**: 변수를 할당할 때 변수 이름과 할당 연산자(**`=`**) 사이에 **공백이 없어야 합니다.** 
    - 예를 들어, `name="John"`과 같이 사용합니다.
3. **변수 참조**: 변수를 참조할 때 `$` 기호를 사용하세요. 
    - 예를 들어, `$name`은 "name" 변수의 값을 나타냅니다.
4. **따옴표 사용**: 문자열에 따옴표를 사용하여 문자열의 시작과 끝을 나타냅니다. 일반적으로 더블 따옴표(`"`)나 단일 따옴표(`'`)를 사용합니다. 더블 따옴표는 변수 확장이 가능하며, **단일 따옴표는 변수 확장이 불가능합니다.**
    - 더블 따옴표: `message="Hello, $name"` => $name 확장됨
    - 단일 따옴표: `message='Hello, $name'` => $name으로 출력
5. **주석**: 주석은 코드를 설명하고 문서화하는 데 도움이 됩니다. 주석은 `#` 기호로 시작하며, `#` 뒤에 주석 내용을 작성합니다.
6. **조건문 및 반복문**: 조건문(if)과 반복문(for, while)을 사용할 때 정확한 구문을 사용하세요. 이들은 특정한 문법을 따릅니다. 
    - 예를 들어, if 문은 `if [ 조건 ]; then`과 같은 형식을 따릅니다.
7. **커맨드 실행**: 다른 커맨드를 실행할 때, 역따옴표( \` ) 또는 `$()`를 사용하여 명령을 실행하고 그 결과를 변수에 저장할 수 있습니다.
    - current_date=\`date\` => 역따옴표는 권장되지 않음
    - current_date=`$(date)`
8. **줄 바꿈**: 스크립트를 작성할 때, 명령어나 문장이 길어질 경우 줄 바꿈을 사용하여 가독성을 높이세요. 
    - 백슬래시(`\`)를 사용하거나 큰 따옴표(`"`) 내에서 줄 바꿈을 할 수 있습니다.
    ```bash
    multiline_string="This is a multiline string.
    It spans across multiple lines.
    Each line is terminated by a newline character (\n)."
    
    echo -e "$multiline_string"  # -e 옵션을 사용하여 이스케이프 시퀀스를 해석합니다.
    ```
9. **변수 확장**: 변수 확장을 사용할 때 중괄호 `{}`를 사용하여 변수 이름을 명확하게 구분하세요. 
    - `${var}`와 같이 사용합니다.
10. **오류 처리**: 스크립트에서 오류 처리를 위해 `set -e` 또는 `set -o errexit`를 사용하여 오류가 발생하면 스크립트가 종료되도록 설정할 수 있습니다.
11. **특수 문자 이스케이프**: 특수 문자를 사용할 때 이스케이프(`\`)를 사용하여 특수 문자의 의미를 해석하지 않도록 조심하세요.
12. **파일 및 디렉토리 경로**: 파일 및 디렉토리 경로를 사용할 때, **상대 경로와 절대 경로를 정확하게 구분**하세요.
13. **인용 부호 주의**: 인용 부호가 여닫는 부분이 맞아야 합니다. 따옴표나 큰 따옴표의 여닫는 부분을 정확히 맞추세요.