FROM interlegis/plone:4.3.6

MAINTAINER "Fabio Rauber" <fabiorauber@gmail.com>

USER root

COPY site.cfg /plone/instance/
COPY portalmodelo-versions.cfg /plone/instance/
COPY warmup.ini /plone/instance/

ADD cfg_portal.py /plone/instance/
ADD configure.cfg /plone/instance/
ADD upgrades.cfg /plone/instance/
COPY configure.sh /

RUN apt-get update && \
    buildDeps="python-setuptools python-dev build-essential libssl-dev libjpeg62-turbo-dev libldap2-dev libsasl2-dev libbz2-dev libreadline6-dev libxml2-dev libxslt1-dev default-libmysqlclient-dev wget sudo" && \ 
    apt-get install -y --no-install-recommends $buildDeps && \
    apt-get install -y --no-install-recommends \
      readline-common \
      python-imaging \
      python-docutils \
      python-psycopg2 \
      python-magic \
      libsnappy-dev \
      python-snappy \
      xpdf \
      xsltproc \
      pdftohtml \
      poppler-utils \
      wv \
      unzip \
      lynx \
      links \
      elinks && \
    wget http://archive.debian.org/debian/pool/main/x/xlhtml/xlhtml_0.5.1-6_amd64.deb -P /tmp && \
    wget http://archive.debian.org/debian/pool/main/x/xlhtml/ppthtml_0.5.1-6_amd64.deb -P /tmp && \
    dpkg -i /tmp/xlhtml_0.5.1-6_amd64.deb && \   
    dpkg -i /tmp/ppthtml_0.5.1-6_amd64.deb && \   
    sudo -u plone bin/buildout -c site.cfg && \
    SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove $buildDeps && \
    rm -rf /plone/buildout-cache/downloads/* && \
    find /plone \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' + && \
    rm -rf /var/lib/apt/lists/* && rm -f /tmp/* && \
    chown -R plone:plone /plone /data 

USER plone

COPY sitecustomize.py /plone/Python-2.7/lib/python2.7/
