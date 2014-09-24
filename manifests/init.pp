class requesttracker4($tz='Europe/London',
					 $rtname='Request Tracker',
					 $org='Best Practical',
					 $corraddr='support@example.com',
					 $fromline='Customer Support',
					 $webpath='/tracker',
					 $baseurl='http://intranet',
					 $rt_dbtype='pgsql',
					 $rt_dbhost='127.0.0.1',
					 $rt_dbport='5432',
					 $rt_dbuser='postgres',
					 $rt_dbpass='',
					 $rt_dbname='tracker',
					 $trusted_mta = [],
					 $smarthost = '',
					 $smarthost_user,
					 $smarthost_pass) {
    
	$version = '4.2.6'
	$url = "http://download.bestpractical.com/pub/rt/release/rt-${version}.tar.gz"
	
	package { 'apache2': ensure => present,
						 before => Class['apache_files']	}
	package { 'exim4': ensure => present,
                       before => Class['exim_files']	}
	package { 'exim4-daemon-heavy': ensure => present,
                       before => Class['exim_files']	}
    
	service { 'apache2':
        ensure => running,
        hasstatus => true,
        hasrestart => true,
    }
	
	service { 'exim4':
        ensure => running,
        hasstatus => true,
        hasrestart => true,
    }
	
	user { 'rtcrontool':
        comment => 'User for automating RT with rt-crontool',
        home => '/opt/rt4',
        ensure => present,
		shell => '/bin/false',
		groups => ['www-data'],
    }
	
	class rt_packages inherits requesttracker4 {
		
		Package { ensure => present }
		
		package {
			'fonts-droid': ;
			'cpanminus': ;
			'libapache-session-perl': ;
			'libapache2-mod-perl2': ;
			'libcache-simple-timedexpiry-perl': ;
			'libcgi-emulate-psgi-perl': ;
			'libcgi-pm-perl': ;
			'libcgi-psgi-perl': ;
			'libclass-accessor-perl': ;
			'libclass-returnvalue-perl': ;
			'libconvert-color-perl': ;
			'libcrypt-eksblowfish-perl': ;
			'libcrypt-openssl-x509-perl': ;
			'libcrypt-ssleay-perl': ;
			'libcss-squish-perl': ;
			'libdata-guid-perl': ;
			'libdata-ical-perl': ;
			'libdate-extract-perl': ;
			'libdate-manip-perl': ;
			'libdatetime-format-natural-perl': ;
			'libdatetime-locale-perl': ;
			'libdatetime-perl': ;
			'libdbi-perl': ;
			'libdbix-searchbuilder-perl': ;
			'libdevel-globaldestruction-perl': ;
			'libdevel-stacktrace-perl': ;
			'libemail-address-list-perl': ;
			'libemail-address-perl': ;
			'libemail-mime-perl': ;
			'libencode-perl': ;
			'libfcgi-procmanager-perl': ;
			'libfile-sharedir-perl': ;
			'libfile-which-perl': ;
			'libgd-dev': ;
			'libgd-gd2-perl': ;
			'libgd-graph-perl': ;
			'libgd-graph3d-perl': ;
			'libgd-text-perl': ;
			'libgnupg-interface-perl': ;
			'libgraphviz-perl': ;
			'libhtml-format-perl': ;
			'libhtml-formattext-withlinks-andtables-perl': ;
			'libhtml-formattext-withlinks-perl': ;
			'libhtml-mason-perl': ;
			'libhtml-mason-psgihandler-perl': ;
			'libhtml-quoted-perl': ;
			'libhtml-rewriteattributes-perl': ;
			'libhtml-scrubber-perl': ;
			'libhtml-tree-perl': ;
			'libipc-run-perl': ;
			'libipc-run3-perl': ;
			'libjson-perl': ;
			'liblist-moreutils-perl': ;
			'liblocale-maketext-fuzzy-perl': ;
			'liblocale-maketext-lexicon-perl': ;
			'liblog-dispatch-perl': ;
			'libmailtools-perl': ;
			'libmime-types-perl': ;
			'libmodule-versions-report-perl': ;
			'libnet-cidr-perl': ;
			'libperlio-eol-perl': ;
			'libplack-perl': ;
			'libregexp-common-net-cidr-perl': ;
			'libregexp-common-perl': ;
			'libregexp-ipv6-perl': ;
			'librole-basic-perl': ;
			'libssl-dev': ;
			'libstring-shellquote-perl': ;
			'libsymbol-global-name-perl': ;
			'libterm-readkey-perl': ;
			'libtext-autoformat-perl': ;
			'libtext-password-pronounceable-perl': ;
			'libtext-quoted-perl': ;
			'libtext-template-perl': ;
			'libtext-wikiformat-perl': ;
			'libtext-wrapper-perl': ;
			'libtime-modules-perl': ;
			'libtimedate-perl': ;
			'libtree-simple-perl': ;
			'libuniversal-require-perl': ;
			'liburi-perl': ;
			'libxml-rss-perl': ;
			'libxml-simple-perl': ;
			'libyaml-perl': ;
			'make': ;
			'mozilla-devscripts': ;
			'starman': ;
			'ucf': ;
		}
	}
	
	class apache_files inherits requesttracker4 {
		
		file { '/etc/apache2/sites-available/000-default-ssl.conf':
			ensure  => present,
			mode    => '0640',
			content => template('requesttracker4/apache2-modperl2.conf.erb'),
			owner	=> 'root',
			group	=> 'www-data',
			notify  => Service['apache2'],
		}		
	}
	
	class rt_files inherits requesttracker4 {
		
		file { '/opt/rt4/etc/RT_SiteConfig.pm':
			ensure  => present,
			mode    => '0640',
			content => template('requesttracker4/RT_SiteConfig.pm.erb'),
			owner	=> 'root',
			group	=> 'www-data',
			notify  => Service['apache2'],
		}
		
		# Cron job for various automations.
		#file { '/etc/cron.d/rt4.cron':
		#	ensure  => present,
		#	mode    => '0644',
		#	source 	=> 'puppet:///conffiles/requesttracker4/rt4.cron',
		#	owner	=> 'root',
		#	group	=> 'root',
		#}
	}
	
	class exim_files inherits requesttracker4 {
		
		file { '/etc/exim4/exim4.conf':
			ensure  => present,
			mode    => '0644',
			content => template('requesttracker4/exim4.conf.erb'),
			owner	=> 'root',
			group	=> 'root',
			notify  => Service['exim4'],
		}		
	}
	
	include apache_files
	include rt_files
	include rt_packages
	include exim_files
	
	
	exec { 'rt download':
        command => "wget ${url} -O - | tar xz --transform 's/^rt-${version}/rt4/' -C /tmp",
		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        creates => '/tmp/rt4/bin/rt',
		timeout => 360,
		before => Exec['rt configure'],
    }
	
	file { '/tmp/rt4/cpanm_deps.sh':
		ensure  => file,
		mode    => '0777',
		content => "#!/bin/sh\nfor package in `/tmp/rt4/sbin/rt-test-dependencies --verbose | grep MISSING | grep -v ^SOME |cut -d\" \" -f1`; do /usr/bin/cpanm \$package; done\na2enmod perl",
		owner	=> 'root',
		group	=> 'root',
		require  => [Exec['rt download'],Class['rt_packages']],
	}
	
	exec { 'rt configure':
        command => '/tmp/rt4/configure --with-db-type=Pg --enable-graphviz --enable-gd',
		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
		cwd => '/tmp/rt4',
		before => Exec['rt make dependencies'],
    }
	
	exec { 'rt make dependencies':
        command => '/tmp/rt4/cpanm_deps.sh',
		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
		cwd => '/tmp/rt4',
        environment => 'PERL_MM_USE_DEFAULT=1',
		timeout => 0,
		before => Exec['rt make install'],
    }
	
	exec { 'rt make install':
        command => 'make install',
		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
		creates => '/opt/rt4/bin/rt',
		cwd => '/tmp/rt4',
		timeout => 0,
		before => Class['rt_files'],
    }
	
}
