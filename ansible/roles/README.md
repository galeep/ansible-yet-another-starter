# roles

`ansible-galaxy` was not yet available when this was hacked together, but-- to Ansible's credit and consistency over time-- it plays well with this structure. `internal` can house smaller roles that are very specific to this context, or can be set up with git submodules.

## internal

Minimal housing for basic roles that are internal to this repo (or git submodules, if you prefer).

## external

A cache for third-party roles from other repositories. To use with Galaxy, make sure this is in your `ANSIBLE_ROLES_PATH` when running `ansible-galaxy`.

## roles-requirements.yml

A manifest and questionable mechanism for caching external roles.

___12/2021__: This DIY Galaxy stand-in predates at least the open source release of `ansible-galaxy`, but can be used as its `requirements.yml`.
I can't recall if I found a `requirements.yml` back then, or at some point later updated this to work with `ansible-galaxy` so I didn't have to check in the __terrible__ script that grabbed external requirements._
