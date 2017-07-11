# infra-simmer-
Wrap up of infrasim plus rackhd all in docker images

Currently "two or three users" grade...

Requires:
* Docker version 17.06.0-ce or higher
* Docker-compose version 1.14.0 or higher

Two pieces: building and using. To build:
* ./HWIMO-BUILD will call HWIMO-BUILD in 'infrasim' and 'rackhd' directories.
  * rackhd dir will build infras-immer/rackhd_blob (this takes a bit and npm installs can stall). This image has all the gooey bits of rackhd itself.
  * infrasim dir will build infra-simmer/infrasim image. This contains the raw infrasim plus glue to help actually deploy vs rackhd.


Once those are built, it is possible to use. From the top directory:

```docker-compose -f docker-compose.yml <additional node files> up```

The node files live in the "inodes" directory. Two bring up a sim with two r730s and two 630s:

```docker-compose -f docker-compose.yml -f inodes/r730_1 -f inodes/r730_2 -f inodes/r630_1 -f inode/r630_2 up```

Note that the node files must not be repeated in the node file yes. If you need more nodes, copy one of the first four and alter the service name ('r730-x') and last octet of IP address.

Advanced use: You may add nodes _after_ the set of nodes is already up. You need to start in detached mode using the -d option. Here is the above example with that added:

```docker-compose -f docker-compose.yml -f inodes/r730_1 -f inodes/r730_2 -f inodes/r630_1 -f inode/r630_2 up -d```

Now to add another r730:

```docker-compose -f docker-compose.yml -f inodes/r730_1 -f inodes/r730_2 -f inodes/r630_1 -f inode/r630_2 -f inode/r730_3 up -d```

docker-compose will detect that nothing has changed with the existing entries and leave them alone. It will also notice that 'inode/r730_3' is new and start it.

*NOTE*: please go back to the 'up' command you used and do a matching 'down' when you are done.
