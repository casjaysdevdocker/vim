#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202202021753-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : entrypoint-vim.sh --help
# @Copyright     : Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @Created       : Wednesday, Feb 02, 2022 17:53 EST
# @File          : entrypoint-vim.sh
# @Description   :
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202202021753-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi
trap 'exitCode=${exitCode:-$?};[ -n "$ENTRYPOINT_SH_TEMP_FILE" ] && [ -f "$ENTRYPOINT_SH_TEMP_FILE" ] && rm -Rf "$ENTRYPOINT_SH_TEMP_FILE" &>/dev/null' EXIT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__exec_bash() { [ -n "$1" ] && exec /bin/bash -l -c "${@:-bash}" || exec /bin/bash -l; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SHELL="${SHELL:-/bin/bash}"
VIMRC="${VIMRC:-$HOME/.vimrc}"
VIM_INDENT="${VIM_INDENT:-2}"
TERM="${TERM:-xterm-256color}"
HOSTNAME="${HOSTNAME:-casjaysdev-vim}"
TZ="${TZ:-America/New_York}"
CONFIG_DIR="$(ls -A /config/ 2>/dev/null | grep '^' || false)"
export TZ HOSTNAME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -n "${TZ}" ] && echo "${TZ}" >/etc/timezone
[ -n "${HOSTNAME}" ] && echo "${HOSTNAME}" >/etc/hostname
[ -n "${HOSTNAME}" ] && echo "127.0.0.1 $HOSTNAME localhost" >/etc/hosts
[ -f "/usr/share/zoneinfo/${TZ}" ] && ln -sf "/usr/share/zoneinfo/${TZ}" "/etc/localtime"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$CONFIG_DIR" ]; then
  for config in $CONFIG_DIR; do
    if [ -d "/config/$config" ]; then
      cp -Rf "/config/$config/." "/root/$config/"
    elif [ -f "/config/$config" ]; then
      cp -Rf "/config/$config" "/root/$config"
    fi
  done
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[[ -f "/config/vimrc" ]] || { [[ -f "/root/.vimrc" ]] && cp -Rf "/root/.vimrc" "/config/vimrc"; }
[[ -f "/config/tmux.conf" ]] || { [[ -f "/root/.tmux.conf" ]] && cp -Rf "/root/.tmux.conf" "/config/tmux.conf"; }
[[ -d "/config/resurrect" ]] || { [[ -d "/root/.cache/resurrect" ]] && mkdir -p "/config/resurrect" && cp -Rf "/root/.cache/resurrect/." "/config/resurrect/"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [[ -f "$VIMRC" ]]; then
  sed -i 's|set ts=4|set ts='$VIM_INDENT'|g' "$VIMRC"
  sed -i 's|set shiftwidth=4|set shiftwidth='$VIM_INDENT'|g' "$VIMRC"
else
  echo "Could not find .vimrc at $VIMRC"
  exit 1
fi

case "$1" in
healthcheck)
  if [[ -f "$VIMRC" ]] && builtin type -P vim &>/dev/null; then
    exit 0
  else
    exit 1
  fi
  ;;
bash | shell | sh)
  shift 1
  __exec_bash "$@"
  ;;
tmux)
  shift 1
  exec tmux "$@"
  ;;
*)
  __exec_bash "$@"
  ;;
esac
