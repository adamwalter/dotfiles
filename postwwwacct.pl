#!/usr/bin/perl

my %OPTS = @ARGV;

my $user = $OPTS{'user'};

if ($user eq "") {
	exit;
}

system("git clone https://github.com/magicmonty/bash-git-prompt.git /home/$user/.bash-git-prompt --depth=1");
system("curl \"https://gitlab.com/adamwalter/dotfiles/raw/master/.git-prompt-colors.sh\" -o /home/$user/.git-prompt-colors.sh");
system("echo '' >> /home/$user/.bash_profile");
system("echo 'source ~/.bash-git-prompt/gitprompt.sh' >> /home/$user/.bash_profile");
