yum install -y make rpm-build python2-devel python-setuptools
cd /tmp
git clone https://github.com/postgrespro/mamonsu.git
cd mamonsu && make rpm
