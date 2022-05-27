# Copyright 2021 gknw <gknw@jzfs.pl>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Modern SSH server for teams managing distributed infrastructure"
HOMEPAGE="https://goteleport.com/"

KEYWORDS="amd64 arm arm64 x86"

T_PN=${PN%-bin}
S="${WORKDIR}/${T_PN}"

SRC_URI_BASE="https://get.gravitational.com"
SRC_URI="amd64? ( ${SRC_URI_BASE}/${T_PN}-v${PV}-linux-amd64-bin.tar.gz -> ${PN}_amd64-v${PV}.tar.gz )
	x86? ( ${SRC_URI_BASE}/${T_PN}-v${PV}-linux-386-bin.tar.gz -> ${PN}_i386-v${PV}.tar.gz )
	arm? ( ${SRC_URI_BASE}/${T_PN}-v${PV}-linux-arm-bin.tar.gz -> ${PN}_arm-v${PV}.tar.gz )
	arm64? ( ${SRC_URI_BASE}/${T_PN}-v${PV}-linux-arm64-bin.tar.gz -> ${PN}_arm64-v${PV}.tar.gz )"


IUSE="etcd systemd server"
LICENSE="Apache-2.0"
RESTRICT="test strip compile"
SLOT="0"

BDEPEND="app-arch/gzip
	app-arch/tar"

REQUIRED_USE="etcd? ( server ) systemd? ( server )"

RDEPEND="
server? (
	etcd? (
		dev-db/etcd
	)
)
"

src_install() {
	dobin tsh
	dobin tctl

	if use server; then
		dobin teleport
		keepdir /var/lib/${T_PN} /etc/${T_PN}

		insinto /etc/${T_PN}
		doins "${FILESDIR}"/${T_PN}.yaml

		if use systemd; then
			systemd_newunit "${FILESDIR}"/${T_PN}.service ${T_PN}.service
			systemd_install_serviced "${FILESDIR}"/${T_PN}.service.conf ${T_PN}.service
		else
			newinitd "${FILESDIR}"/${T_PN}.init.d ${T_PN}
			newconfd "${FILESDIR}"/${T_PN}.conf.d ${T_PN}
		fi
	fi
}
