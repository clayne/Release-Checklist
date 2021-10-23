package Release::Checklist;

use strict;
use warnings;

our $VERSION = "0.15";

1;

__END__
=encoding utf-8


=head1 NAME

Release::Checklist - A QA checklist for CPAN releases

What follows is a list of categories or subjects that touch the quality -
or what an end-user percieves as such - of a distribution end might
need some attention.

This document is aiming at up-river authors that want/need improving
the release status of their distribution.

Work is underway in merging this list with
L<The Berlin Consensus|https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/berlin-consensus.md>
into a toolset and/or service.

Some of those can be (semi-)automated (in tests), others need action
from the maintainer. Not all subjects may apply to your project.

Each subject will mention or list modules that might help in improving
or preserving high standards.

Various guidelines are also available in the
L<perl core documentation|https://perldoc.perl.org/perlmodstyle.html> and
the basics for preparing a (new) module for distribution can be found in
L<perlnewmod|https://perldoc.perl.org/perlnewmod.html>.

  $ perldoc perlmodstyle

=head1 Test

Test, test and test. The more you test, the lower the chance you
will break your code with small changes.

  use strict;
  use warnings;
  use Test::More;
  :
  done_testing ();

Separate your module tests and your author tests. This will lower the number
of dependencies. Check your Pod syntax, documentation coverage, spelling, and
minimum perl version requirements in C<xt/>.  Prevent declaring dependencies
that are only used inC<xt/>. There is no need to check prerequisites when the
distribution runs its tests in user-space.

 t/
 xt/

If possible, do not use L<Test::*|https://metacpan.org/search?q=Test%3A%3A&search_type=modules>
modules that you do not actually require, however fancy they may be.
See the point about dependencies.

If you are still using any additional C<Test::> module, do not mix your own
code with the functionality from a/the module. Be consistent: use all or
use nothing. That is: if the module you (now) use comes with features you
had scripted yourself before using that module, replace them too.

If adding tests after a bug-fix, add at least two tests: one that tests
that the required (fixed) behavior now passes and that the invalid behavior
fails.

Check to see if your tests support running in parallel

  $ prove -vwb -j8

If you have L<Test2::Harness|https://metacpan.org/pod/Test2::Harness> installed,
also test with yath

  $ yath
  $ yath -j8

Add tests cases from issues or tickets to your own tests. Adding references
to the tickets or issues creates a self-documenting structure, reasoning and
history.

=head1 Dependencies

Every module you use is a module your release will depend on. If a new
release of such module fails, the likelihood of your release being
unable to install increases. So only use modules that you need. Each
dependency should be well-considered.

Depending on modules that are included in the perl5 CORE distribution do
not have this problem, as you are sure that this module is available already.
However, be careful to ensure that that module is a core module in the
lowest version of perl that you claim to support. Check it with
L<Module::CoreList|https://metacpan.org/pod/Module::CoreList>

  $ corelist File::Temp
  Data for 2018-04-20
  File::Temp was first released with perl v5.6.1

Then there are two types of modules you can depend on: functional
modules, like L<DBI|https://metacpan.org/pod/DBI> and
L<XML::LibXML|https://metacpan.org/pod/XML::LibXML>, and developer
convenience modules, like L<Modern::Perl|https://metacpan.org/pod/Modern::Perl>

You cannot get around needing the first type of modules, but the
convenience modules should only be used in (local) perl scripts and
not in CPAN modules, so please do not add additional dependencies
on modules/pragma's like L<sanity|https://metacpan.org/pod/sanity>,
L<Modern::Perl|https://metacpan.org/pod/Modern::Perl>, common::sense,
L<exact|https://metacpan.org/pod/exact>, or
L<nonsense|https://metacpan.org/pod/nonsense>.

However useful they might be in your own working environment and
force you into behaving well, adding them as a requirement to a
CPAN module will increase the complexity of the requirements to
probably no good use, as they are unlikely to be found on all your
targeted systems and add a chance to break.

There is no problem with you using those in your own (non-CPAN)
scripts and modules, but please do not add needless dependencies.

L<Test::Prereq|https://metacpan.org/pod/Test::Prereq> is a fine module to
test your dependencies, but please do not ship it in a test-file on C<t/>.

Finally, make sure all your dependencies are declared in your META structure,
so all CPAN clients know what to do before your module can be tested. META
files are preferably I<not> created manually, but generated by authoring tools
like L<ExtUtils::MakeMaker|https://metacpan.org/pod/ExtUtils::MakeMaker>,
L<Dist::Zilla|https://metacpan.org/pod/Dist::Zilla>, or
L<App::ModuleBuildTiny|https://metacpan.org/pod/App::ModuleBuildTiny> etc.

   "prereqs"        : {
     "build"        : {
       "requires"   : {
         "ExtUtils::MakeMaker"        : "0"
         }
       },
     "configure"    : {
       "requires"   : {
         "ExtUtils::MakeMaker"        : "0"
         }
       },
     "runtime"      : {
       "requires"   : {
         "perl"                       : "5.006",
         "Test::More"                 : "0.88"
         }
       }
     }

=head1 Legal issues

Be very careful in choosing dependencies that have a different license than
your own distribution. However useful a module might be, if it has a more
restrictive license than your distribution, it may be off limits to some
users. That would mean that your distribution cannot be used either.

The reverse is also true: if your release has a more restrictive license than
most releases on CPAN, it may lead to others avoiding depending on your code.

The perl/perl_5 licence is a reasonable default if you do not have a preferred
license.

=head1 Documentation

Make sure that you have a clear, concise, and short SYNOPSIS section. This
section should show the most important code as simple and clear as possible.
If you have 3500 methods in your class, do not list all of the there. Just
show how to create the object and show the 4 methods that a beginner would
use. Note that the user that reads the manual will appreciate complete,
correct, and up-to-date documentation per method more than a complete list
of available methods in the SYNOPSIS.

Make sure your documentation covers all your methods and/or functions and
all edge cases are documented. If you have private functions, mentions that
in the documentation, so users can read that they might disappear without
warning. A special section about errors, error messages, and/or exceptions
is also a very nice thing to have.

Make sure your pod is correct and can also be parsed by the pod-modules in
the lowest version of perl you support (or mention that you need at least
version whatever to read the pod as intended).

The web is dynamic and some (external) references might cease to exist not
telling you, so checking links used in your documentation once in a while
might hint you to updated sites.

=over

=item - L<Test::Pod|https://metacpan.org/pod/Test::Pod>

=item - L<Test::Pod::Coverage|https://metacpan.org/pod/Test::Pod::Coverage>

=item - L<Test::Pod::Links|https://metacpan.org/pod/Test::Pod::Links>

=back

=head1 Neutrality

Do not use offensive or political statements anywhere in your code,
your documentation, or your changelog(s). No one gains from statements
about certain operating system(s), editor(s), president(s) or whatever
are not to your liking. Make neutral claims about not being able to
test your module on system X instead of saying system X should die a
horrible death.

Do not use profane language. Do not promote any deity. A religion to one
might be an insult to others. Keep neutral.

=head1 Spelling

Not every developer is of native English tongue. And even if, they
also make (spelling) mistakes. There are enough tools available to
prevent public display of misspellings and typos. Use them.

It is a good plan to have someone else proofread your documentation.
If you can, ask three readers: one who knows about what the module is
about, one who can be seen as an end-user of this modules without any
knowledge about the internals, and last someone who has no clue about
programming.  You might be surprised of what they will find in the
documentation as weird, unclear, or even plain wrong.

=over

=item - L<pod-spell-check|scripts/pod-spell-check>

=item - L<Pod::Spelling::Aspell|https://metacpan.org/pod/Pod::Spelling::Aspell>

=item - L<Pod::Escapes|https://metacpan.org/pod/Pod::Escapes>

=item - L<Pod::Parser|https://metacpan.org/pod/Pod::Parser>

=item - L<Pod::Spell|https://metacpan.org/pod/Pod::Spell>

=item - L<Pod::Spell::CommonMistakes|https://metacpan.org/pod/Pod::Spell::CommonMistakes>

=item - L<Pod::Wordlist|https://metacpan.org/pod/Pod::Wordlist>

=item - L<Test::Synopsis|https://metacpan.org/pod/Test::Synopsis>

=item - L<Text::Aspell|https://metacpan.org/pod/Text::Aspell>

=item - L<Text::Ispell|https://metacpan.org/pod/Text::Ispell>

=item - L<Text::Wrap|https://metacpan.org/pod/Text::Wrap>

=back

=head1 Examples

Have examples of your code. Preferably both in the EXAMPLES section of the
pod, as in a folder named C<examples>.

It is good practice to use your example code/scripts in your documentation
too, as that gives you a two-way check (additional to your tests). Even
better if the test scripts can be used as examples.

=head1 Test coverage

Do not just test what you think would be used. There I<will> be users that try
to bend the rules and invent ways for your module to be useful that you would
never think of.

If every line of your code is tested, not only do you prevent unexpected
breakage, but you also make sure that most corner cases are tested. Besides
that, it will probably confront you with questions like "What can I possibly
do to get into this part of my code?", Which may lead to optimizations and
other fun.

=over

=item - L<Devel::Cover|https://metacpan.org/pod/Devel::Cover>

=item - L<Test::TestCoverage|https://metacpan.org/pod/Test::TestCoverage>

=back

Remove dead code. It is in your (git) repository anyway.

=over

=item - L<Perl::Critic::TooMuchCode|https://metacpan.org/pod/Perl::Critic::TooMuchCode>

=back

=head1 Version coverage

This is a hard one. If your release/dist requires specific versions of other
modules, try to create an environment where you test your distribution against
the required version I<and> a version that does not meet the minimum version.

If your module requires Foo::Bar-0.123 because it supports correct UTF-8
encoding/decoding, and you wrote a test for that, your release is apt to fail
in an environment where Foo::Bar-0.023 is installed.

This gets really hard to set up if your release has different code for versions
of perl and for versions of required modules, but it pays off eventually. Note
that monitoring L<CPANTESTERS|http://www.cpantesters.org> can be a huge help.

If your code resides on L<GitHub|https://github.com/>, you can setup hooks to
L<Travis CI|https://travis-ci.org/>. Just compose a L<.travis.yml|./.travis.yml>
and enable the hook. This supports a variety of perl versions and an environment
where you can install modules for just the tests you need.

=head1 Minimal perl support

Your Makefile.PL (or whatever initial file the build system you use requires)
will have to state a minimal supported perl version that ends up in
L<META.json|./META.json> and L<META.yml|./META.yml>

Do not guess. It is easy to check with

=over

=item - L<Test::MinimumVersion|https://metacpan.org/pod/Test::MinimumVersion>

=item - L<Test::MinimumVersion::Fast|https://metacpan.org/pod/Test::MinimumVersion::Fast>.

=item - L<Perl::MinimumVersion|https://metacpan.org/release/Perl-MinimumVersion> comes with
   the L<perlver|https://metacpan.org/pod/distribution/Perl-MinimumVersion/script/perlver>
   tool:

=back

  $ perlver --blame test.pl
  --------------------------------------------------
  File    : test.pl
  Line    : 3
  Char    : 14
  Rule    : _perl_5010_operators
  Version : 5.010
  --------------------------------------------------
  //
  --------------------------------------------------

=head1 Multiple perl versions

If you host your perl code on github, you can integrate the services of
L<Travis|https://travis-ci.org>.
Read L<their instructions|https://docs.travis-ci.com/user/languages/perl/>
on how to set up for multiple perl versions and or (environment) options.

If you have multiple perls installed on your system, test your module or
release with all of the versions that you claim to support before doing the
release. Best would be to test with a threaded perl and a non-threaded perl.
If you can test with a mixture of C<-Duselongdouble> and 32bit/64bit perls,
that would be even better.

  $ perl -wc lib/Foo/Bar.pm

=over

=item - L<Module::Release|https://metacpan.org/pod/Module::Release>

=item - L<.releaserc|./.releaserc>

=back

Repeat this on as many architectures as you can (i586, x64, IA64, PA-RISC,
Sparc, PowerPC, …)

Repeat this on as many Operating Systems as you can (Linux, NetBSD, OSX,
HP-UX, Solaris, Windows, OpenVMS, AIX, …)

Testing against a C<-Duselongdouble> compiled perl will surface bad tests,
e.g. tests that match against NVs like 2.1:

  use Test::More;
  my $i = 21000000000000001;
  $i /= 10e15;
  is ($i, 2.1);
  done_testing;

with C<-Uuselongdouble>:

  ok 1
  1..1

with C<-Duselongdouble>:

  not ok 1
  #   Failed test at -e line 1.
  #          got: '2.1000000000000001'
  #     expected: '2.1'
  1..1
  # Looks like you failed 1 test of 1.

will show that 2.25 is probably a better choice that 2.1.

=head1 XS

If you use XS, make sure you (try to) support the widest range of perl
versions. As using XS is quite often using more delicate areas of perl
and perl internals, it is especially important to test for both threaded
and unthreaded perl and - if supported - on operating systems that have
different linking procedures than Linux. AIX and Windows are known to
show deficiencies early.

=over

=item - L<Devel::PPPort|https://metacpan.org/pod/Devel::PPPort> (most recent version)

=back

=head1 Leak tests

Your code allocates memory. Not only for the code itself, but also for all
data-structures, a stack and other resources (modules you use or require).

Creating circular references or (in XS) variables that do not get freed will
cause leaks. You might not notice in your tests, but if a long running process
hits leaks and crashes with out-of-memory after 4 days, that is a problem.
Tracing memory leaks might be hard, but some help is available

=over

=item - L<Test::LeakTrace::Script|https://metacpan.org/pod/Test::LeakTrace::Script>

=item - L<Test::Valgrind|https://metacpan.org/pod/Test::Valgrind>

=item - L<valgrind|http://valgrind.org>

=back

If you have a perl available with ASAN (Address Sanitizer) enabled, your may
find corruptions during compilation.

=head1 Release tests

Some see L<CPANTS|http://cpants.perl.org/> as a game, but many of the tests
it puts on your release have a reason. Before you upload, you can check most
of that to prevent unhappy users.

=over

=item - L<Test::Package|....> - planned

=item - L<Test::Kwalitee|https://metacpan.org/pod/Test::Kwalitee>

=item - L<Module::CPANTS::Analyse|https://metacpan.org/pod/Module::CPANTS::Analyse>

=item - L<cpants_lint.pl|https://metacpan.org/pod/distribution/App-CPANTS-Lint/bin/cpants_lint.pl>

=back

  $ perl Makefile.PL
  $ make
  $ make test
  $ make dist
  $ cpants_lint.pl Foo-Bar-0.01.tar.gz
  Checked dist: Foo-Bar-0.01.tar.gz
  Score: 144.44% (26/18)
  Congratulations for building a 'perfect' distribution!
  $

Other that doing all these tests I<before> you upload to CPAN, there are some
awesome metrics available on L<cpants|https://cpants.cpanauthors.org/> that
trigger I<after> you have uploaded to CPAN.
L<This|https://cpants.cpanauthors.org/> also shows more metrics and has lots
of good L<documentation for the kwalitee indicators|https://cpants.cpanauthors.org/kwalitee>.

=head1 Clean dist

Some problems only surface when you do a C<make clean> or C<make distclean>.
The develop cycle normally only adds and changes files, and if you forget
to add those to the MANIFEST, your distribution will be incomplete and
is likely to fail on other systems, whereas your tests locally still
keep passing.

Check L<MANIFEST|./MANIFEST> and L<MANIFEST.skip|./MANIFEST.skip> are complete.

  $ make dist
  $ make distclean

=over

=item - L<Test::Manifest|https://metacpan.org/pod/Test::Manifest>

=item - L<Test::DistManifest|https://metacpan.org/pod/Test::DistManifest>

=back

  $ perl -MTest::DistManifest -we'manifest_ok'
  1..4
  ok 1 - Parse MANIFEST or equivalent
  ok 2 - All files are listed in MANIFEST or skipped
  ok 3 - All files listed in MANIFEST exist on disk
  ok 4 - No files are in both MANIFEST and MANIFEST.SKIP

=head1 File naming

Do not make it hard for people and modules to use the files in your
distribution by using spaces and special characters in file names. Also try
to not use overly long names and deep directory structures.

If spaces or weird characters in file or folder names are required by your
module and/or your test cases, consider creating these files from the test
itself and cleaning them up when the test is done.

=over

=item - L<Test::Portability::Files|https://metacpan.org/pod/Test::Portability::Files>

=back

  $ perl -MTest::More -MTest::Portability::Files -w \
    -e 'options (all_tests => 1);' \
    -e 'options (test_dos_length => 0);' \
    -e 'run_tests ();'

=head1 Code style consistency

Add a L<CONTRIBUTING.md|./CONTRIBUTING.md> or similar file to guide others to
consistency that will match L<I<your> style|https://tux.nl/style.html> (or, in
case of joint effort, the style as agreed upon by the developers).

There are helper modules to enforce a style (given a configuration) or try
to help contributors to come up with a path/change than matches the project's
style and layout. Again: consistency helps. A lot.

=over

=item - L<Perl::Tidy|https://metacpan.org/pod/Perl::Tidy>

=item - L<Perl::Critic|https://metacpan.org/pod/Perl::Critic> + L<plugins|https://metacpan.org/search?q=Perl%3A%3ACritic%3A%3A&search_type=modules>, lot of choices

=item - L<Test::Perl::Critic|https://metacpan.org/pod/Test::Perl::Critic>

=item - L<Test::Perl::Critic::Policy|https://metacpan.org/pod/Test::Perl::Critic::Policy>

=item - L<Test::TrailingSpace|https://metacpan.org/pod/Test::TrailingSpace>

=item - L<Perl::Lint|https://metacpan.org/pod/Perl::Lint>

=item - L<.perltidy|./.perltidyrc>

=item - L<.perlcritic|./.perlcriticrc>

=back

=head1 META

Make sure your meta-data matches the expected requirements. That can be achieved
by using a generator that produces conform the most recent specifications or by
using tools to check handcrafted META-files against the
L<META spec 1.4 (2008)|http://module-build.sourceforge.net/META-spec-v1.4.html> or
L<META spec 2.0 (2011)|http://module-build.sourceforge.net/META-spec-v2.0.html>:

=over

=item - L<CPAN::Meta::Converter|https://metacpan.org/pod/CPAN::Meta::Converter>

=item - L<CPAN::Meta::Validator|https://metacpan.org/pod/CPAN::Meta::Validator>

=item - L<JSON::PP|https://metacpan.org/pod/JSON::PP>

=item - L<Parse::CPAN::Meta|https://metacpan.org/pod/Parse::CPAN::Meta>

=item - L<Test::CPAN::Meta::JSON|https://metacpan.org/pod/Test::CPAN::Meta::JSON>

=item - L<Test::CPAN::Meta::YAML|https://metacpan.org/pod/Test::CPAN::Meta::YAML>

=item - L<Test::CPAN::Meta::YAML::Version|https://metacpan.org/pod/Test::CPAN::Meta::YAML::Version>

=item - L<YAML::Syck|https://metacpan.org/pod/YAML::Syck>

=back

It is highly appreciated if you declare L<resources|https://metacpan.org/pod/CPAN::Meta::Spec#resources>,
like your public repository URL and the preferred way to communicate in your L<META.json|./META.json>:

   "resources"      : {
     "x_IRC"        : "irc://irc.perl.org/#toolchain",
     "repository"   : {
       "type"       : "git",
       "url"        : "https://github.com/Tux/Release-Checklist",
       "web"        : "https://github.com/Tux/Release-Checklist"
       },
     "bugtracker"   : {
       "web"        : "https://github.com/Tux/Release-Checklist/issues"
       }
     }

Those are recognized and shown in the top-left section on
L<meta::cpan|https://metacpan.org/pod/Release::Checklist>.

=head1 Versions

Use a sane versioning system that the rest of the world might understand.
Do not use the MD5 of the current date and time related to the phase of the
moon or versions that include quotes or spaces. Keep it simple and clear.

=over

=item - L<Test::Version|https://metacpan.org/pod/Test::Version>

=back

Make sure it is a versioning system that increments

=over

=item - L<Test::GreaterVersion|https://metacpan.org/pod/Test::GreaterVersion>

=back

=head1 Changes

Make sure your L<Changes|./Changes> or ChangeLog file is up-to-date. Your
release procedure might check the most recent mentioned date in that. At
least every release should have an entry. Put the most recent change(s)
on top (sort in reverse date order), so people can easily spot the most
recent change(s).

=over

=item - L<Date::Calc|https://metacpan.org/pod/Date::Calc>

=item - L<Test::CPAN::Changes|https://metacpan.org/pod/Test::CPAN::Changes>

=back

=head1 Performance

Check if your release matches previous performance (if appropriate)

=over

=item - between different versions of perl

=item - between different versions of the module

=item - between different versions of dependencies

=back

=head1 License

Make a clear statement about your license. (or choose a default, but at least
state it).

Some target areas require a license in order to allow a CPAN module to be
installed.

=head1 README / README.md

Add a L<file|./README.md> that states the purpose of your distribution.

The README should state the purpose, the minimal envirenment to test, build,
and run and possible license issue. If there is a need to amend or create
configuration files or set up databases, that should be mentioned too.

=over

=item - L<Text::Markdown|https://metacpan.org/pod/Text::Markdown>

=back

=head1 Tickets

If your module is on L<github|https://github.com> or similar, regularly check
on submitted issues and deal with them: either explain why it is not an issue
or comment with alternatives or even better: this has been fixed now.
Additionally, you should check on possible forks of your code and check the
commits in that fork. There are people that make very interesting changes that
you could use to improve your code. If the changes they made are already taken
into your own code, or your code offers a (better) alternative to their change
you could comment on their commits with additional information.

Likewise if you use L<RT|https://rt.cpan.org> as bug tracker.

If any ticket is entered as a vulnerability issue, be sure to make clear in
the feedback to that issue that it is indeed a security issue and how you
dealt with it or that you do/did not acknowledge this as a vulnerability, but
as a (plain/simple) bug and deal with at with the appropriate actions.

Whatever you choose, make it clear in your META information, so the link to
issues on L<metacpan|https://metacpan.org/> points to the correct location.

 META.yml

================================================================================
 resources:
  bugtracker: https://github.com/Tux/Release-Checklist/issues

 META.json

================================================================================
 "resources" : {
   "bugtracker" : {
     "web" : "https://github.com/Tux/Release-Checklist/issues"
     }
   }

=head1 Downriver

You have had reasons to make the changes leading up to a new distribution. If
you really care about the users of your module, you should check if your new
release would break any of the CPAN modules that (indirectly) depend on your
module by testing with your previous release and your upcoming release and see
if the new release would cause the other module(s) to break.

L<used_by.pl|./scripts/used-by.pl> will check the depending modules with the
upcoming version.

Of course it is impossible to cover every possible situation here. The DarkPAN
(uses of your module beyond what is registered on CPAN) is huge.

=head1 LICENSE

Copyright (C) 2015-2021 H.Merijn Brand.  All rights reserved.

This library is free software;  you can redistribute and/or modify it under
the same terms as Perl itself.
