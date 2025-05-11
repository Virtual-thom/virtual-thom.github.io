#!/usr/bin/perl 
use XML::LibXML ;
use Data::Dumper ;
use Getopt::Long ;

my $vtexport = '/tmp/vtexport' . int(rand(1000000)) . '.xml' ; #path de l'export par defaut
my (
	$printApp,$printJob,
	$help,
	$encours,
	$CSV,
	$debug,
	$nofirstline,
	$output,
	$status,
	$excludeJ,
	$excludeA,
	$fEnv,$fApp,$fJob,
	$novt,$myvt,
	$FH
) = (0);

my @printItems,@qJobXPathOptions,@qAppXPathOptions ;

&GetOptions(
	"f=s"		=> \&filterHandler,
	"myvt=s"	=> \$myvt,
	"app"		=> \$printApp,
	"job"		=> \$printJob,
	"encours"	=> \$encours,
	"h"		=> \$help,
	"help"		=> \$help,
	"items=s"	=> \&filterItems,
	"csv=s"		=> \$CSV,
	"searchJ=s%"	=> \&filterSearchJobHandler,
	"excludeJ=s%"	=> \&filterExcludeJobHandler,
	"searchA=s%"	=> \&filterSearchAppHandler,
	"excludeA=s%"	=> \&filterExcludeAppHandler,
	"debug"		=> \$debug,
	"nofirstline"	=> \$nofirstline,
	"output=s"	=> \$output,
	"status=s"	=> \$status,
	"novt"		=> \$novt
) or usage();
 
# Gestion du FILEHANDLE (sortie standard ou vers un fichier)
($output) ? ( (open ($FH, '>', $output) or die @_) && select $FH ) : select STDOUT ;

# Recherche d'un pattern sur un item en particulier
sub filterSearchJobHandler{
	foreach( $_[1] ){
		$printJob = 1 ;
		my $q = 0 ;
		
		while(1){

		# script
		if( $_[1] eq "script" ){
			$q = './Script[contains(text(),\'' . $_[2] . '\')]' ;
			last;
		}
		# env 
		if( $_[1] eq "env" ){
        		$q = './../../../../@name[contains(.,\'' . $_[2] . '\')]' ;
			last;
		}
		# app 
		if( $_[1] eq "app" ){
        		$q = './../../@name[contains(.,\'' . $_[2] . '\')]' ;
			last;
		}
		# job 
		if( $_[1] eq "job" ){
        		$q = '@name[contains(.,\'' . $_[2] . '\')]' ;
			last;
		}
		# queue 
		if( $_[1] eq "queue" ){
        		$q = '@queue[contains(.,\'' . $_[2] . '\')]' .
				' or (not(@queue) and ./../../@queue[contains(.,\''. $_[2] .'\')])'.
				' or (not(@queue) and not(../../@queue) and ./../../../../@queue[contains(.,\''. $_[2] .'\')])'
			;
			last;
		}
		# user 
		if( $_[1] eq "user" ){
        		$q = '@user[contains(.,\'' . $_[2] . '\')]' .
				' or (not(@user) and ./../../@user[contains(.,\''. $_[2] .'\')])'.
				' or (not(@user) and not(../../@user) and ./../../../../@user[contains(.,\''. $_[2] .'\')])'
			;
			last;
		}
		# mode 
		if( $_[1] eq "mode" ){
        		$q = '@mode="'. $_[2] .'"' ;
			last;
		}
		# retained 
		if( $_[1] eq "retained" ){
        		$q = '@retained="'. $_[2] .'"' ;
			last;
		}
		# onDemand 
		if( $_[1] eq "onDemand" ){
        		$q = '@onDemand="'. $_[2] .'"' ;
			last;
		}
		# host 
		if( $_[1] eq "host" ){
        		$q = 	'@host[contains(.,\'' . $_[2] . '\')]'.
				' or (not(@host) and ./../../@host[contains(.,\''. $_[2] .'\')])'.
				' or (not(@host) and not(../../@host) and ./../../../../@host[contains(.,\''. $_[2] .'\')])'
			;
			last;
		}
		# Status
		if( $_[1] eq "status" ){
			$status = $_[2] ;
			last;
		}
		# Parameter 
		if( $_[1] =~ s/parameter([0-9]*)/$1/ ){
			$q = './Parameters//Parameter[' ;
			$q .= 'position()='.$_[1].' and ' if( $_[1] =~ /[0-9]+/ ) ;
        		$q .= 'contains(text(),\'' . $_[2] . '\')]';
			last;
		}
		# cycleEnabled 
		if( $_[1] eq "cycleEnabled" ){
        		$q = 	'@cycleEnabled=' . $_[2]
			;
			last;
		}
			print "Unknown Options\n" ;	
			usage() ;
			last;

		}  # END : while 

		if($q){
			$q = 'not(' . $q . ')' if($excludeJ) ;
			$q = '[' . $q . ']' ;
			push(@qJobXPathOptions,$q) ;
		}
	}
}
sub filterExcludeJobHandler{
	$excludeJ = 1 ;
	filterSearchJobHandler(@_);
	$excludeJ = 0 ;
}
sub filterSearchAppHandler{
        foreach( $_[1] ){
                $printApp = 1 ;
                my $q = 0 ;

                while(1){
		# env 
		if( $_[1] eq "env" ){
        		$q = './../../@name[contains(.,\'' . $_[2] . '\')]' ;
			last;
		}
		# app 
		if( $_[1] eq "app" ){
        		$q = '@name[contains(.,\'' . $_[2] . '\')]' ;
			last;
		}
		# queue 
		if( $_[1] eq "queue" ){
        		$q = '@queue[contains(.,\'' . $_[2] . '\')]' .
				' or (not(@queue) and ./../../@queue[contains(.,\''. $_[2] .'\')])'
			;
			last;
		}
		# user 
		if( $_[1] eq "user" ){
        		$q = '@user[contains(.,\'' . $_[2] . '\')]' .
				' or (not(@user) and ./../../@user[contains(.,\''. $_[2] .'\')])'
			;
			last;
		}
		# mode 
		if( $_[1] eq "mode" ){
        		$q = '@mode="'. $_[2] .'"' ;
			last;
		}
		# retained 
		if( $_[1] eq "retained" ){
        		$q = '@retained="'. $_[2] .'"' ;
			last;
		}
		# onDemand 
		if( $_[1] eq "onDemand" ){
        		$q = '@onDemand="'. $_[2] .'"' ;
			last;
		}
		# host 
		if( $_[1] eq "host" ){
        		$q = 	'@host[contains(.,\'' . $_[2] . '\')]'.
				' or (not(@host) and ./../../@host[contains(.,\''. $_[2] .'\')])'
			;
			last;
		}
		# Status
		if( $_[1] eq "status" ){
                        $q = '@status=' . $_[2] ;
			last;
		}
		# cycleEnabled
                if( $_[1] eq "cycleEnabled" ){
                        $q = '@cycleEnabled=' . $_[2];
                        last;
                }
                        print "Unknown Options\n" ;
                        usage() ;
                        last;

                }  # END : while

                if($q){
                        $q = 'not(' . $q . ')' if($excludeA) ;
                        $q = '[' . $q . ']' ;
                        push(@qAppXPathOptions,$q) ;
                }
        }
} # END : filterSearchAppHandler()
sub filterExcludeAppHandler{
	$excludeA = 1 ;
	filterSearchAppHandler(@_);
	$excludeA = 0 ;
}
		


# Gestion encours
$status = "R" if($encours) ;
if($status){
	$printJob = 1 ;
	push(@qJobXPathOptions,'[@status="'.$status.'"]') ;

	# force le vtexport 
	$novt = 0 ;
}

# Gestion du parametere filtre
sub filterHandler{
	($fEnv,$fApp,$fJob) = split /\//,$_[1] ;	
}

# Gestion print App ou Job
($printApp,$printJob) = (1,1) if(not($printApp) && not($printJob));

# Utilisation du script
usage() if($help) ;
sub usage{
print "
tlist - Liste les objets du domaine d'exploitation

Usage : 
	$0

Liste des options :

 Parametres  Valeurs / Formats Caracteristiques
 ----------- ----------------- -------------------------------------------------------
 -h                            Affiche l'aide
 -f          ENV[/APP][/JOB]   Filtre sur environnement/application/traitement (le nom
                               de l'application ou du traitement est optionnel)
 -novt                         Ne re-genere pas un nouvel vtexport 
 -myvt       path              Specifie le chemin du fichier vtexport.xml (couple avec
                               l'option -novt, permet de specifier votre fichier
                               vtexport.xml)
 -app                          N'affiche que les applications 
 -job                          N'affiche que les traitements 
 -encours                      Filtre les traitements en cours d'execution 
 -items      item[/item]..     N'affiche que certains items dans la liste
 -searchJ    item=value        Filtre les jobs selon une recherche de pattern sur un ou
                               plusieurs items 
 -excludeJ   item=value        Exclure les jobs selon une recherche de pattern sur un ou
                               plusieurs items
 -csv        motif             Permet de specifier un motif de separation (; par defaut)
 -output     path/fic          Permet de rediriger la sortie standard vers un fichier
 -status     R|U|F|W|E         Permet de filtrer les jobs avec un certain statut
                               R=En cours;U=Non planifie;F=Termine;W=A venir;E=Erreur
 -nofirstline                  N'affiche pas la premiere ligne recapitulative d item
 -debug                        Affiche  la requete XPath

Liste des items et sortie a l'ecran par defaut :
item;env;app;job;minStart;maxStart;maxLength;cycleEnabled;cycle;mode;retained;onDemand;daysInWeek;daysInMonth;weeksInMonth;monthsInYear;isFormula;formula;comment;information;date;user;status;host;queue;script;parameter;resource

Liste des items pris en charge par searchJ et excludeJ : 
env | app | job | status | cycleEnabled | script | parameter[position] | host | mode | onDemand | queue | user | retained | resource

Signification des valeurs : 
	Planning
	1 = yes ; 0 = no ;
	B = Both (chome + ouvre) ; W = Worked (ouvre) ; N = No (chome)

	Mode;
	J = traitement ; O = stop ; T = test ; S = simulation ; E = execution

	Status;
	R = En cours ; U = Non planifie ; F = Termine ; W = A venir ; E = En erreur

Exemples : 
        $0 -novt -myvt /tmp/monvtexport.xml -items env/app/job/parameter -searchJ script=netbackup -searchJ env=PROD -excludeJ job=CFG

        $0 -searchJ parameter1=MA_POLICIE_NETBACKUP
 
        $0 > /tmp/domaine_prod.csv	

";
	exit 123 ;
}
# vtexport specifique
$vtexport = $myvt if($myvt) ;

# Generation du fichier export
( ($ENV{TOM_BIN}) ? system("vtexport -x > $vtexport") : (print "La variable \$TOM_BIN est introuvable, utiliser -novt si pas de vtexport\n" and usage()) ) if(not($novt)) ;

# Separateur CSV
$CSV = ";" if(not($CSV)) ;

# Load DOM avec l'export XML VTOM
my $dom = XML::LibXML->new()->parse_file($vtexport) or die $@ ;

# Suppression du fichier vtexport temporaire apres chargement dans le DOM
unlink $vtexport if(not($myvt)) ;

# Query XPath
my $qEnvXPath = '/Domain/Environments/Environment';
$qEnvXPath = $qEnvXPath . '[@name="' . $fEnv . '"]' if($fEnv) ;

my $qAppXPath = '/Applications/Application' ;
$qAppXPath = $qAppXPath . '[@name="' . $fApp . '"]' if($fApp) ;

my $qJobXPath = 'Jobs/Job' ;
$qJobXPath = $qJobXPath . '[@name="' . $fJob . '"]' if($fJob) ;

foreach(@qJobXPathOptions){
	$qJobXPath = $qJobXPath . $_ ;
}
foreach(@qAppXPathOptions){
	$qAppXPath = $qAppXPath . $_ ;
}

my $qXPath = $qEnvXPath . $qAppXPath ; 

# debug 
print $qXPath . "/" . $qJobXPath . "\n" if($debug) ;

my @appsNodes = $dom->findnodes($qXPath . "/" . $qJobXPath . "/../.." ) ;

# END : Query XPath

# ITEMS : voir usage()
my %fvItem = ( 'val' => 1, 'label' => 'item' ) ; 
my %fvEnvFromApp = ( 'val' => '../../@name', 'label' => 'env' ) ;
my %fvAppFromApp = ( 'val' => '@name', 'label' => "app" ) ;
my %fvJobsFromApp = ( 'val' => '/dev/null', 'label' => 'job' ) ;
my %fvEnvFromJob = ( 'val' => '../../../../@name', 'label' => 'env' ) ;
my %fvAppFromJob = ( 'val' => '../../@name', 'label' => "app" ) ;
my %fvJob = ( 'val' => '@name', 'label' => 'job' ) ;
my %fvMinStart = ( 'val' => '@minStart', 'label' => 'minStart' ) ;
my %fvMaxStart = ( 'val' => '@maxStart', 'label' => 'maxStart' ) ;
my %fvMaxLength = ( 'val' => '@maxLength', 'label' => 'maxLength' ) ;
my %fvCycleEnabled = ( 'val' => '@cycleEnabled', 'label' => 'cycleEnabled' ) ;
my %fvCycle = ( 'val' => '@cycle', 'label' => 'cycle' ) ;
my %fvMode = ( 'val' => '@mode', 'label' => 'mode' ) ;
my %fvRetained = ( 'val' => '@retained', 'label' => 'retained' ) ;
my %fvOnDemand = ( 'val' => '@onDemand', 'label' => 'onDemand' ) ;
my %fvDaysInWeek = ( 'val' => 'Planning/@daysInWeek', 'label' => 'daysInWeek' ) ;
my %fvDaysInMonth = ( 'val' => 'Planning/@daysInMonth', 'label' => 'daysInMonth' ) ;
my %fvWeeksInMonth = ( 'val' => 'Planning/@weeksInMonth', 'label' => 'weeksInMonth' ) ;
my %fvMonthsInYear = ( 'val' => 'Planning/@monthsInYear', 'label' => 'monthsInYear' ) ;
my %fvIsFormula = ( 'val' => 'Planning/@formula', 'label' => 'isFormula' ) ;
my %fvFormula = ( 'val' => 'Planning/Formula', 'label' => 'formula' ) ;
my %fvComment = ( 'val' => '@comment', 'label' => 'comment' )  ;
my %fvInformation = ( 'val' => '@information', 'label' => 'information' ) ;
my %fvStatus = ( 'val' => '@status', 'label' => 'status' ) ;
my %fvDate = ( 'val' => '@date', 'label' => 'date' ) ;
my %fvUser = ( 'val' => '@user', 'label' => 'user' ) ;
my %fvHost = ( 'val' => '@host', 'label' => 'host' ) ;
my %fvQueue = ( 'val' => '@queue', 'label' => 'queue' ) ;
my %fvScript = ( 'val' => 'Script', 'label' => 'script' ) ;
my %fvParameter = ( 'val' => 'Parameters/Parameter', 'label' => 'parameter' ) ;
my %fvExpectedResources = ( 'val' => 'ExpectedResources/ExpectedResource' ,'label' => 'resource' ) ;


# Affichage par defaut
my @fvApp = (
	{%fvEnvFromApp}, {%fvAppFromApp}, {%fvJobsFromApp}, {%fvMinStart}, {%fvMaxStart}, {%fvMaxLength},
	{%fvCycleEnabled}, {%fvCycle}, {%fvMode}, {%fvRetained},
	{%fvOnDemand}, {%fvDaysInWeek}, {%fvDaysInMonth}, {%fvWeeksInMonth}, {%fvMonthsInYear}, {%fvIsFormula}, {%fvFormula}, {%fvComment},
	{%fvInformation}, {%fvStatus}, {%fvDate}, {%fvUser}, {%fvHost}, {%fvQueue}
	);

my @fvJob = (
	{%fvEnvFromJob}, {%fvAppFromJob}, {%fvJob}, {%fvMinStart}, {%fvMaxStart}, {%fvMaxLength},
	{%fvCycleEnabled}, {%fvCycle}, {%fvMode}, {%fvRetained}, 
	{%fvOnDemand}, {%fvDaysInWeek}, {%fvDaysInMonth}, {%fvWeeksInMonth}, {%fvMonthsInYear}, {%fvIsFormula}, {%fvFormula}, {%fvComment},
	{%fvInformation}, {%fvStatus}, {%fvDate}, {%fvUser}, {%fvHost}, {%fvQueue}, {%fvScript}
	);

# Gestion des filtres pour n'afficher que certains items
sub filterItems{
	@printItems = split /\//,$_[1] ;	
}
if(@printItems) {
	# TODO c'est pas super opti mais je veux item en premier parameter avant dernier et ressource en dernier	
	# TODO à modifier pour les multiples boucles qui sont pas forcément nécessaires

	foreach my $itemLabel (@printItems){
		if($itemLabel eq "item"){
			print $itemLabel . $CSV if(! $nofirstline);
			$fvItem{'print'} = 1 ;
			next;
		}
	}
	foreach my $itemLabel (@printItems){
		foreach my $fvApp (@fvApp){
			if($itemLabel eq $fvApp->{'label'}){
				$fvApp->{'print'} = 1 ;
			}
		}
		foreach my $fvJob(@fvJob){
			if($itemLabel eq $fvJob->{'label'}){
				print $itemLabel . $CSV  if(! $nofirstline) ;
				$fvJob->{'print'} = 1 ;
			}
		}
	}

	foreach my $itemLabel (@printItems){
		if($itemLabel eq "parameter"){
			print $itemLabel . $CSV  if(! $nofirstline);
			$fvParameter{'print'} = 1 ;
			next;
		}
	}

	 foreach my $itemLabel (@printItems){
		if($itemLabel eq "resource"){
			print $itemLabel . $CSV  if(! $nofirstline);
			$fvExpectedResources{'print'} = 1 ;
			next;
		}
	}
	
	print "\n"  if(! $nofirstline);
} else {
	$fvItem{'print'} = 1 ;
	print "item" . $CSV  if(! $nofirstline);

	foreach(@fvApp){
		$_->{'print'} = 1 ;
	}
	foreach(@fvJob){
		$_->{'print'} = 1 ;
		print $_->{'label'} . $CSV  if(! $nofirstline);
	}

	$fvParameter{'print'} = 1 ;
	print "parameter" . $CSV  if(! $nofirstline);

	$fvExpectedResources{'print'} = 1 ;
	print "resource" . $CSV  if(! $nofirstline);

	print "\n"  if(! $nofirstline) ;
}
# End : Gestion des filtres pour n'afficher que certains items

sub printApp{
	my $appNode = @_[0] ;
	if($fvItem{'print'}){
		print "app" . $CSV ;
	}
	foreach(@fvApp){
		if($_->{'print'})
		{
			if($appNode->findvalue($_->{'val'}))
			{
				print $appNode->findvalue($_->{'val'}) ;
			}elsif(
				 $_->{'label'} eq 'host' ||
				 $_->{'label'} eq 'user' ||
				 $_->{'label'} eq 'queue' ||
				 $_->{'label'} eq 'date' 
				)
			{
				if($appNode->findvalue('../../' . $_->{'val'})) {
					print "env:". $appNode->findvalue('../../' . $_->{'val'}) ;
				}
			}
			print $CSV ;
		} # End if : print
	} # End foreach

	if($fvExpectedResources{'print'}){
		my @tabFvExpectedResources;
		foreach($appNode->findnodes($fvExpectedResources{'val'}))
		{
			push(@tabFvExpectedResources,$_->findvalue('@resource') .
			$_->findvalue('@operator'). 
			$_->findvalue('./Value'). 
			" Wait:".$_->findvalue('@wait').
			" startAfter:".$_->findvalue('@startAfter').
			" free:".$_->findvalue('@free').
			" currentvalue:".$dom->findvalue('/Domain/Resources/Resource[@name=\'' . $_->findvalue('@resource') . '\']/@current').
			" maxvalue:".$dom->findvalue('/Domain/Resources/Resource[@name=\'' . $_->findvalue('@resource') . '\']/Value').
			" timeout:".$_->findvalue('@timeout')
			);
		}
		print join(",",@tabFvExpectedResources) ; # on définit un séparateur différent quand il y a plusieurs paramètre pour n'avoir qu'une colone (séparateur par défaut ;)
		print $CSV ;
	} # End if : print fvExpectedResources
	
}

sub printJob {
	my $jobNode = @_[0] ;
	if($fvItem{'print'}){
		print "job" . $CSV ;
	}
	foreach (@fvJob){
		if($_->{'print'}){
			if($jobNode->findvalue($_->{'val'})) {
				print $jobNode->findvalue($_->{'val'}) ;
			}elsif(
				 $_->{'label'} eq 'host' ||
                                 $_->{'label'} eq 'user' ||
                                 $_->{'label'} eq 'queue' ||
                                 $_->{'label'} eq 'date' ||
                                 $_->{'label'} eq 'daysInWeek' ||
                                 $_->{'label'} eq 'daysInMonth' ||
                                 $_->{'label'} eq 'weeksInMonth' ||
                                 $_->{'label'} eq 'monthsInYear' ||
                                 $_->{'label'} eq 'cycleEnabled'
				)
			{
				if($jobNode->findvalue('../../' . $_->{'val'}))
				{
					print "app:" . $jobNode->findvalue('../../' . $_->{'val'}) ;
				}elsif($jobNode->findvalue('../../../../' . $_->{'val'}))
				{
					if(
						$_->{'label'} eq 'host' ||
						 $_->{'label'} eq 'user' ||
						 $_->{'label'} eq 'queue' ||
						 $_->{'label'} eq 'date'
					){ 
						print "env:" . $jobNode->findvalue('../../../../' . $_->{'val'}) ;
					}
				}
			}
			print $CSV ;
		} # End if : print
	}

	if($fvParameter{'print'}){
		my @tabFvParameter;
		foreach($jobNode->findnodes($fvParameter{'val'}))
		{
			push(@tabFvParameter,$_->to_literal) ;
		}
		print join(",",@tabFvParameter) ; # on définit un séparateur différent quand il y a plusieurs paramètre pour n'avoir qu'une colone (séparateur par défaut ;)
		print $CSV ;
	} # End if : print fvParameter	

	if($fvExpectedResources{'print'}){
		my @tabFvExpectedResources;
		foreach($jobNode->findnodes($fvExpectedResources{'val'}))
		{
			push(@tabFvExpectedResources,$_->findvalue('@resource') .
			$_->findvalue('@operator'). 
			$_->findvalue('./Value'). 
			" Wait:".$_->findvalue('@wait').
			" startAfter:".$_->findvalue('@startAfter').
			" free:".$_->findvalue('@free').
			" currentvalue:".$dom->findvalue('/Domain/Resources/Resource[@name=\'' . $_->findvalue('@resource') . '\']/@current').
			" maxvalue:".$dom->findvalue('/Domain/Resources/Resource[@name=\'' . $_->findvalue('@resource') . '\']/Value').
			" timeout:".$_->findvalue('@timeout')
			);
		}
		print join(",",@tabFvExpectedResources) ; # on définit un séparateur différent quand il y a plusieurs paramètre pour n'avoir qu'une colone (séparateur par défaut ;)
		print $CSV ;
	} # End if : print fvExpectedResources
}

foreach my $appNode ( @appsNodes ){
	#App
	if($printApp){
		printApp($appNode);
		print "\n" ;
	} # End fi : $printApp	

	#Job
	if($printJob){
	foreach my $jobNode ( $appNode->findnodes($qJobXPath) )
	{
		printJob($jobNode) ;
		print "\n" ;
	} # End : job
	} # End fi : $printJob
} # End : app
