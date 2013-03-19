#!/usr/local/bin/perl -w

#Générateur automatique de questionnaires pour la DWE.
#par Deyron [519]
#http://www.demange-le-jeu.com


        # Lecture de la base de donnée
open (BASE, "base.txt") || die "impossible d'ouvrir le fichier base.txt";
@base = <BASE>;
        # Création du questionnaire
open (QUESTIONS, "> questions.txt") || die "impossible d'ouvrir le fichier questions.txt";

for ($i = 1; $i <= 20; $i++) {
  print QUESTIONS "$i) ";
        # Tirage aléatoire
  srand;
  $random_index = int(rand(@base));
  $line = $base[$random_index];
  print QUESTIONS "$line \n\n";
  sleep 2;
}

        # On range la boutique et on fait dodo
close (QUESTIONS);
close (BASE);
