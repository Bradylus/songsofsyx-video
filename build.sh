#!/bin/sh

set -u

# customize these to match yout system
JDK_HOME="/usr/lib/jvm/java-8-openjdk"
GAME_DIR="${HOME}/opt/GOG Games/Songs of Syx/game"
# for steam users:
# GAME_DIR="${HOME}/.steam/steam/steamapps/common/Songs of Syx"

USER_MOD_DIR="${HOME}/.local/share/songsofsyx/mods"

# no further customizations should be needed
GAME_JAR="${GAME_DIR}/SongsOfSyx.jar"
MOD_NAME=$(sed -n -e '/^NAME:/ s/.*: "\(.*\)",/\1/p' _Info.txt)
GAME_VERSION=V$(sed -n -e '/^GAME_VERSION_MAJOR:/ s/.*: \(.*\),/\1/p' _Info.txt)
MOD_VERSION="$(sed -n '/^VERSION/ s/.*: "\(.*\)".*/\1/p' _Info.txt)"

# build directories
TARGET="$(realpath ./target)"
CLASSES="${TARGET}/classes"
MOD_DIR="${TARGET}/${MOD_NAME}"

build() {
  if [ ! -e "${GAME_JAR}" ]; then
    echo >&2 "Game jar file not found: ${GAME_JAR}"
    exit 1
  fi
  if [ ! -e "${JDK_HOME}/bin/javac" ]; then
    echo >&2 "Could not find java compiler, file not found: ${JDK_HOME}/bin/javac"
    exit 1
  fi
  
  echo ":: Building mod \"${MOD_NAME}\" v${MOD_VERSION} for Songs Of Syx ${GAME_VERSION}"

  rm -rf "${TARGET}"
  mkdir -p "${MOD_DIR}"
  cp _Info.txt "${MOD_DIR}"

  mkdir -p "${CLASSES}"
  "${JDK_HOME}/bin/javac" -classpath "${GAME_JAR}" -d "${CLASSES}" $(find src -name "*.java")

  mkdir -p "${MOD_DIR}/${GAME_VERSION}/script"
  "${JDK_HOME}/bin/jar" -cf "${MOD_DIR}/${GAME_VERSION}/script/${MOD_NAME}.jar" -C "${CLASSES}" .

  echo ":: Creating symlink '${USER_MOD_DIR}/${MOD_NAME}' -> '${MOD_DIR}'"

  ln -snf "$(realpath "${MOD_DIR}")" "${USER_MOD_DIR}/${MOD_NAME}"
}

case "${1:-}" in
  "release")
    build
    echo ":: Packaging mod in '${TARGET}/${MOD_NAME}-${MOD_VERSION}.zip'"
    cd "${TARGET}"
    # 7z a -tzip -bb0 -bd "${MOD_NAME}.zip" "$MOD_NAME" >/dev/null
    zip -qr9 "${MOD_NAME}-${MOD_VERSION}.zip" "${MOD_NAME}"
    ;;
  "run")
    build
    cd "${GAME_DIR}"
    exec ./songsofsyx
    ;;
  "clean")
    rm -rf "${TARGET}"
    ;;
  "")
    build
    ;;
  *)
    cat <<EOF
Usage: ./build.sh [command]

Where command is one of:

  release    build a zip release package.
  run        build mod and run Songs Of Syx.
  clean      remove the temporary build directories.
EOF
esac
