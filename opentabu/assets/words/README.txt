USING STANDARD MAC ENCRYPTION
 https://superuser.com/questions/370388/simple-built-in-way-to-encrypt-and-decrypt-a-file-on-a-mac-via-command-line

ENCRYPT:
openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:xx -in /Users/leonardorignanese/Progetti/OpenTabu/opentabu/assets/words/en/words.csv -out /Users/leonardorignanese/Progetti/OpenTabu/opentabu/assets/words/en/words.csv.enc

DECRYPT:
openssl enc -aes-256-cbc -d -salt -pass pass:<pw> -in /Users/leonardorignanese/Progetti/OpenTabu/opentabu/assets/words/en/words.csv.enc -out /Users/leonardorignanese/Progetti/OpenTabu/opentabu/assets/words/en/words.csv

