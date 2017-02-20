#!/usr/bin/perl
use File::Find;

$path = "./";

sub rename_file
{
	$file_name = $File::Find::name;
	if($file_name =~ /^\.(.*\.c)\.lancelot/)
	{
		$file_name = "$ENV{'PWD'}$1";
		print "rename $file_name\n";
		rename ("$file_name.lancelot", "$file_name") || die( "Error in renaming!\n" );
	}
	elsif($file_name =~ /^\.(.*\.h)\.lancelot/)
	{
		$file_name = "$ENV{'PWD'}$1";
		print "rename $file_name\n";
		rename ("$file_name.lancelot", "$file_name") || die( "Error in renaming!\n" );
	}
}

find(\&rename_file, $path);

print "Rename file success!\n";
