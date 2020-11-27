Files are organized to describe distinct environments to reduce the 
proverbial blast radius. Static inventory is an anti-pattern in general, 
but it's also an interesting check/balance on whether you should be 
using Ansible at all. 

If you need to have a group that contains hosts from both static and 
dynamic inventory sources, you need to do a little bit of gnarly magic 
with nested groups.

### host_vars
host override variables

### group_vars
group override variables

## Vaulting 
Sensitive data should not reside in Ansible, but sometimes it must. 
If it does, that var file should be obfuscated with ansible-vault. 
~~This comes at the cost of easily visible deltas and (as of when I 
was using ansible regularly) was an all-or-nothing proposition. 
Perhaps there's a better pattern now.~~ There is a better pattern 
now, and you can read about it [here](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#tip-for-variables-and-vaults). 

