# Based on MIT code from shelfio
# https://github.com/shelfio/libreoffice-lambda-base-image/blob/master/Dockerfile.node18-x86_64

FROM public.ecr.aws/lambda/nodejs:18-x86_64

RUN yum install \
    tar \
    gzip \
    libdbusmenu.x86_64 \
    libdbusmenu-gtk2.x86_64 \
    libSM.x86_64 \
    xorg-x11-fonts-* \
    google-noto-sans-cjk-fonts.noarch \
    binutils.x86_64 \
    -y && \
    yum clean all

RUN set -xo pipefail && \
    curl "https://downloadarchive.documentfoundation.org/libreoffice/old/7.6.5.2/rpm/x86_64/LibreOffice_7.6.5.2_Linux_x86-64_rpm.tar.gz" | tar -xz

RUN cd LibreOffice_7.6.5.2_Linux_x86-64_rpm/RPMS && \
    yum install *.rpm -y && \
    rm -rf /var/task/LibreOffice_7.6.5.2* && \
    cd /opt/libreoffice7.6/ && \
    strip ./**/* || true

ENV HOME=/tmp

# Trigger dummy run to generate bootstrap files to improve cold start performance
RUN touch /tmp/test.txt \
    && cd /tmp \
    && libreoffice7.6 --headless --invisible --nodefault --view \
        --nolockcheck --nologo --norestore --convert-to pdf \
        --outdir /tmp /tmp/test.txt \
    && rm /tmp/test.*

COPY ./ ${LAMBDA_TASK_ROOT}/

CMD ["handler.handler"]
