# Quickstart (new Docker image method)

Run AmericanCoin daemon from docker image on modern Debian system:

First, as root, make sure you have the necessary packages installed:
`apt install make git docker.io`, and grant docker access to the unprivileged
user who will be running the daemon: `usermod -a -G docker jrandomhacker`

Then, as the user: `make docker` should start the daemon up. Leave it open
in that window, and open another terminal window to run client commands, e.g.:
`./americancoind getbalance`.

# Quickstart (obsolete: Debian 10 no longer avaialable on Digital Ocean)

As root on a new Digital Ocean droplet running Debian 10 (Buster):

```bash
NEWUSER=newuser  # set this to whatever you want
adduser $NEWUSER
su - $NEWUSER -c "mkdir src"
apt update
apt install git make
su - $NEWUSER -c "cd src && git clone https://github.com/jcomeauictx/AmericanCoin.git"
cd /home/$NEWUSER/src/AmericanCoin/src
make -f buster.mk prepare
su $NEWUSER -c "make -f buster.mk test"
```

It will compile and run until you hit ^C. At least let it run until it starts
fetching blocks. From then on, you can just run the `americancoind` daemon
from the command line. The first time, it will prompt you to create your
americancoin.conf file.

As of 2020-01-24, you can use the $10/month, 2GB RAM standard droplet. The
cheapest droplet doesn't have enough RAM to compile AmericanCoin; it might be
fine for running the daemon, though, once you have it compiled.

If you want to run it on a newer operating system, you can `sudo debootstrap
buster /opt/buster64`, chroot to that directory, and build AmericanCoin; then
make a file $HOME/.local/bin/americancoind containing:

```bash
exec /opt/buster64/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 \
 --library-path /opt/buster64/lib/x86_64-linux-gnu/ \
 /opt/buster64/usr/src/jcomeauictx/americancoin/src/americancoind "$@"
```

The `simpleminer.py` script can be run using a remote americancoind server
to which you have login access. First
`scp myserver:.americancoin/americancoin.conf /tmp` , and copy the
`rpcuser`, `rpcpassword`, `rpcconnect`, and `rpcport` values into your
own configuration file. Then tunnel to the remote server with
`ssh -L 9057:localhost:9057 myserver`, and in another window, run
`simpleminer.py`.

Original README follows

---------

Americancoin, Hell Yea
=========

The most patriotic crypto-currency ever.

Technical nonsense 
=========

a lite version of Bitcoin optimized for CPU mining using scrypt as a proof of work scheme.

<ul>
<li>2.5 minute block targets</li>
<li>subsidy halves in 840k blocks (~4 years)</li>
<li>~168 million total coins</li>
<li>100 coins per block</li>
<li>504 blocks to retarget difficulty</li>
<li>41.4% maximum change on difficulty retarget</li>
</ul>

The rest is the same as bitcoin.

Development process
=========

Developers work in their own trees, then submit pull requests when they think their feature or bug fix is ready.

The patch will be accepted if there is broad consensus that it is a good thing. Developers should expect to rework and resubmit patches if they don't match the project's coding conventions (see coding.txt) or are controversial.

The master branch is regularly built and tested, but is not guaranteed to be completely stable. Tags are regularly created to indicate new official, stable release versions of Litecoin.

Feature branches are created when there are major new features being worked on by several people.

From time to time a pull request will become outdated. If this occurs, and the pull is no longer automatically mergeable; a comment on the pull will be used to issue a warning of closure. The pull will be closed 15 days after the warning if action is not taken by the author. Pull requests closed in this manner will have their corresponding issue labeled 'stagnant'.

Issues with no ommits will be given a similar warning, and closed after 15 days from their last activity. Issues closed in this manner will be labeled 'stale'.

Parting Words
=========

Have fun ya'll.
