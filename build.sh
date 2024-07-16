#!/bin/sh

JDKBINDIR="/usr/lib/jvm/java-8-openjdk/bin"
GAMEDIR="${HOME}/opt/GOG Games/Songs of Syx/game"
USERMODDIR="${HOME}/.local/share/songsofsyx/mods"

TARGET="$(realpath ./target)"

GAMEJAR="${GAMEDIR}/SongsOfSyx.jar"
MODNAME=$(sed -n -e '/^NAME:/ s/.*: "\(.*\)",/\1/p' _Info.txt)
VERSION=V$(sed -n -e '/^GAME_VERSION_MAJOR:/ s/.*: \(.*\),/\1/p' _Info.txt)
CLASSES="${TARGET}/classes"
MODDIR="${TARGET}/${MODNAME}"

echo ":: Building mod \"${MODNAME}\" for Songs Of Syx ${VERSION}"

rm -rf "${TARGET}"
mkdir -p "${MODDIR}"
cp _Info.txt "${MODDIR}"

mkdir -p "${CLASSES}"
"${JDKBINDIR}/javac" -classpath "${GAMEJAR}" -d "${CLASSES}" $(find src -name "*.java")

mkdir -p "${MODDIR}/${VERSION}/script"
"${JDKBINDIR}/jar" -cf "${MODDIR}/${VERSION}/script/${MODNAME}.jar" -C "${CLASSES}" .

echo ":: Creating symlink '${USERMODDIR}/${MODNAME}' -> '${MODDIR}'"

ln -snf "$(realpath "${MODDIR}")" "${USERMODDIR}/${MODNAME}"

echo ":: Packaging mod in '${TARGET}/${MODNAME}.zip'"

cd "${TARGET}"
# 7z a -tzip -bb0 -bd "${MODNAME}.zip" "$MODNAME" >/dev/null
zip -qr9 "${MODNAME}.zip" "${MODNAME}"
