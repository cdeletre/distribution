PKG_NAME="dotnet"
PKG_VERSION="9.0.200"
PKG_SHA512="1af5f3a444419b3f5cf99cb03ee740722722478226d0aff27ad41b1d11e69d73497e25c07ef06a6df9e73fb0fbdc4b9baca9accec95654d9ee7be4d5a5c3ac23"
PKG_LICENSE="MIT"
PKG_SITE="https://dotnet.microsoft.com/en-us/download/dotnet"
PKG_URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/${PKG_VERSION}/${PKG_NAME}-sdk-${PKG_VERSION}-linux-x64.tar.gz"
PKG_DEPENDS_HOST=""
PKG_LONGDESC=".NET 9.0 SDK"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
	mkdir -p ${TOOLCHAIN}/usr/local/share/dotnet
	cp -R ${PKG_BUILD}/* ${TOOLCHAIN}/usr/local/share/dotnet
	ln -s ${TOOLCHAIN}/usr/local/share/dotnet/dotnet ${TOOLCHAIN}/bin/dotnet
}
