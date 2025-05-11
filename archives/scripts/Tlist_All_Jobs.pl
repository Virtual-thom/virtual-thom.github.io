#!/usr/local/bin/perl
################################################################################
# Nom: Tlist_All_Jobs.pl
################################################################################
# Objectif :  Lister tous les jobs VTOM
# ----------
#
################################################################################
# Description : ce tlist utilise un fichier vtexport au format XML. Il nécessite
# ------------- l'installation d'une librairie particulière pour parser au plus
# vite un fichier XML : module XML::LibXML
# Pour installer un module : cpan XML::LibXML
# Si cela ne fonctionne pas ou si l'utilitaire cpan n'est pas installé, on peut
# installer directement avec les packages en le downloadant et en l'installant
# ou, via l'utilitaire de votre système.
# Par exemple pour yum : yum install perl-XML-LibXML.x86_64
# (faites un yum list | grep perl-XML, pour avoir le libellé exact)
#
# Il a été créé sur un besoin de
# lister tous les traitements qui lancent une stratégie NetBackup en particulier.
# Mais il permet surtout de re-traiter les informations générées en sortie.
# En effet, la recherche d'objet du référentiel dans VTOM (CTRL+F) est plutôt
# bien pensée, mais impossible d'extraire les informations de votre recherche avec
# le script, les paramètres, l'utilisateur etc.
#
# Ce script génère en sortie des lignes CSV avec la définition complète des jobs
#
################################################################################
# Parametres recus :
# ------------------
################################################################################
# ==============================================================================
# Codes retours - TEMPLATE
# ==============================================================================
#	01 : Parametres recus en entree du script alors qu'aucun parametre n'est attendu
#	02 : Nombre de parametres recus incorrect
#	99 : Erreur de configuration initiale
#
# ==============================================================================
# Codes retours - SPECIFIQUE
# ==============================================================================
#
################################################################################
# Revision :
# ----------
# - 02/09/2015 - Virtual Thom
# 	version initiale
#
################################################################################
# Template : Version 2.3
################################################################################
# Definition des Librairies du template
################################################################################
use POSIX;
use File::Basename;
use Sys::Hostname;

################################################################################
# Definition des Librairies specifiques
################################################################################
use XML::LibXML ;

#path du vtexport
my $VTEXPORT = 'vtexport' . int(rand(1000000)) . '.xml' ;

# file handle, sortie à lécran = STDOUT, on peut définir une sortie dans une fichier
my $FH = 'STDOUT' ;

# Separateur CSV
my $CSV_SEP = ";" ;

# DOM
my $DOM ;

# Generation du fichier export en xml
if($ENV{TOM_BIN}){
	system("vtexport -x > $VTEXPORT")
}else{
	$VTEXPORT = "vtexport.xml" ;
}

# Load DOM avec l'export XML VTOM
unless($DOM = XML::LibXML->new()->parse_file($VTEXPORT)){
	print ("ERROR -- Impossible de parser le fichier $VTEXPORT : $!");
	exit 11 ;
} ;

# Suppression du fichier vtexport  apres chargement dans le DOM
unlink $VTEXPORT ;

# Query XPath
my @jobsNodes = $DOM->findnodes('/Domain/Environments/Environment/Applications/Application/Jobs/Job') ;

# ITEMS
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


# liste des items à afficher (on peut ajouter ou enlever ce qu'on veut)
	#{%fvEnvFromJob}, {%fvAppFromJob}, {%fvJob}, {%fvMinStart}, {%fvMaxStart}, {%fvMaxLength},
	#{%fvCycleEnabled}, {%fvCycle}, {%fvMode}, {%fvRetained},
	#{%fvOnDemand}, {%fvDaysInWeek}, {%fvDaysInMonth}, {%fvWeeksInMonth}, {%fvMonthsInYear}, {%fvIsFormula}, {%fvFormula}, {%fvComment},
	#{%fvInformation}, {%fvStatus}, {%fvDate}, {%fvUser}, {%fvHost}, {%fvQueue}, {%fvScript}
my @fvJob = (
		{%fvEnvFromJob}, {%fvAppFromJob}, {%fvJob},{%fvScript}, {%fvHost}
	);


#  On affiche tous les items en header
my $printHeader = 0 ;
if($printHeader){
	print $FH "#" ;
	foreach(@fvJob){
		print $FH $_->{'label'} . $CSV_SEP ;
	}
	print $FH "parameter" . $CSV_SEP . "\n" ;
}


# Fonction d'affichage des jobs
sub printJob {
	my $jobNode = $_[0] ;

	# On affiche les items
	foreach (@fvJob){
		# notion d'héritage, on remonte vers l'application si on ne trouve pas la valeur dans le noeud du job
		if($jobNode->findvalue($_->{'val'})) {
			print $FH $jobNode->findvalue($_->{'val'}) ;
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
				print $FH "app:" . $jobNode->findvalue('../../' . $_->{'val'}) ;
			}elsif($jobNode->findvalue('../../../../' . $_->{'val'}))
			{
				# notion d'héritage, on remonte vers l'environnement si on ne trouve pas la valeur dans le noeud de l'application
				if(
					$_->{'label'} eq 'host' ||
					$_->{'label'} eq 'user' ||
					$_->{'label'} eq 'queue' ||
					$_->{'label'} eq 'date'
				){
					print $FH "env:" . $jobNode->findvalue('../../../../' . $_->{'val'}) ;
				}
			}
		}
		print $FH $CSV_SEP ;
	}
	# On affiche les paramètres
	foreach($jobNode->findnodes($fvParameter{'val'}))
	{
		print $FH $_->to_literal . "|" ;
	}
}

foreach my $jobNode ( @jobsNodes ){
	printJob($jobNode) ;
	print $FH "\n" ;
} # End : job

