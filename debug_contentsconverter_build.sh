#!/usr/bin/env bash

app="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $app/get_linux_os.sh

WORKSPACE_PATH=$(pwd -P)

build_middware() {
    local PRODUCT_VERSION="${1}"
    local PUBLISH="${2}"

    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local HOST_SRC_PATH="${CONTENTS_SRC_HOME}/middleware/host"
    local HOST_DEST_PATH="${HOST_SRC_PATH}/product"

    rm -rf ${HOST_DEST_PATH}
    mkdir -p ${HOST_DEST_PATH}

    sed -i 's/\$PRODUCT_VERSION\$/'"${PRODUCT_VERSION}"'/g' "${HOST_SRC_PATH}/docs2.py"
    sed -i 's/\$PRODUCT_NAME\$/Hancom Document Viewer/g' "${HOST_SRC_PATH}/docs2.py"

    if [ ${PUBLISH} == "ON" ]; then # 난독화버전
        # host 폴더의 *.py 파일을 ./procuct에 난독화 한다.
        for file in "${HOST_SRC_PATH}"/*.py; do
            echo "# -*- coding: utf-8 -*-" >${HOST_DEST_PATH}/$(basename "$file")
            ~/.local/bin/pyminifier --lzma "$file" | egrep -v "^#" >>${HOST_DEST_PATH}/$(basename "$file")
        done
        # host/addin 폴더의 *.py 파일을 ./procuct/addin에 난독화 한다.
        ADDIN_SRC_PATH="${HOST_SRC_PATH}/addin"
        if [ -d "${ADDIN_SRC_PATH}" ]; then
            ADDIN_DEST_PATH="${HOST_SRC_PATH}/product/addin"
            if [ ! -d "${ADDIN_DEST_PATH}" ]; then
                mkdir ${ADDIN_DEST_PATH}
            fi
            # .py 파일들을 열거
            for file in "${ADDIN_SRC_PATH}"/*.py; do
                echo "# -*- coding: utf-8 -*-" >${ADDIN_DEST_PATH}/$(basename "$file")
                ~/.local/bin/pyminifier --lzma "$file" | egrep -v "^#" >>${ADDIN_DEST_PATH}/$(basename "$file")
            done
        fi
    else # 일반버전
        # host 폴더의 *.py 파일을 ./procuct에 복사한다.
        for file in "${HOST_SRC_PATH}"/*.py; do
            cp -f "$file" ${HOST_DEST_PATH}/$(basename "$file")
        done
        # host/addin 폴더의 *.py 파일을 ./procuct/addin에 복사한다.
        ADDIN_SRC_PATH="${HOST_SRC_PATH}/addin"
        if [ -d "${ADDIN_SRC_PATH}" ]; then
            ADDIN_DEST_PATH="${HOST_SRC_PATH}/product/addin"
            cp -rf ${ADDIN_SRC_PATH} ${ADDIN_DEST_PATH}
        fi
    fi
}

build_frontend() {
    local FRONT_BUILD_TARGET="${1}"

    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local MORFHIS_SRC_PATH="${CONTENTS_SRC_HOME}/morfhis"
    local NPM=$(which npm)

    rm -rf ${MORFHIS_SRC_PATH}/build

    cd ${MORFHIS_SRC_PATH}
    export REACT_APP_BUILD_LEVEL="${FRONT_BUILD_TARGET}"
    npm install
    npm run build
}

clear_release() {
    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    rm -rf ${RELEASE_HOME}
    mkdir -p ${RELEASE_HOME}
}

copy_filterserver() {
    local FILTERSERVER_SRC_PATH="${1}"
    local BUILD_FILE_NAME="${2}"
    local BUILD_CLI="${3}"
    
    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local FILTERSERVER_DEST_PATH="${RELEASE_HOME}/filterserver"
    local EXTRACE_FOLDER_NAME=$(tar -tf "${FILTERSERVER_SRC_PATH}/${BUILD_FILE_NAME}" | head -n 1 | awk -F'/' '{print $1}' | sed 's/-$//')

    # 빌드된 filterserver "${WORKSPACE_PATH}/release/filterserver/"에 복사
    {
        mkdir -p "${FILTERSERVER_DEST_PATH}"
        cp -rf ${FILTERSERVER_SRC_PATH}/${BUILD_FILE_NAME} ${FILTERSERVER_DEST_PATH}/
        cp -rf ${FILTERSERVER_SRC_PATH}/version.txt ${WORKSPACE_HOME}/FilterVersion.txt
        cp -rf ${FILTERSERVER_SRC_PATH}/ChangeLog.html ${WORKSPACE_HOME}/FilterChangeLog.html
        cp -rf ${FILTERSERVER_SRC_PATH}/HEAD ${WORKSPACE_HOME}/FilterHEAD

        # "${WORKSPACE_PATH}/release/filterserver/${EXTRACE_FOLDER_NAME}"에 압축풀기
        cd ${FILTERSERVER_DEST_PATH}/
        tar -xvf ${BUILD_FILE_NAME}
        rm -f ${BUILD_FILE_NAME}

        # 압축된 파일 "${WORKSPACE_PATH}/release/filterserver/"에 복사
        cd ${EXTRACE_FOLDER_NAME}
        cp -rf ./* ../
        cd ..
        rm -rf ${EXTRACE_FOLDER_NAME}

        if [ ${BUILD_CLI} == "ON" ]; then
            rm -f ${FILTERSERVER_DEST_PATH}/Bin/HncDocsConverterServer*
        else
            rm -f ${FILTERSERVER_DEST_PATH}/Bin/HncDocsConverterCLI*
        fi
    }
    
    # 추가폰트 복사
    local EXTRA_FONT_SRC_PATH="${WORKSPACE_PATH}/extrafonts"
    local EXTRA_FONT_DST_PATH="${FILTERSERVER_DEST_PATH}/Shared/TTF/All"
    cp -rf ${EXTRA_FONT_SRC_PATH}/* ${EXTRA_FONT_DST_PATH}/

    # agent 복사
    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local AGENT_SRC_PATH="${CONTENTS_SRC_HOME}/middleware/agent"
    if [[ "${BUILD_CLI}" == "OFF" ]]; then
        cp -rf ${AGENT_SRC_PATH}/ ${FILTERSERVER_DEST_PATH}/
    fi
}

copy_middware() {
    local BUILD_CLI="${1}"

    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local TEMPLATE_SRC_PATH="${WORKSPACE_PATH}/contentsconverter/documents/__template"
    local MIDDLEWARE_SRC_PATH="${CONTENTS_SRC_HOME}/middleware/host"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local MIDDLEWARE_DEST_PATH="${RELEASE_HOME}/middleware/host"
    local TEMPLATE_DEST_PATH="${RELEASE_HOME}/documents/__template"
    
    if [ ${BUILD_CLI} == "OFF" ]; then
        rm -rf ${MIDDLEWARE_DEST_PATH}
        mkdir -p ${MIDDLEWARE_DEST_PATH}
        rm -rf ${TEMPLATE_DEST_PATH}
		mkdir -p ${TEMPLATE_DEST_PATH}

        cp -rf ${MIDDLEWARE_SRC_PATH}/product/* ${MIDDLEWARE_DEST_PATH}/
        cp -rf ${MIDDLEWARE_SRC_PATH}/*.json ${MIDDLEWARE_DEST_PATH}/
        cp -rf ${TEMPLATE_SRC_PATH}/* ${TEMPLATE_DEST_PATH}/
    fi
}

copy_frontend() {
    local BUILD_CLI="${1}"

    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local FRONTEND_BUILD_PATH="${CONTENTS_SRC_HOME}/morfhis/build"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local FRONTEND_DEST_PATH="{RELEASE_HOME}/middleware/hdv"
    if [ ${BUILD_CLI} == "OFF" ]; then
        rm -rf ${FRONTEND_DEST_PATH}
        mkdir -p ${FRONTEND_DEST_PATH}

        cp -rf ${FRONTEND_BUILD_PATH}/* ${FRONTEND_DEST_PATH}
    fi
}

main() {
    echo "[main() : begin("${BASH_SOURCE[0]}")]"

    # exe on
    {
        MAJOR_VERSION="hotfix.m17.3"
        BUILD_NUMBER="999"
        BUILD_DATE=$(date +%Y%m%d)
        PRODUCT_VERSION="${MAJOR_VERSION}.${BUILD_NUMBER}(${BUILD_DATE})"
        PUBLISH="ON"
        build_middware $PRODUCT_VERSION $PUBLISH

        FRONT_BUILD_TARGET="release"
        build_frontend $FRONT_BUILD_TARGET

        clear_release

        CORE_BUILD_NUMBER="5"
        CORE_BUILD_DATE="20231208"
        LAST_BUILD_FOLDER="${CORE_BUILD_DATE}-${CORE_BUILD_NUMBER}"
        FILTER_BUILD_JOB="docsconverter-2021-v2-hdv-rhel92-build"
        FILTERSERVER_SRC_PATH="${WORKSPACE_PATH}/../${FILTER_BUILD_JOB}/build/${LAST_BUILD_FOLDER}"
        BUILD_FILE_NAME="hncfilterserver-11.90.0.5-Linux.tar.bz2"
        BUILD_CLI="OFF"
  
        copy_filterserver $FILTERSERVER_SRC_PATH $BUILD_FILE_NAME $BUILD_CLI

        copy_middware $BUILD_CLI

        copy_frontend $BUILD_CLI
    }
    # exe off

    echo "[main() : end("${BASH_SOURCE[0]}")]"
}

# 스크립트를 직접 실행시 또는 bashdb시 main 함수 호출
if [[ "${BASH_SOURCE[0]}" == "${0}" || "${0}" =~ bashdb ]]; then
    main "$@"
fi