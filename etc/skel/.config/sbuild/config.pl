# config.pl

$build_dep_resolver = "aptitude";
$chroot_mode = "unshare";

$external_commands = {
    "build-deps-failed-commands" => [ [ "%SBUILD_SHELL" ] ],
    "build-failed-commands" => [ [ "%SBUILD_SHELL" ] ],
};
$run_lintian = 0;

1;
