NEWUSER=newuser  # set this to whatever you want
adduser $NEWUSER
su - $NEWUSER -c "mkdir src"
apt update
apt install git make
su - $NEWUSER -c "cd src && git clone https://github.com/jcomeauictx/AmericanCoin.git"
cd /home/$NEWUSER/src/AmericanCoin/src
make -f buster.mk prepare
su $NEWUSER -c "make -f buster.mk test"
