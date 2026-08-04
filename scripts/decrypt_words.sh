#!/bin/bash
# Codemagic pre-build: decrypt opentabu/assets/words/*/words.csv.enc
# Tries legacy OpenSSL KDF first (current Codemagic script), then -pbkdf2.
set -euo pipefail
PASS="${WORD_CSV_PASS:-031112}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
for folder in "$ROOT"/opentabu/assets/words/*/; do
  enc="${folder}words.csv.enc"
  out="${folder}words.csv"
  [[ -f "$enc" ]] || continue
  if openssl enc -aes-256-cbc -d -salt -pass pass:"$PASS" -in "$enc" -out "$out" 2>/dev/null; then
    echo "decrypted (legacy) $enc"
  elif openssl enc -aes-256-cbc -d -salt -pbkdf2 -pass pass:"$PASS" -in "$enc" -out "$out" 2>/dev/null; then
    echo "decrypted (pbkdf2) $enc"
  else
    echo "FAILED decrypt $enc" >&2
    exit 1
  fi
done
