#!/usr/bin/env bash
if [ -x "$(command -v exa)" ]; then
  exa -lFaghH --color=always --git "$@"
else
  ls -laFh --color=always "$@"
fi
