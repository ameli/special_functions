
# Install twine
python -m pip install twine -y

export PYPI_USERNAME="__token__"
# export PYPI_PASSWORD="$NUMPY_STAGING_UPLOAD_TOKEN"


upload_wheels() {
    if [[ -z ${PASSWORD} ]]; then
        echo no token set, not uploading
    else
        # sdists are located under dist folder when built through setup.py
        if compgen -G "./dist/*.gz"; then
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
