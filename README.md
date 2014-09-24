puppet-requesttracker4
======================

Basic Puppet module for deploying Request Tracker 4 to Ubuntu Trusty LTS.

This is not designed to be very neat/friendly. Following the philosophy that as much
of our infrastructure should be quickly re-deployable I required a way to quickly deploy
our latest RT version and exim config to our server.

I imagine a lot of cases are similar to our own where the email address you
want to use for Tracker is on an existing domain. The exim config expects mail
to be relayed to it from your primary MTA or Exchange server and to smarthost
mail outbound via your existing infrastructure. It performs SQL queries against
the trakcer database to figure out which queue mail is destined for.

It's currently hard coded to using RT-4.2.6 and Postgres (database setup not
included - perhaps speak to your db admin).

I am manually installing the majority of dependencies as CPAN was not compiling
many of them on Trusty. With the majority of them available from packages I 
created this list and installed the remainder using the then functioning makefile.

Replace SSL certs in apache template with your own.

