FROM registry.access.redhat.com/ubi8/python-311:1-48

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONFAULTHANDLER=1
ENV TZ=Asia/Singapore

USER root

ARG LO_VERSION=24.2.1

# install libreoffice yum dependencies
RUN dnf update -y && dnf upgrade -y && \
    dnf install -y libXinerama nss.x86_64 cairo cups-libs && \
    dnf clean all && rm -rf /tmp/* /var/tmp/* /var/cache/dnf && \
    dnf -y autoremove && \
    rm -rf /var/cache/dnf/

# install libreoffice
RUN cd /tmp && \
    wget https://download.documentfoundation.org/libreoffice/stable/${LO_VERSION}/rpm/x86_64/LibreOffice_${LO_VERSION}_Linux_x86-64_rpm.tar.gz && \
    tar zxvf LibreOffice_${LO_VERSION}_Linux_x86-64_rpm.tar.gz && \
    rm LibreOffice_${LO_VERSION}_Linux_x86-64_rpm.tar.gz && \
    cd /tmp/LibreOffice_24.2.1.2_Linux_x86-64_rpm/RPMS/ && \
    dnf install -y *.rpm

# install fastapi and dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY main.py .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]
