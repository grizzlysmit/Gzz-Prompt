unit module Gzz::Prompt:ver<0.1.1>:auth<Francis Grizzly Smit (grizzly@smit.id.au)>;
use NativeCall;

=begin pod

=begin head2

Table of Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item1 L<Introduction|#introduction>
=item1 L<class Gzz_readline|#class-gzz_readline> or L<on raku.land class Gzz_readline|#class-gzz-readline>

=NAME Gzz::Prompt 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION 0.1.1
=TITLE Gzz::Prompt
=SUBTITLE A Raku module to do basic prompting with editing and like readline but with the ability to prefill the value.

=COPYRIGHT
LGPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/Syntax-Highlighters/blob/main/LICENSE>


L<Top of Document|#table-of-contents>

=head1 Introduction

A Raku module to do basic prompting with editing and like readline but with the ability to prefill the value.

B<NB: I use the NativeCall module to get at a C library C<gzz_readline.so> which is a fork of
the C<readline> library, I had to fork it as it doesn't normally allow you to prefill the value>
L<See gzzReadline|https://github.com/grizzlysmit/gzzReadline>.

L<NOTE: you must install gzzReadline to use this|https://github.com/grizzlysmit/gzzReadline>

=head2 class Gzz_readline

=begin code :lang<raku>

class Gzz_readline is export 

=end code

L<Top of Document|#table-of-contents>


=end pod

class Gzz_readline is export {

    sub LIBGZZ_READLINE {
        my $library = 'gzz_readline';
        my $library-match = rx/:i libgzz_readline\.so\.(\d+) $/;
        my $version = v0;

        # Collect library paths from arbitrary OSen to search.
        #
        my constant LIBRARY-PATHS = (
            '/lib/x86_64-linux-gnu', # Author's VM
            '/usr/local/lib',        # Generic path
            '/usr/lib64',            # Slackware 14 among others
            '/usr/lib',              # Generic path
            '/lib'                   # even more generic.
        );
        my @library-path = grep { .IO.e }, LIBRARY-PATHS;

        given $*VM.osname {
              when 'openbsd' {
                    $library = 'gzz_readline';
                    $library-match = rx/:i libgzz_readline\.so\.(\d+) $/;
                    $version = v0;
                    my sub tgetnum(Str --> int32) is native('ncurses') { * }
                    tgetnum('');
              }
              when 'darwin' {
                    # needs homebrew installed version of gzz_readline
                    # macOS ships with incompatible libedit
                    $library-match = rx/:i libgzz_readline\.(\d+)\.dylib $/;
                    # set version to v0.0 so we can check if it was found
                    $version = v0.0;
                    # homebrew directory
                    @library-path = ('/usr/local/opt/gzz_readline/lib')
            }
        }

        # Search each of the LIBRARY-PATHS paths for libreadline.
        #
        for @library-path -> $path {
            # Filter out everything but libreadline.{so,dylib}
            # Sort it so the last entry is the latest
            #
            my @dir = sort dir( $path, :test( $library-match ) );
            next unless @dir;

            @dir[*-1] ~~ $library-match;
            $version = Version.new( ( $0 ) );
            last;
        }

        given $*DISTRO.name {
            when 'slackware' {
                if $version ~~ v6 {
                    my sub tgetnum(Str --> int32) is native('ncurses') { * }
                    tgetnum('');
                }
            }
            when rx/"macos" | "darwin"/ {
                # die if we didn't find sometging
                # currently only supports the location from Homebrew
                if $version ~~ v0.0 {
                    die('On macOS Perl6::gzz_Readline requires installing gzz_Readline via Homebrew');
                }
      
                # if we ever support another location, we will need to test where the file is
                return ("@library-path[0]/libgzz_readline.$version.dylib");
            }
        }

        return ( $library, $version );
    }

    #
    # gzz_readline functions.
    #
    sub gzzreadline( Str, Str ) is export returns Str
        is native( LIBGZZ_READLINE ) { * }
    method gzzreadline( Str $prompt, Str $prefill ) returns Str {
        gzzreadline( $prompt, $prefill )
    }

}
