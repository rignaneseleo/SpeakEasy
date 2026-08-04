#!/bin/bash
# Codemagic Post-clone / pre-build — decrypt word CSVs.
# Prefer: bash scripts/decrypt_words.sh
# Tries -pbkdf2 first (current Codemagic UI), then legacy OpenSSL KDF.
set -euo pipefail
PASS="${WORD_CSV_PASS:-031112}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
for folder in "$ROOT"/opentabu/assets/words/*/; do
  enc="${folder}words.csv.enc"
  out="${folder}words.csv"
  [[ -f "$enc" ]] || continue
  if openssl enc -aes-256-cbc -d -salt -pbkdf2 -pass pass:"$PASS" -in "$enc" -out "$out" 2>/dev/null; then
    echo "decrypted (pbkdf2) $enc"
  elif openssl enc -aes-256-cbc -d -salt -pass pass:"$PASS" -in "$enc" -out "$out" 2>/dev/null; then
    echo "decrypted (legacy) $enc"
  else
    echo "FAILED decrypt $enc" >&2
    exit 1
  fi
done
