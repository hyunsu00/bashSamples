#!/usr/bin/env bash

app="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $app/debugging.sh
source $app/get_linux_os.sh

WORKSPACE_PATH=$(pwd -P)
CONFIG_FILE_PATH="$WORKSPACE_PATH/../hdv/jenkins/docker-distribution/ConfigFiles"

clean_all() {
    rm -f ${WORKSPACE_PATH}/FilterChangeLog.html
    rm -f ${WORKSPACE_PATH}/FilterHEAD
    rm -f ${WORKSPACE_PATH}/FilterVersion.txt
    rm -f ${WORKSPACE_PATH}/version.txt

    rm -rf ${WORKSPACE_PATH}/contentsconverter/middleware/host/product/
    rm -rf ${WORKSPACE_PATH}/contentsconverter/morfhis/node_modules/
    rm -rf ${WORKSPACE_PATH}/contentsconverter/morfhis/build/

    rm -rf ${WORKSPACE_PATH}/release/
    rm -rf ${WORKSPACE_PATH}/lastestBuild/
}

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
    # export REACT_APP_BUILD_LEVEL="${FRONT_BUILD_TARGET}"
    npm install
    npm run build
}

clean_documentviewer() {
    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    rm -rf ${RELEASE_HOME}
    mkdir -p ${RELEASE_HOME}
}

create_filterserver() {
    local FILTERSERVER_SRC_PATH="${1}"
    local BUILD_FILE_NAME="${2}"
    local IS_CLI="${3}"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local FILTERSERVER_DEST_PATH="${RELEASE_HOME}/filterserver"
    local EXTRACE_FOLDER_NAME=$(tar -tf "${FILTERSERVER_SRC_PATH}/${BUILD_FILE_NAME}" | head -n 1 | awk -F'/' '{print $1}' | sed 's/-$//')

    # 빌드된 filterserver "${WORKSPACE_PATH}/release/filterserver/"에 복사
    {
        mkdir -p "${FILTERSERVER_DEST_PATH}"
        cp -rf ${FILTERSERVER_SRC_PATH}/${BUILD_FILE_NAME} ${FILTERSERVER_DEST_PATH}/
        cp -rf ${FILTERSERVER_SRC_PATH}/version.txt ${WORKSPACE_PATH}/FilterVersion.txt
        cp -rf ${FILTERSERVER_SRC_PATH}/ChangeLog.html ${WORKSPACE_PATH}/FilterChangeLog.html
        cp -rf ${FILTERSERVER_SRC_PATH}/HEAD ${WORKSPACE_PATH}/FilterHEAD

        # "${WORKSPACE_PATH}/release/filterserver/${EXTRACE_FOLDER_NAME}"에 압축풀기
        cd ${FILTERSERVER_DEST_PATH}/
        tar -xvf ${BUILD_FILE_NAME}
        rm -f ${BUILD_FILE_NAME}

        # 압축된 파일 "${WORKSPACE_PATH}/release/filterserver/"에 복사
        cd ${EXTRACE_FOLDER_NAME}
        cp -rf ./* ../
        cd ..
        rm -rf ${EXTRACE_FOLDER_NAME}

        if [ ${IS_CLI} == "ON" ]; then
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
    if [[ "${IS_CLI}" == "OFF" ]]; then
        cp -rf ${AGENT_SRC_PATH} ${FILTERSERVER_DEST_PATH}
    fi
}

create_middware() {
    local IS_CLI="${1}"

    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local TEMPLATE_SRC_PATH="${WORKSPACE_PATH}/contentsconverter/documents/__template"
    local MIDDLEWARE_SRC_PATH="${CONTENTS_SRC_HOME}/middleware/host"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local MIDDLEWARE_DEST_PATH="${RELEASE_HOME}/middleware/host"
    local TEMPLATE_DEST_PATH="${RELEASE_HOME}/documents/__template"

    if [ ${IS_CLI} == "OFF" ]; then
        rm -rf ${MIDDLEWARE_DEST_PATH}
        mkdir -p ${MIDDLEWARE_DEST_PATH}
        rm -rf ${TEMPLATE_DEST_PATH}
        mkdir -p ${TEMPLATE_DEST_PATH}

        cp -rf ${MIDDLEWARE_SRC_PATH}/product/* ${MIDDLEWARE_DEST_PATH}
        cp -rf ${MIDDLEWARE_SRC_PATH}/*.json ${MIDDLEWARE_DEST_PATH}
        cp -rf ${TEMPLATE_SRC_PATH}/* ${TEMPLATE_DEST_PATH}
    fi
}

create_frontend() {
    local IS_CLI="${1}"

    local CONTENTS_SRC_HOME="${WORKSPACE_PATH}/contentsconverter"
    local FRONTEND_BUILD_PATH="${CONTENTS_SRC_HOME}/morfhis/build"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local FRONTEND_DEST_PATH="${RELEASE_HOME}/middleware/hdv"
    if [ ${IS_CLI} == "OFF" ]; then
        rm -rf ${FRONTEND_DEST_PATH}
        mkdir -p ${FRONTEND_DEST_PATH}

        cp -rf ${FRONTEND_BUILD_PATH}/* ${FRONTEND_DEST_PATH}
    fi
}

create_shared() {
    local PUBLISH="${1}"
    local IS_CLI="${2}"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local TEMPLATE_SRC_PATH="${WORKSPACE_PATH}/contentsconverter/documents/__template"
    if [[ "${PUBLISH}" == "ON" ]]; then
        if [[ ${IS_CLI} == "OFF" ]]; then
            sudo cp -rf ${CONFIG_FILE_PATH}/documents ${RELEASE_HOME}
            sudo cp -rf ${CONFIG_FILE_PATH}/filterserver ${RELEASE_HOME}
            sudo cp -rf ${CONFIG_FILE_PATH}/middleware ${RELEASE_HOME}
        else
            sudo sudo chmod 777 ${RELEASE_HOME}/filterserver/Bin/convert.sh
        fi
        sudo chown -R jenkins.jenkins ${RELEASE_HOME}/*
        rm -f ${RELEASE_HOME}/filterserver/Bin/LicenseFile.dat

        mkdir -p ${RELEASE_HOME}/conf
        cp -f ${RELEASE_HOME}/filterserver/Bin/*.conf ${RELEASE_HOME}/conf/
    fi
}

get_package_name() {
    local PUBLISH="${1}"
    local IS_CLI="${2}"
    local MAJOR_VERSION="${3}"
    local BUILD_NUMBER="${4}"
    local BUILD_DATE="${5}"

    local TARGET_BUILD_FILE_NAME="documentviewer"
    if [[ ${IS_CLI} == "ON" ]]; then
        TARGET_BUILD_FILE_NAME="${TARGET_BUILD_FILE_NAME}-CLI"
    fi
    
    TARGET_BUILD_FILE_NAME="${TARGET_BUILD_FILE_NAME}-$(get_linux_os_name).v$(get_linux_os_version)"

    if [ ${PUBLISH} == "ON" ]; then
        TARGET_BUILD_FILE_NAME="${TARGET_BUILD_FILE_NAME}-${MAJOR_VERSION}-${BUILD_DATE}.tar"
    else
        TARGET_BUILD_FILE_NAME="${TARGET_BUILD_FILE_NAME}-${BUILD_DATE}-${BUILD_NUMBER}.tar"
    fi

    echo "${TARGET_BUILD_FILE_NAME}"
}

package() {
    local TARGET_BUILD_FILE_NAME="${1}"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"

    cd $RELEASE_HOME
    tar -cvf ${TARGET_BUILD_FILE_NAME} ./*
    rm -f ${WORKSPACE_PATH}/lastestBuild/*
}

depoly() {
    local PUBLISH="${1}"
    local IS_CLI="${2}"
    local MAJOR_VERSION="${3}"
    local BUILD_NUMBER="${4}"
    local BUILD_DATE="${5}"
    local TARGET_BUILD_FILE_NAME="${6}"

    local RELEASE_HOME="${WORKSPACE_PATH}/release"
    local BUILD_FOLDER="${BUILD_DATE}-${BUILD_NUMBER}"
    local PRODUCT_CLOUD_TARGET="/mnt/product-cloud/build/${BUILD_FOLDER}-$(get_linux_os_name).v$(get_linux_os_version)"
	local BUILD_HISTORY_TARGET="/mnt/product-cloud/build_history/${BUILD_FOLDER}-$(get_linux_os_name).v$(get_linux_os_version)"
	local RELEASE_COPY_TARGET="/mnt/product-cloud/product/V${MAJOR_VERSION}_${BUILD_DATE}"

    cd ${RELEASE_HOME}
    if [ ! -d "${WORKSPACE_PATH}/lastestBuild" ]; then
        mkdir ${WORKSPACE_PATH}/lastestBuild/
    fi
    cp ${TARGET_BUILD_FILE_NAME} ${WORKSPACE_PATH}/lastestBuild/

    if [ ${IS_CLI} == OFF ]; then
		if [ ! -d "${WORKSPACE_PATH}/buildList/${BUILD_FOLDER}" ]; then
			mkdir -p ${WORKSPACE_PATH}/buildList/${BUILD_FOLDER}
		fi
        if sudo [ ! -d "${PRODUCT_CLOUD_TARGET}" ]; then
			sudo mkdir ${PRODUCT_CLOUD_TARGET}
		fi
	fi
    if sudo [ ! -d "${BUILD_HISTORY_TARGET}" ]; then
		sudo mkdir ${BUILD_HISTORY_TARGET}
	fi

    sudo chmod 777 ${TARGET_BUILD_FILE_NAME}
    sudo cp ${TARGET_BUILD_FILE_NAME} ${PRODUCT_CLOUD_TARGET}/

    if [ ${PUBLISH} == "ON" ]; then
        if sudo [ ! -d "${RELEASE_COPY_TARGET}" ]; then
			sudo mkdir ${RELEASE_COPY_TARGET}
		fi
		sudo cp ${TARGET_BUILD_FILE_NAME} ${RELEASE_COPY_TARGET}/
		sudo cp ${WORKSPACE_PATH}/FilterChangeLog.html ${RELEASE_COPY_TARGET}/
	fi

    mv ${TARGET_BUILD_FILE_NAME} ${WORKSPACE_PATH}/buildList/${BUILD_FOLDER}
    cp ${WORKSPACE_PATH}/FilterChangeLog.html ${WORKSPACE_PATH}/buildList/${BUILD_FOLDER}
	sudo cp ${WORKSPACE_PATH}/FilterChangeLog.html ${PRODUCT_CLOUD_TARGET}/
	sudo cp ${WORKSPACE_PATH}/FilterChangeLog.html ${BUILD_HISTORY_TARGET}/
}

generate_version() {
    local MAJOR_VERSION="${1}"
    local BUILD_NUMBER="${2}"
    local BUILD_DATE="${3}"
    local BRANCH_NAME="${4}"
    local CONFIG_BRANCH_NAME="${5}"

    local BUILD_FOLDER="${BUILD_DATE}-${BUILD_NUMBER}"
    local PRODUCT_CLOUD_TARGET="/mnt/product-cloud/build/${BUILD_FOLDER}-$(get_linux_os_name).v$(get_linux_os_version)"
	local BUILD_HISTORY_TARGET="/mnt/product-cloud/build_history/${BUILD_FOLDER}-$(get_linux_os_name).v$(get_linux_os_version)"

    cd ${WORKSPACE_PATH}
    rm -rf ./version.txt
    touch ./version.txt

    echo BuildDate : ${BUILD_DATE} >> ./version.txt
    echo BuildVersion: ${MAJOR_VERSION} >> ./version.txt
    echo BuildNumber : ${BUILD_NUMBER} >> ./version.txt
    echo HDVBranch : ${BRANCH_NAME} >> ./version.txt
    cat FilterVersion.txt >> ./version.txt

    cp ./version.txt ${WORKSPACE_PATH}/lastestBuild/
    sudo cp ./version.txt ${PRODUCT_CLOUD_TARGET}/
    sudo cp ./version.txt ${BUILD_HISTORY_TARGET}/
    cp ./version.txt ${WORKSPACE_PATH}/buildList/${BUILD_FOLDER}
}

main() {
    echo "[main() : begin("${BASH_SOURCE[0]}")]"

    PS4='Line $LINENO: '
    set -ex
    {
        clean_all

        MAJOR_VERSION="hotfix.m17.3"
        BUILD_NUMBER="999"
        BUILD_DATE=$(date +%Y%m%d)
        PRODUCT_VERSION="${MAJOR_VERSION}.${BUILD_NUMBER}(${BUILD_DATE})"
        PUBLISH="ON"
        build_middware $PRODUCT_VERSION $PUBLISH

        FRONT_BUILD_TARGET="release"
        build_frontend $FRONT_BUILD_TARGET

        clean_documentviewer

        CORE_BUILD_NUMBER="5"
        CORE_BUILD_DATE="20231208"
        LAST_BUILD_FOLDER="${CORE_BUILD_DATE}-${CORE_BUILD_NUMBER}"
        FILTER_BUILD_JOB="docsconverter-2021-v2-hdv-rhel92-build"
        FILTERSERVER_SRC_PATH="${WORKSPACE_PATH}/../${FILTER_BUILD_JOB}/build/${LAST_BUILD_FOLDER}"
        BUILD_FILE_NAME="hncfilterserver-11.90.0.5-Linux.tar.bz2"
        IS_CLI="OFF"

        create_filterserver $FILTERSERVER_SRC_PATH $BUILD_FILE_NAME $IS_CLI

        create_middware $IS_CLI

        create_frontend $IS_CLI

        create_shared $PUBLISH $IS_CLI

        # 패키징
        TARGET_BUILD_FILE_NAME=$(get_package_name $PUBLISH $IS_CLI $MAJOR_VERSION $BUILD_NUMBER $BUILD_DATE)
        package $TARGET_BUILD_FILE_NAME

        # 배포
        depoly $PUBLISH $IS_CLI $MAJOR_VERSION $BUILD_NUMBER $BUILD_DATE $TARGET_BUILD_FILE_NAME

        BRANCH_NAME="hotfix.m17.3"
        generate_version $MAJOR_VERSION $BUILD_NUMBER $BUILD_DATE $BRANCH_NAME
    }
    set +ex

    echo "[main() : end("${BASH_SOURCE[0]}")]"
}

# 스크립트를 직접 실행시 또는 bashdb시 main 함수 호출
if [[ "${BASH_SOURCE[0]}" == "${0}" || "${0}" =~ bashdb ]]; then
    main "$@"
fi
