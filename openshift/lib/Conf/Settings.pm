package Conf::Settings;

BEGIN {
  if ( !$ENV{'OPENSHIFT_APP_NAME'} ) {
    $ENV{'APP_HOME'} = '/data/www/tokyo/';
    $ENV{'APP_SETTING'} = 'dev';
  } else {
    $ENV{'APP_HOME'} = $ENV{'OPENSHIFT_REPO_DIR'};
    $ENV{'APP_SETTING'} = 'prod';
  }
};

use base qw( Exporter );

require "$ENV{'APP_HOME'}myapp/lib/Conf/$ENV{'APP_SETTING'}.conf";

@EXPORT_OK = qw( 
                 $DEBUG
                 $CONFIG
                 $DB_CONFIG
                 $CACHE_CONFIG
               );

1;

