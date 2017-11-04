installization steps:
	1. open terminal and decompress the package
	2. enter the key directory and compile
	compile steps:
		$ make
		$ make install
	note:
		move or copy 'key.elf' to /usr/bin/ should be a super user 'root'

examples:
	[user1@group1~/]$ su - root
	password:
	[root@group1~/]#
	[root@group1~/]# tar -xzf key.tar.gz
	[root@group1~/]# cd key/
	[root@group1~/]# make
	[root@group1~/]# make install
	[root@group1~/]# 

    Then run the 'key' command for help:
    [root@group1~/]# key
    usage: key <in_file> <out_file>
