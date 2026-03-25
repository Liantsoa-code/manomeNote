Demande
-date
-client
-lieu
-district?

Client
-nom
-contact
-demande
-...

Devis
-montant
-TYPEdevis
-date
-demande



Typedevis
-libelle

Detailsdevis
-devis
-libelle
-montant (tsy atao anaty base fotsiny fa calculena)
-prixUnitaire
-quantité

Status
-libelle
()

Travaux
-demande
-status

TravauxStatut
-travaux
-statut
-date

demandeStatut
-idDemande

crud demande, client Sprint3
manokatra page ray aa demande 
manampy ligne ray anaty demandestatut  3bis lasa rehefa creer na ny demande ray d transactionnel cad hoe tonga d creer ko ny statt miaraka amainy, mila verfieko ny base fa sody mbola tsy milamina


Sprint 4 : devis et devis details (table concerné : devis, typedevis, detailsdevis) interface rehefa miajouté devis ohatra d misy demande efa anaty base. mila vue maka anle anarana client pour les details