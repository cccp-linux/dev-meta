# config.pl

# $build_dep_resolver = "aptitude";
$check_space = 0;
$chroot_mode = "unshare";

$external_commands = {
    "build-deps-failed-commands" => [ [ "%SBUILD_SHELL" ] ],
    "build-failed-commands" => [ [ "%SBUILD_SHELL" ] ],
};
$run_lintian = 0;

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
