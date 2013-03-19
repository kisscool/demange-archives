#!/usr/local/bin/perl -w

#Système de surveillance des élèves.
#par Deyron [45885]
#http://www.demange-le-jeu.com

use LWP::UserAgent;
        # Liste des matricules surveillés
@mat = (68083,67653,52569,70191,76062,72659,70115);
$taille_mat = @mat;

        # Création/réinitialisation du fichier de synthèse
open (ELEVES, "> eleves.htm") || die "impossible d'ouvrir le fichier";

        # En tête statique
print ELEVES '<html><head><title>Démange</title><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head><body bgcolor="#d9d9d9"><script>function el(date,event,joueur) {document.write(\'<TR><TD>\'+date+\'</TD><TD>\'+event+\'</TD><TD>\');if(joueur!=0) document.write(\'<A href=\\\'http://www.demange-le-jeu.com/info_perso2.php?mat=\'+joueur+\'\\\' target=\\\'_blank\\\'>Mat.\'+joueur+\'</A>\'); else document.write(\'&nbsp;\'); document.write(\'</TD></TR>\');}</SCRIPT><center><br>';

        # Boucle de récupération/formatage des infos
for ($i = 0; $i < $taille_mat; $i++) {
  $ua = LWP::UserAgent->new;
  $ua->agent("DeyronBrowser/9.7");

        # Création de la requête
  $req = HTTP::Request->new(GET => "http://www.demange-le-jeu.com/info_perso2.php?mat=$mat[$i]");
  $res = $ua->request($req);

        # Contrôle et formatage
  if ($res->is_success) {
    $_ =  $res->content;
        # Inscription du matricule
    print ELEVES "<table width=80% border=1><tr><td width=50%>Matricule</td><td>$mat[$i]</td></tr>";
        # Inscription du nom
    /<\/table>(.*)<\/h2>/gi;
    print ELEVES "<tr><td width=50%>Nom</td><td><b>$1</b></td></tr>";
        # Inscription du message
    /<td>Message<\/td>..<td>(.+?)<\/td><\/tr>/sgi;
    print ELEVES "<tr><td width=50%>Message</td><td>$1</td></tr></table>";
        # Inscription des événements
    /<script>.(el.+?;).(el.+?;).(el.+?;).(el.+?;).(el.+?;).(el.+?;).(el.+?;)/sgi;
    @even = ($1, $2, $3, $4, $5, $6, $7);
    print ELEVES "<a name='event'><table width=100% border=1 cellpadding=5><tr><td width=25%><b>Date</b></td><td width=65%><b>Evènement</b></td><td width=10%><b>Joueur impliqué</b></td></tr><script>@even</SCRIPT></table><br><br>";

    print "\n mat $mat[$i] verifie\n";
  }
  else {
    print $res->status_line, "\n";
  }
}

print ELEVES "</body></html>";
close (ELEVES);
