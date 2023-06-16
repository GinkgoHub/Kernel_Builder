localpath=$(pwd)

git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git -b lineage-18.1 $localpath/GCC64
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git -b lineage-18.1 $localpath/GCC32
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git $localpath/CLANG

make O=out ARCH=arm64 vendor/ginkgo-perf_defconfig
PATH="$localpath/CLANG/bin:$localpath/GCC64/bin:$localpath/GCC32/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi-

if [ -f "out/arch/arm64/boot/Image.gz-dtb" ] && [ -f "out/arch/arm64/boot/dtbo.img" ]; then
	echo -e "\nCompilation succesfull...\n"
	git clone --depth=1 https://github.com/GinkgoHub/AnyKernel3.git
	cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
	cp out/arch/arm64/boot/dtbo.img AnyKernel3
	cd AnyKernel3
	zip -r ginkgo-lineage-18.1-perf * -x '*.git*' README.md *placeholder
        curl -T ginkgo-lineage-18.1-perf.zip temp.sh && echo ""
fi
