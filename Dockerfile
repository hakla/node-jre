FROM alpine:3.11

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV NODE_VERSION 13.10.1

RUN addgroup -g 1000 node \
  && adduser -u 1000 -G node -s /bin/sh -D node \
  && apk add --no-cache \
  libstdc++ \
  && apk add --no-cache --virtual .build-deps \
  curl \
  && ARCH= && alpineArch="$(apk --print-arch)" \
  && case "${alpineArch##*-}" in \
  x86_64) \
  ARCH='x64' \
  CHECKSUM="b5b1af4f97bf8759e0de58e0d659ffa81db4857500e56e2b0b3f5948351a9bfa" \
  ;; \
  *) ;; \
  esac \
  && if [ -n "${CHECKSUM}" ]; then \
  set -eu; \
  curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
  echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
  echo "Building from source" \
  # backup build
  && apk add --no-cache --virtual .build-deps-full \
  binutils-gold \
  g++ \
  gcc \
  gnupg \
  libgcc \
  linux-headers \
  make \
  python \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && for key in \
  94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
  FD3A5288F042B6850C66B31F09FE44734EB7990E \
  71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  B9AE9905FFD7803F25714661B63B535A4C206CA9 \
  77984A986EBC2AA786BC0F66B01FBB92821C587A \
  8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
  4ED778F539E3634C779C87C6D7062848A1AB005C \
  A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
  B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
  gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xf "node-v$NODE_VERSION.tar.xz" \
  && cd "node-v$NODE_VERSION" \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) V= \
  && make install \
  && apk del .build-deps-full \
  && cd .. \
  && rm -Rf "node-v$NODE_VERSION" \
  && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.0

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
  6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
  gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
  gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  # smoke test
  && yarn --version

# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "build_latest.sh" or "update_multiarch.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

RUN apk add --no-cache --virtual .build-deps curl binutils \
  && GLIBC_VER="2.29-r0" \
  && ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
  && GCC_LIBS_URL="https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-9.1.0-2-x86_64.pkg.tar.xz" \
  && GCC_LIBS_SHA256="91dba90f3c20d32fcf7f1dbe91523653018aa0b8d2230b00f822f6722804cf08" \
  && ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-3-x86_64.pkg.tar.xz" \
  && ZLIB_SHA256=17aede0b9f8baa789c5aa3f358fbf8c68a5f1228c5e6cba1a5dd34102ef4d4e5 \
  && curl -LfsS https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
  && SGERRAND_RSA_SHA256="823b54589c93b02497f1ba4dc622eaef9c813e6b0f0ebbb2f771e32adf9f4ef2" \
  && echo "${SGERRAND_RSA_SHA256} */etc/apk/keys/sgerrand.rsa.pub" | sha256sum -c - \
  && curl -LfsS ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/glibc-${GLIBC_VER}.apk \
  && apk add --no-cache /tmp/glibc-${GLIBC_VER}.apk \
  && curl -LfsS ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk > /tmp/glibc-bin-${GLIBC_VER}.apk \
  && apk add --no-cache /tmp/glibc-bin-${GLIBC_VER}.apk \
  && curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk > /tmp/glibc-i18n-${GLIBC_VER}.apk \
  && apk add --no-cache /tmp/glibc-i18n-${GLIBC_VER}.apk \
  && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
  && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
  && curl -LfsS ${GCC_LIBS_URL} -o /tmp/gcc-libs.tar.xz \
  && echo "${GCC_LIBS_SHA256} */tmp/gcc-libs.tar.xz" | sha256sum -c - \
  && mkdir /tmp/gcc \
  && tar -xf /tmp/gcc-libs.tar.xz -C /tmp/gcc \
  && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
  && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
  && curl -LfsS ${ZLIB_URL} -o /tmp/libz.tar.xz \
  && echo "${ZLIB_SHA256} */tmp/libz.tar.xz" | sha256sum -c - \
  && mkdir /tmp/libz \
  && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
  && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
  && apk del --purge .build-deps glibc-i18n \
  && rm -rf /tmp/*.apk /tmp/gcc /tmp/gcc-libs.tar.xz /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

ENV JAVA_VERSION jdk-11.0.6+10

RUN set -eux; \
  apk add --no-cache --virtual .fetch-deps curl; \
  ARCH="$(apk --print-arch)"; \
  case "${ARCH}" in \
  aarch64|arm64) \
  ESUM='7ed04ed9ed7271528e7f03490f1fd7dfbbc2d391414bd6fe4dd80ec3bad76d30'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jre_aarch64_linux_hotspot_11.0.6_10.tar.gz'; \
  ;; \
  ppc64el|ppc64le) \
  ESUM='49231f2c36487b53141ade3f7eb291e2855138b14b1129f9acf435ea9cc0e899'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jre_ppc64le_linux_hotspot_11.0.6_10.tar.gz'; \
  ;; \
  s390x) \
  ESUM='bcb3f46cbad742b08c81e922e313549c029f436ac7d91ef3c9bed8e4049d67d2'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jre_s390x_linux_hotspot_11.0.6_10.tar.gz'; \
  ;; \
  amd64|x86_64) \
  ESUM='c5a4e69e2be0e3e5f5bb7c759960b20650967d0f571baad4a7f15b2c03bda352'; \
  BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jre_x64_linux_hotspot_11.0.6_10.tar.gz'; \
  ;; \
  *) \
  echo "Unsupported arch: ${ARCH}"; \
  exit 1; \
  ;; \
  esac; \
  curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
  echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
  mkdir -p /opt/java/openjdk; \
  cd /opt/java/openjdk; \
  tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
  apk del --purge .fetch-deps; \
  rm -rf /var/cache/apk/*; \
  rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
  PATH="/opt/java/openjdk/bin:$PATH"

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "node" ]
