# Caveats DSL. Each method should handle output, following the
# convention of at least one trailing blank line so that the user
# can distinguish separate caveats.
#
# ( The return value of the last method in the block is also sent
#   to the output by the caller, but that feature is only for the
#   convenience of Cask authors. )
module Hbc
  class DSL
    class Caveats < Base
      def path_environment_variable(path)
        puts <<~EOS
          To use #{@cask}, you may need to add the #{path} directory
          to your PATH environment variable, eg (for bash shell):

            export PATH=#{path}:"$PATH"

        EOS
      end

      def zsh_path_helper(path)
        puts <<~EOS
          To use #{@cask}, zsh users may need to add the following line to their
          ~/.zprofile.  (Among other effects, #{path} will be added to the
          PATH environment variable):

            eval `/usr/libexec/path_helper -s`

        EOS
      end

      def files_in_usr_local
        localpath = "/usr/local"
        return unless HOMEBREW_PREFIX.to_s.downcase.start_with?(localpath)
        puts <<~EOS
          Cask #{@cask} installs files under "#{localpath}". The presence of such
          files can cause warnings when running "brew doctor", which is considered
          to be a bug in Homebrew-Cask.

        EOS
      end

      def depends_on_java(java_version = "any")
        if java_version == "any"
          puts <<~EOS
            #{@cask} requires Java. You can install the latest version with

              brew cask install java

          EOS
        elsif java_version.include?("9") || java_version.include?("+")
          puts <<~EOS
            #{@cask} requires Java #{java_version}. You can install the latest version with

              brew cask install java

          EOS
        else
          puts <<~EOS
            #{@cask} requires Java #{java_version}. You can install it with

              brew cask install caskroom/versions/java#{java_version}

          EOS
        end
      end

      def logout
        puts <<~EOS
          You must log out and log back in for the installation of #{@cask}
          to take effect.

        EOS
      end

      def reboot
        puts <<~EOS
          You must reboot for the installation of #{@cask} to take effect.

        EOS
      end

      def discontinued
        puts <<~EOS
          #{@cask} has been officially discontinued upstream.
          It may stop working correctly (or at all) in recent versions of macOS.

        EOS
      end

      def free_license(web_page)
        puts <<~EOS
          The vendor offers a free license for #{@cask} at
            #{web_page}

        EOS
      end

      def malware(radar_number)
        puts <<~EOS
          #{@cask} has been reported to bundle malware. Like with any app, use at your own risk.

          A report has been made to Apple about this app. Their certificate will hopefully be revoked.
          See the public report at
            #{Formatter.url("https://openradar.appspot.com/#{radar_number}")}

          If this report is accurate, please duplicate it at
            #{Formatter.url("https://bugreport.apple.com/")}
          If this report is a mistake, please let us know by opening an issue at
            #{Formatter.url("https://github.com/caskroom/homebrew-cask/issues/new")}

        EOS
      end
    end
  end
end
