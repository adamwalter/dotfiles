#!/usr/bin/perl

my %OPTS = @ARGV;

my $user = $OPTS{'user'};

if ($user eq "") {
	exit;
}

# Install Bash Git Prompt
system("git clone https://github.com/magicmonty/bash-git-prompt.git /home/$user/.bash-git-prompt --depth=1");
