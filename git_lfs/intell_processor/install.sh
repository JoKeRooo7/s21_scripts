#!/usr/bin/env bash
set -eu

INSTALL_DIR="$HOME/goinfre/utilites"

if [ ! -d "$INSTALL_DIR" ]; then
  mkdir -p "$INSTALL_DIR"
fi

INSTALL_DIR="$INSTALL_DIR/git-lfs"

if [ "${INSTALL_DIR:-}" != "" ] ; then
  INSTALL_DIR=${INSTALL_DIR:-}
elif [ "${BOXEN_HOME:-}" != "" ] ; then
  INSTALL_DIR=${BOXEN_HOME:-}
fi

mkdir -p $INSTALL_DIR/bin
rm -rf $INSTALL_DIR/bin/git-lfs*

pushd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null
  for g in git*; do
    install $g "$INSTALL_DIR/bin/$g"
  done
popd > /dev/null

PATH+=:$INSTALL_DIR/bin
git lfs install

INSTALL_DIR="$INSTALL_DIR/bin/git-lfs"


# Добавляем алиас с пробелом, если его нет
if ! grep -q "#alias git lfs = '$INSTALL_DIR' " ~/.zshrc; then
    echo -e "\n #alias git lfs ='$INSTALL_DIR'" >> ~/.zshrc
fi

