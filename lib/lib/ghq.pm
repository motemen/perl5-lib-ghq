package lib::ghq;
use 5.008001;
use strict;
use warnings;
use lib ();
use Cwd::Guard qw(cwd_guard);
use File::Spec;

our $VERSION = "0.01";

our @ROOTS;

sub _roots {
    return @ROOTS if @ROOTS;

    @ROOTS = split /\n/, qx(ghq root --all);

    if ($? != 0) {
        die "failed to execute 'ghq root --all': $!";
    }

    return @ROOTS;
}

sub import {
    my ($class, $repo, $glob) = @_;

    foreach my $root ($class->_roots) {
        my $repo_root = File::Spec->catdir($root, $repo);
        if (-d $repo_root) {
            my $g = cwd_guard($repo_root);
            foreach (glob $glob) {
                my $lib = File::Spec->catdir($repo_root, $_);
                lib->import($lib);
            }
            return;
        }
    }

    die "repo $repo not found";
}

1;

__END__

=encoding utf-8

=head1 NAME

lib::ghq - It's new $module

=head1 SYNOPSIS

    use lib::ghq;

=head1 DESCRIPTION

lib::ghq is ...

=head1 LICENSE

Copyright (C) motemen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

motemen E<lt>motemen@gmail.comE<gt>

=cut

