set -xe

install_anaconda() {

    # install miniconda in the home directory. For some reason HOME isn't set by Cirrus
    export HOME=$PWD

    # install miniconda for uploading to anaconda
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda3
    $HOME/miniconda3/bin/conda init bash
    source $HOME/miniconda3/bin/activate
    conda install -y anaconda-client

    # Install pip and twine
    python -m pip install --upgrade pip
    python -m pip install twine
}

build_upload_wheels_anaconda() {

    anaconda login --username s-ameli --token ${ANACONDA_TOKEN}
    conda config --set anaconda_upload yes
    export PATH=$(conda info --root):$PATH
    export PATH=$(conda info --root)/bin:$PATH
    conda-build --output-folder . .
}

upload_wheels_pypi() {

    PYPI_USERNAME="__token__"

    if [[ -z ${PYPI_PASSWORD} ]]; then
        echo no token set, not uploading
    else
        # sdists are located under dist folder when built through setup.py
        # if compgen -G "./dist/*.gz"; then
        if compgen -G "./wheelhouse/*.whl"; then
        #     echo "Found sdist"
        #     # anaconda -q -t ${TOKEN} upload --force -u ${ANACONDA_ORG} ./dist/*.gz
        #     twine upload ./dist/* -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD}
        #
        # elif compgen -G "./wheelhouse/*.whl"; then
            echo "Found wheel"
            # anaconda -q -t ${TOKEN} upload --force -u ${ANACONDA_ORG} ./wheelhouse/*.whl
            twine upload ./wheelhouse/* -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD}
        else
            echo "Files do not exist"
            return 1
        fi
        echo "PyPI-style index: https://pypi.org"
    fi
}
