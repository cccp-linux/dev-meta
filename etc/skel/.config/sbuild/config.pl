# config.pl

# $build_dep_resolver = "aptitude";
$build_environment = { "CCACHE_DIR" => "/build/ccache" };
$check_space = 0;
$chroot_mode = "unshare";

$external_commands = {
    "build-deps-failed-commands" => [ [ "%SBUILD_SHELL" ] ],
    "build-failed-commands" => [ [ "%SBUILD_SHELL" ] ],
};
$path = "/usr/lib/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games";
$run_lintian = 0;

##########
# Enable access to the ccache dir from inside the chroot:
#
#   rid=$(grep `whoami` /etc/subgid | cut -d: -f2)
#   cid=$((rid + 999))
#
#   setfacl -m u:${rid}:x -m u:${cid}:x "$HOME" "$HOME/.cache"
#   setfacl -m u:${rid}:rwx -m u:${cid}:rwx "$HOME/.cache/ccache"
#
##########
$unshare_bind_mounts = [
    { directory => "$HOME/.cache/ccache", mountpoint => "/build/ccache" }
];

my @ubuntu_distros = split(/\n/, `ubuntu-distro-info --all`);
$unshare_mmdebstrap_extra_args = [
    "*" => [ "--verbose",
        "--customize-hook=chroot \$1 update-ccache-symlinks",
        "--include=aptitude,ca-certificates,ccache,eatmydata",
    ],
    map { $_ => [ "--components=main,universe" ] } @ubuntu_distros,
];
$unshare_mmdebstrap_keep_tarball = 1;

1;
