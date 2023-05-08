Extra.csv file is encrypted using encrypt-file (https://github.com/brunocampos01/encrypt-file)

To install the module, run the following command:
    pip install encrypt-file
    pip install pyopenssl
    pip install cryptography

To decrypt the file, you need to use:
    encrypt-file --func decrypt --file extra.csv.enc --password <password>
    encrypt-file --func decrypt --file extra.csv.enc --password <password>

To encrypt use:
    encrypt-file --func encrypt --file extra.csv --password <password>
    encrypt-file --func encrypt --file /Users/leonardorignanese/Progetti/OpenTabu/opentabu/assets/words/en/words.csv --password 031112

