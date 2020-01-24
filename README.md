# Quickstart

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
su $NEWUSER -c "make -f buster.mk"
su $NEWUSER -c "./americancoind &"
```


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
