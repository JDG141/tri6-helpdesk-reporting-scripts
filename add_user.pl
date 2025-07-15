#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use Crypt::PBKDF2;

my $dbh = DBI->connect("DBI:mysql:database=users;host=localhost", "web_user", "SuperSecurePassword456!", { RaiseError => 1, PrintError => 0 });

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
    hash_args => {
        sha_size => 512,
    },
    iterations => 10000,
    salt_len => 16,
);

print "Enter username: ";
my $username = <STDIN>;
chomp $username;

print "Enter first name: ";
my $first_name = <STDIN>;
chomp $first_name;

print "Enter surname: ";
my $surname = <STDIN>;
chomp $surname;

print "Enter email address: ";
my $email = <STDIN>;
chomp $email;

print "Enter password: ";
my $password = <STDIN>;
chomp $password;
my $hashed_password = $pbkdf2->generate($password);

my $insert_user_sql = "
    INSERT INTO user (user_username, user_firstname, user_surname, user_email_address, user_password)
    VALUES (?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($insert_user_sql);
$sth->execute($username, $first_name, $surname, $email, $hashed_password)
    or die "Failed to insert user: " . $dbh->errstr;
print "User '$username' added successfully.\n";