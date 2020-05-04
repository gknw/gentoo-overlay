# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="KeePassX is a password manager, based on \`keepass\` codebase"
HOMEPAGE="https://www.keepassx.org/"
EGIT_REPO_URI="https://github.com/keepassx/keepassx.git"
EGIT_COMMIT="1682ab90243ef93449a981eb7b8046b629720488"

LICENSE="|| ( GPL-2 GPL-3 ) BSD GPL-2 LGPL-2.1 LGPL-3+ CC0-1.0 public-domain || ( LGPL-2.1 GPL-3 ) Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=dev-libs/libgcrypt-1.8.3
		sys-libs/zlib
		x11-libs/libXi
		x11-libs/libXtst
		x11-libs/libX11
		>=dev-qt/qtx11extras-5.11.0
		>=dev-qt/qtcore-5.11.0
		>=dev-qt/qtconcurrent-5.11.0"
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=(CHANGELOG)

src_configure() {
	local mycmakeargs=(
			-DWITH_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}
