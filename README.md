# LeMiele

Private materials are stored encrypted in `vault/` (AES-256-CBC, PBKDF2).
No plaintext content is kept in this repository.

To decrypt (passphrase held offline):

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in vault/lemiele-vault.tar.gz.enc | tar xzf -
```
