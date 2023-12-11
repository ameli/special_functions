set -xe


# ================
# install anaconda
# ================

install_anaconda() {

    # Parameters:
    # $1 is OS, and it can be "linux_aarch64" or "macosx_arm64
    #
    # Usage:
    # install_anaconda "linux_aarch64"
    # install_anaconda "macosx_arm64"

    MINICONDA_URL="https://repo.anaconda.com/miniconda/"
    if [ "$1"=="linux_aarch64" ];
    then
        URL=${MINICONDA_URL}"Miniconda3-latest-Linux-aarch64.sh"
    elif [ "$1"=="macosx_arm64" ];
    then
        URL=${MINICONDA_URL}"Miniconda3-latest-MacOSX-arm64.sh"
    else
        echo "OS or platform is invalid."
        return 1;
    fi

    # install miniconda in the parent directory of the current directory,
    # because the source code of the package is in the current directory, and
    # if we also install miniconda3 in the same directory of the package source
    # cod, when we use conda-build, it gives error as it also tries to build
    # miniconda as well as the code.
    CURRENT_DIR=$PWD
    PARENT_DIR=$(dirname $CURRENT_DIR)

    # install miniconda for uploading to anaconda
    wget -q ${URL} -O ${PARENT_DIR}miniconda.sh
    bash ${PARENT_DIR}/miniconda.sh -b -p ${PARENT_DIR}/miniconda3
    ${PARENT_DIR}/miniconda3/bin/conda init bash
    source ${PARENT_DIR}/miniconda3/bin/activate
}


# =====================
# build upload anaconda
# =====================

build_upload_anaconda() {

    # Parameters:
    # $1 is OS, and it can be "linux_aarch64" or "macosx_arm64
    #
    # Usage:
    # build_upload_anaconda "linux_aarch64"
    # build_upload_anaconda "macosx_arm64"

    # Conda executable
    export PATH=$(conda info --root):$PATH
    export PATH=$(conda info --root)/bin:$PATH

    conda install -y anaconda-client conda-build

    # Anaconda account
    ANACONDA_USERNAME="s-ameli"

    # Upload sdist
    if compgen -G "./dist/*.gz"; then
        anaconda -t ${ANACONDA_API_TOKEN} upload --force \
            -u ${ANACONDA_USERNAME} ./dist/*.gz
    else
        echo "Dist files do not exist"
    fi

    # Determine the sub-directory where the conda builds the package depending
    # on the operating system and platform
    if [ "$1"=="linux_aarch64" ];
    then
        BUILD_SUBDIR="linux-aarch64"
    elif [ "$1"=="macosx_arm64" ];
    then
        BUILD_SUBDIR="osx-arm64"
    else
        echo "OS or platform is invalid."
        return 1;
    fi

    # Build wheels and upload them automatically
    if compgen -G "./dist/*.whl"; then
        conda-build --output-folder conda-bld .
        anaconda -t ${ANACONDA_API_TOKEN} upload --force \
            -u ${ANACONDA_USERNAME} conda-bld/${BUILD_SUBDIR}/*.tar.bz2
    else
        echo "Wheel files do not exist"
        return 1
    fi
}


# ==================
# upload wheels pypi
# ==================

upload_wheels_pypi() {

    # Install pip and twine
    python -m pip install --upgrade pip
    python -m pip install twine

    PYPI_USERNAME="__token__"

    if [[ -z ${PYPI_PASSWORD} ]]; then
        echo no pypi password set, not uploading
    else
        if compgen -G "./dist/*.whl"; then
            echo "Found wheel"
            twine upload ./dist/* -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD}
        else
            echo "Wheel files do not exist"
            return 1
        fi
    fi
}
