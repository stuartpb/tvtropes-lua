These scripts require LuaSocket and its HTTP module.

While these scripts worked back when all it took to edit TVTropes was the password "foamy", they have been rendered inoperable by the changes that made registration mandatory to edit. To fix it, the post request will need to be changed to support these cookies:

- `author` and `troperhandle` (both "`STUART`" in my case, possibly different for users with punctuation)
- `mazeltov` (knower passphrase)
- `tos` ("`yes`")
