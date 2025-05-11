---
layout: post
title: Formules excel
date: 2017-01-01 00:00:00
author: Virtual Thom
categories: [excel, formule]
---
Recherche dans une feuille qui check si une de ces colonnes (test de chaque ligne d'une colonne IP Adresse) est présente dans deux feuilles différentes (correspondance adresse)

Les formules présentes pourraient être utile pour : 
 * supprimer une retour chariot, saut de ligne, d'une cellule à plusieurs lignes
 * trouver des valeurs identiques dans des colonnes différentes
 * modifier la valeur d'une cellule

```
=SI.NON.DISP(
  SI.NON.DISP(
    SI.NON.DISP(
      RECHERCHEV(
        GAUCHE(
          SUBSTITUE([@adresses];"0.0.0.0";"");
          CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";"")) - 1
        );
        LastExec!$S:$S;
        1;
        FAUX
      );
      RECHERCHEV(
        GAUCHE(
          SUBSTITUE([@adresses];"0.0.0.0";"");
          CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";"")) - 1
        );
        Tableau2[[#Tout];[IP]:[IP]];1;FAUX
      )
    );
    SI.NON.DISP(
      RECHERCHEV(
        GAUCHE(
          DROITE(
            SUBSTITUE([@adresses];"0.0.0.0";"");
            CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";""))
          );
          CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";"")) - 1
        );
        LastExec!$S:$S;
        1;
        FAUX
      );
      RECHERCHEV(
        GAUCHE(
          DROITE(
            SUBSTITUE([@adresses];"0.0.0.0";"");
            CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";""))
          );
          CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";"")) - 1
        );
        Tableau2[[#Tout];[IP]:[IP]];
        1;
        FAUX
      )
    )
  );
  SI.NON.DISP(
    RECHERCHEV(
      GAUCHE(
        DROITE(
          DROITE(
            SUBSTITUE([@adresses];"0.0.0.0";"");
            CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";""))
          );
          CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";""))
        );
        CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";"")) - 1
      );
      LastExec!$S:$S;
      1;
      FAUX
    );
    RECHERCHEV(
      GAUCHE(
        DROITE(
          DROITE(
            SUBSTITUE([@adresses];"0.0.0.0";"");
            CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";""))
          );
          CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";""))
        );
        CHERCHE(CAR(10);SUBSTITUE([@adresses];"0.0.0.0";"")) - 1
      );
      Tableau2[[#Tout];[IP]:[IP]];
      1;
      FAUX
    )
  )
)
```


```
=SI.NON.DISP(
  SI.NON.DISP(
    RECHERCHEV(
      [@adresses];
      Tableau1[[#Tout];[IP]:[IP]];
      1;
      FAUX
    );
    RECHERCHEV(
      [@adresses];
      Tableau2[[#Tout];[IP]:[IP]];
      1;
      FAUX
    )
  );
  SI.NON.DISP(
    SI.NON.DISP(
      RECHERCHEV(
        GAUCHE(
          [@adresses];
          CHERCHE(CAR(10);[@adresses]) - 1
        );
        Tableau1[[#Tout];[IP]:[IP]];
        1;
        FAUX
      );
      RECHERCHEV(
        GAUCHE(
          [@adresses];
          CHERCHE(CAR(10);[@adresses]) - 1
        );
        Tableau2[[#Tout];[IP]:[IP]];
        1;
        FAUX
      )
    );
    SI.NON.DISP(
      SI.NON.DISP(
        RECHERCHEV(
          GAUCHE(
            DROITE(
              [@adresses];
              CHERCHE(CAR(10);[@adresses])
            );
            CHERCHE(
              CAR(10);
              DROITE(
                [@adresses];
                CHERCHE(CAR(10);[@adresses])
              )
            ) - 1
          );
          Tableau1[[#Tout];[IP]:[IP]];
          1;
          FAUX
        );
        RECHERCHEV(
          GAUCHE(
            DROITE(
              [@adresses];
              CHERCHE(CAR(10);[@adresses])
            );
            CHERCHE(
              CAR(10);
              DROITE(
                [@adresses];
                CHERCHE(CAR(10);[@adresses])
              )
            ) - 1
          );
          Tableau2[[#Tout];[IP]:[IP]];
          1;
          FAUX
        )
      );
      SI.NON.DISP(
        RECHERCHEV(
          GAUCHE(
            DROITE(
              DROITE(
                [@adresses];
                CHERCHE(CAR(10);[@adresses])
              );
              CHERCHE(CAR(10);DROITE(
                [@adresses];
                CHERCHE(CAR(10);[@adresses])
              ))
            );
            CHERCHE(
              CAR(10);
              DROITE(
                DROITE(
                  [@adresses];
                  CHERCHE(CAR(10);[@adresses])
                );
                CHERCHE(CAR(10);DROITE(
                  [@adresses];
                  CHERCHE(CAR(10);[@adresses])
                ))
              )
            ) - 1
          );
          Tableau1[[#Tout];[IP]:[IP]];
          1;
          FAUX
        );
        RECHERCHEV(
          GAUCHE(
            DROITE(
              DROITE(
                [@adresses];
                CHERCHE(CAR(10);[@adresses])
              );
              CHERCHE(CAR(10);DROITE(
                [@adresses];
                CHERCHE(CAR(10);[@adresses])
              ))
            );
            CHERCHE(
              CAR(10);
              DROITE(
                DROITE(
                  [@adresses];
                  CHERCHE(CAR(10);[@adresses])
                );
                CHERCHE(CAR(10);DROITE(
                  [@adresses];
                  CHERCHE(CAR(10);[@adresses])
                ))
              )
            ) - 1
          );
          Tableau2[[#Tout];[IP]:[IP]];
          1;
          FAUX
        )
      )
    )
  )
)
```
