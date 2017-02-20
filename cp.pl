#!/usr/bin/perl
use File::Find;
use File::Copy;

$path = "./";

sub my_mkdir
{
	($file_path) = @_;
	#windows
	$file_path =~ s/\//\\/g;
	#print "$file_path";
	unless(-d $file_path)
	{
		system("mkdir $file_path");
	}
}


($sec, $min, $hour, $day, $mon, $year, $_, $_, $_) = (localtime(time));
#$base_path = sprintf("%04d%02d%02d/%02d%02d%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);

$base_path = sprintf("doki_%04d%02d%02d", $year+1900, $mon+1, $day);
if(-d $base_path)
{
	system("rd /q /s $base_path");
	print("Delete old files $base_path!!!\n");
}

my_mkdir($base_path);

sub copy_file
{
	$file_name = $File::Find::name;
	if($file_name =~ /$base_path/ || $file_name =~ /\.\/OBJ\/.*/)
	{
		return;
	}

	$file_name =~ s/\.//;
	unless($file_name)
	{
		return;
	}
	$source_name = "$ENV{'PWD'}$file_name";
	if(-d $source_name)
	{
		#print "$file_name\n";
		$target_path = "$ENV{'PWD'}/$base_path$file_name";
		$target_path =~ s/\//\\/g;
		#print "create dir $target_path\n";
		system("mkdir $target_path");
		return;
	}

	if($file_name =~ /\/(.*)\/([^\/]*$)/)
	{
		$target_name = "$ENV{'PWD'}/$base_path/$1/$2";
	}
	else
	{
		$target_name = "$ENV{'PWD'}/$base_path$file_name";
	}

	#print "$source_name\n";
	#print "$target_name\n";
	#print "$file_name\n";
	if($file_name =~ /\.[ch]$/)
	{
		open(SRC, "$source_name") or die("Can not open $source_name $!\n");
		open(TAR, ">$target_name.lancelot") or die("Can not open to $target_name $!\n");
		while (<SRC>)
		{
			print TAR $_;
		}
		close(SRC);
		close(TAR);
		#rename ("$target_name.lancelot", "$target_name") || die( "Error in renaming!\n" );
	}
	else
	{
		$source_name =~ s/\//\\/g;
		$target_path =~ s/\//\\/g;
		copy($source_name, $target_name);
	}
}

find(\&copy_file, $path);

print "Copy file success!\n";
