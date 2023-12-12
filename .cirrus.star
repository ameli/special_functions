load("cirrus", "env", "fs", "http")

def main(ctx):

    return fs.read("tools/ci/cirrus_deploy_pypi.yml")
    return fs.read("tools/ci/cirrus_deploy_conda_linux_aarchi64.yml")
    return fs.read("tools/ci/cirrus_deploy_conda_macosx_arm64.yml")
