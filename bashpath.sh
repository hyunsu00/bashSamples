#!/usr/bin/env bash

# 실행파일 경로 ($ ./bashSampele/bashpath.sh => ./bashSampele/bashpath.sh)
printf "\$0 = "
printf "$0\n"

# 실행파일 이름
printf "\$( basename \"\$0\" ) = "
printf "$( basename "$0" )\n"

# 실행파일 경로 ($ ./bashSampele/bashpath.sh => ./bashSample)
printf "\$( dirname \"\$0\" ) = "
printf "$( dirname "$0" )\n"

# 현재 작업 경로
printf "\$( pwd ) = "
printf "$( pwd )\n"

# 실행파일의 절대 경로 구함 (-P시 symbolic link라면 원본파일의 경로 구함)
printf "\$(cd \"\$( dirname \"\$0\" )\" && pwd -P ) = "
printf "$(cd "$( dirname "$0" )" && pwd -P )\n"

cd $(pwd)
cd .

echo "$(pwd)"