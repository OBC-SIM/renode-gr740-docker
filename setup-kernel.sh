#!/bin/bash
set -euo pipefail

RTEMS_VER=6.1
PREFIX=/opt/rtems/6
SRC=/opt/src
LOG=$SRC/rtems-gr740-build.log

mkdir -p $SRC
exec > >(tee -i $LOG) 2>&1

echo "=========================================="
echo " RTEMS $RTEMS_VER GR740 BSP Build Pipeline"
echo "=========================================="

# --------------------------------------------------
# 1. RTEMS Source Builder
# --------------------------------------------------
echo "[1/6] RTEMS Source Builder"

cd $SRC
if [ ! -d rsb ]; then
  git clone https://gitlab.rtems.org/rtems/tools/rtems-source-builder.git rsb
fi

cd rsb
git fetch
git checkout 6.1

# --------------------------------------------------
# 2. Build SPARC toolchain
# --------------------------------------------------
echo "[2/6] Build SPARC cross toolchain"

cd rtems
../source-builder/sb-set-builder --prefix=$PREFIX 6/rtems-sparc

export PATH=$PREFIX/bin:$PATH
if ! grep -q "$PREFIX/bin" ~/.bashrc; then
  echo "export PATH=$PREFIX/bin:\$PATH" >> ~/.bashrc
fi

# --------------------------------------------------
# 3. RTEMS kernel source
# --------------------------------------------------
echo "[3/6] RTEMS kernel source"

cd $SRC
if [ ! -d rtems ]; then
  git clone https://gitlab.rtems.org/rtems/rtos/rtems.git
fi

cd rtems
git fetch
git checkout 6.1

# --------------------------------------------------
# 4. BSP configuration
# --------------------------------------------------
echo "[4/6] BSP configuration"

if [ ! -f /opt/config.ini ]; then
  echo "FATAL: /opt/config.ini not found"
  exit 1
fi

cp /opt/config.ini .

# --------------------------------------------------
# 5. Configure GR740 BSP
# --------------------------------------------------
echo "[5/6] Configure BSP: sparc/gr740"

./waf configure \
  --rtems-bsps=sparc/gr740 \
  --rtems-tools=$PREFIX \
  --prefix=$PREFIX \
  --rtems-config=config.ini

# --------------------------------------------------
# 6. Build + install
# --------------------------------------------------
echo "[6/6] Build & install BSP"

./waf -j$(nproc)
./waf install

echo ""
echo "=========================================="
echo " RTEMS $RTEMS_VER GR740 READY"
echo "=========================================="
echo " Toolchain : $PREFIX/bin"
echo " BSP       : $PREFIX/sparc-rtems6/gr740"
echo " Log       : $LOG"
