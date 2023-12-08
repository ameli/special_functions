set -xe

# curl -L https://github.com/fxcoudert/gfortran-for-macOS/releases/download/12.1-monterey/gfortran-ARM-12.1-Monterey.dmg -o gfortran.dmg
# curl -L https://github.com/fxcoudert/gfortran-for-macOS/releases/download/11-arm-alpha2/gfortran-ARM-11.0-BigSur.pkg -o gfortran.pkg
curl -L https://github.com/fxcoudert/gfortran-for-macOS/releases/download/12.1-monterey/gfortran-Intel-12.1-Monterey.dmg -o gfortran.dmg

# GFORTRAN_SHA256=$(shasum -a 256 gfortran.dmg)
# KNOWN_SHA256="e2e32f491303a00092921baebac7ffb7ae98de4ca82ebbe9e6a866dd8501acdf  gfortran.dmg"
#
# if [ "$GFORTRAN_SHA256" != "$KNOWN_SHA256" ]; then
#   echo sha256 mismatch
#   exit 1
# fi

hdiutil attach -mountpoint /Volumes/gfortran gfortran.dmg

ls /Volumes/gfortran

# sudo installer -pkg /Volumes/gfortran/gfortran.pkg -target /
sudo installer -pkg /Volumes/gfortran/*/gfortran.pkg -target /
# sudo installer -pkg gfortran.pkg -target /
type -p gfortran
which gfortran
gfortran --version
echo $MACOSX_DEPLOYMENT_TARGET
sw_vers
uname -av
uname -m
