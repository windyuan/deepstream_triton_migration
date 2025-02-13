#!/bin/bash
#
# The MIT License (MIT)
# 
# Copyright (c) 2021, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#

utils_install_librdkafka_from_source()
{
    # @{ librdkafka from source; Bug 200630652
    cd "/root/tmp"
    git clone https://github.com/edenhill/librdkafka.git
    cd librdkafka
    git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a
    ./configure --enable-ssl
    make -j$(nproc)
    make install
    cd "/root/tmp"
    rm -rf librdkafka
    # @} librdkafka from source; Bug 200630652
}
utils_install_libhiredis_from_source()
{
    echo "Installing Dependencies: "
    apt-get install -y libglib2.0 libglib2.0-dev make libssl-dev

    echo "Installing libhiredis: "
    cd "/root/tmp"
    git clone https://github.com/redis/hiredis.git
    cd hiredis
    git reset --hard d5b4c69b7113213c1da3a0ccbfd1ee1b40443c7a
    make USE_SSL=1
    cp libhiredis* /opt/nvidia/deepstream/deepstream/lib/
    ln -sf /opt/nvidia/deepstream/deepstream/lib/libhiredis.so /opt/nvidia/deepstream/deepstream/lib/libhiredis.so.1.0.1-dev
    ln -sf /opt/nvidia/deepstream/deepstream/lib/libhiredis_ssl.so /opt/nvidia/deepstream/deepstream/lib/libhiredis.so.1.0.1-dev-ssl
    ldconfig
    cd "/root/tmp"

    echo "finished installing libhiredis"

}

cd "/root/tmp"

utils_install_librdkafka_from_source

tar -xvf "${DS_REL_PKG}" -C /
/opt/nvidia/deepstream/deepstream/install.sh
mv /root/libiothub_client.so /opt/nvidia/deepstream/deepstream/lib/
mv /root/docker_python_setup.sh /opt/nvidia/deepstream/deepstream/

utils_install_libhiredis_from_source

cp /root/tmp/LicenseAgreementContainer.pdf /opt/nvidia/deepstream/deepstream/

