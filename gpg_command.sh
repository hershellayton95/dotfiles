#!/usr/bin/env bash

# gpg --import ~/private-key.{gpg,asc,cer}
# gpg --list-keys

# ID Lungo della chiave
# gpg --list-keys --keyid-format LONG ID_CHIAVE or EMAIL

#vedere cert pub key
# gpg --export --armor ID_CHIAVE or EMAIL

#geneare cert di revoca
# gpg --output mio_certificato_revoca.asc --gen-revoke ID_CHIAVE or EMAIL
#import cert di revoca
# gpg --import mio_certificato_revoca.asc

# prendere gpg pub from keyserver ubuntu or hkps://keys.openpgp.org
# gpg --keyserver hkps://keyserver.ubuntu.com \
#     --keyserver-options "timeout=40 http-proxy=http://proxy.example.com:8080" \
#     --recv-keys ID_CHIAVE

# prendere gpg cercandola from keyserver hkps://keys.openpgp.org
# gpg --keyserver hkps://keys.openpgp.org --search-keys ID_CHIAVE or EMAIL

# Run: gpg --edit-key [KeyID or Email]
# Type trust at the prompt.
# Select 5 (I trust ultimately) if it is your own key.
# Type save.