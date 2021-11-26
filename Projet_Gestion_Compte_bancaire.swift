import Foundation

enum CompteTypes {
    static let compte_courant = 1
    static let LivretA = 2
    static let compte_epargne = 3
}

class conseiller {
    var prenom: String = ""
    var nom: String = ""
    
    func advisorIntro(fName: String, lName: String) {
        self.prenom = fName
        self.nom = lName
    }
}

class Customer {

    var prenom: String = ""
    var nom: String = ""
    var adresse: String = ""
    var departement: String = ""
    var numerotelephone: String = ""
    var compteTypes: Int = 0
    var solde: Int = 0
    var isValid = false
 
    func créercustomer(prenom: String, nom: String,adresse: String, departement: String,numerotelephone: String, compteTypes: Int, solde: Int) -> Customer {

        let custom = Customer()

        if solde >= 200 && compteTypes == CompteTypes.compte_epargne {

            custom.prenom = prenom
            custom.nom = nom
            custom.adresse = adresse
            custom.departement = departement
            custom.numerotelephone = numerotelephone
            custom.compteTypes = compteTypes
            custom.solde = solde
            print("Votre compte d'épargne a été bien créé.")
        }
        else if solde >= 10 && compteTypes == CompteTypes.LivretA {
            custom.prenom = prenom
            custom.nom = nom
            custom.adresse = adresse
            custom.departement = departement
            custom.numerotelephone = numerotelephone
            custom.compteTypes = compteTypes
            custom.solde = solde
            print("Votre compte du LivretA a été bien créé.")
        }
        else if solde < 200 && compteTypes == CompteTypes.compte_epargne
            {
            deleteCustomer(phoneNo: numerotelephone)
            print("Le compte épargne doit être minimum à 200€ !")
            }
        else if solde < 10 && compteTypes == CompteTypes.LivretA  
            {
            deleteCustomer(phoneNo: numerotelephone)
            print("Le compte du Livret A doit être minimum à 10€ !")
            }
         else if compteTypes == CompteTypes.compte_courant{
            custom.prenom = prenom
            custom.nom = nom
            custom.adresse = adresse
            custom.departement = departement
            custom.numerotelephone = numerotelephone
            custom.compteTypes = compteTypes
            custom.solde = solde
            print("Votre compte courant a été bien créé.")
        }
        return custom
    }
    
    func modifierCustomer(nouveaunum: String, anciennum: String, departement: String, adresse: String) {

        isValid = false
        customerList = customerList.map {
            let mutablePhoneNo = $0
            
            if $0.numerotelephone == anciennum {
                mutablePhoneNo.numerotelephone = nouveaunum
                mutablePhoneNo.adresse = adresse
                mutablePhoneNo.departement = departement
                isValid = true
                print("Votre compte client a été bien a jour")
            }
            return mutablePhoneNo
        }
        
        if !isValid {
            print("Le numéro téléphone n'est pas valide !")
        }
        
    }

    func deposerargent(phoneNum: String, depositAmount: Int) {

        isValid = false
        customerList = customerList.map {
            let mutableAmount = $0

            if $0.numerotelephone == phoneNum && ($0.compteTypes == CompteTypes.compte_courant) {

                mutableAmount.solde += depositAmount
                isValid = true
            print("Le montant \(depositAmount)€ a été ajouté sur votre compte courant")
            }
            else if $0.numerotelephone == phoneNum && ($0.compteTypes == CompteTypes.LivretA) {

                mutableAmount.solde += depositAmount
                isValid = true
            print("Le montant \(depositAmount)€ a été ajouté sur votre compte LivretA")
            }
            else if $0.numerotelephone == phoneNum && ($0.compteTypes == CompteTypes.compte_epargne) {

                mutableAmount.solde += depositAmount
                isValid = true
            print("Le montant \(depositAmount)€ a été ajouté sur votre compte épargne")
                }
            return mutableAmount
        }
    }
    
    func retirersolde(phoneNum: String, withdrawAmount: Int) {

        customerList = customerList.map {
            let mutableAmount = $0

            if $0.numerotelephone == phoneNum && ($0.compteTypes == CompteTypes.compte_courant){

                if withdrawAmount > 0 {
                    mutableAmount.solde -= withdrawAmount
                    print("Le montant \(withdrawAmount)€ a été retiré sur votre compte")
                }
                else { 
                    print("Votre retrait ne doit être égal à 0 ! Veuillez resaisir ! ")
                }
            }
            else if $0.numerotelephone != phoneNum && ($0.compteTypes == CompteTypes.compte_courant) {
             print("Le numéro téléphone est introuvable")
            }
            return mutableAmount
        }
    }

    func affichersolde(fName: String, lname: String, phoneNum: String) {
    
        isValid = false
        
        customerList = customerList.map {
        let mutableAmount = $0
        let searchCustomer = $0
        
        if $0.compteTypes == CompteTypes.compte_courant
        {
            for searchCustomer in customerList {
                if searchCustomer.numerotelephone == phoneNum && searchCustomer.prenom == fName && searchCustomer.nom == lname {
                    isValid = true
                    }
        }
        if isValid && searchCustomer.numerotelephone == phoneNum {
            print("Votre solde est : \(searchCustomer.solde)€")
            }
        else if !isValid  {
            print("Veuillez saisir vos informations valides.")
            }
        } 
     return mutableAmount
    }
}
func transfersolde(fromPhoneNo: String, toPhoneNo: String, solde: Int){

        isValid = false
        customerList = customerList.map {
            let mutableAmountFrom = $0

            if $0.numerotelephone == fromPhoneNo && ($0.compteTypes == CompteTypes.compte_courant || $0.compteTypes == CompteTypes.compte_epargne || $0.compteTypes == CompteTypes.LivretA) {

                if mutableAmountFrom.solde >= solde {
                    mutableAmountFrom.solde -= solde
                    deposerargent(phoneNum: toPhoneNo, depositAmount: solde)
                    isValid = true
                    print("Le virement du compte est validé")
                }
            }
            return mutableAmountFrom
        }
    }
    func affichagecustomer(customerList: [Customer]){
    for customer in customerList {
    print("Prenom: \(customer.prenom) Nom:\(customer.nom) Adresse:\(customer.adresse) Departement:\(customer.departement) Téléphone:\(customer.numerotelephone) Type de compte: \(customer.compteTypes) Montant:\(customer.solde)€")
        }
    }
    func deleteCustomer(phoneNo: String){
        for customer in customerList {
            if customer.numerotelephone == phoneNo {
                if let idx = customerList.firstIndex(where: { $0 === customer }) {
                    customerList.remove(at: idx)
                }
            }
        }
    }
}

var customerList = [Customer]()
var customer = Customer()
var Conseiller = conseiller()
var wantMoreEnry = true

//a. Connexion an tant de conseiller
print("Veuillez saisir votre prénom en tant que conseiller.")
var fname = readLine()
print("Veuillez entrer votre nom de famille.")
var lname = readLine()

Conseiller.advisorIntro(fName: fname ?? "", lName: lname ?? "")

var choix = -1

while choix != 0 
{
    print("")
    print("Connecté à \(fname!) \(lname!) en tant gestionnaire:")
    print("")
    print("Taper 1: pour ajouter un compte client")
    print("Taper 2: pour afficher l'ensemble des clients")
    print("Taper 3: pour mettre à jour le compte courant/Livret A/épargne")
    print("Taper 4: pour déposer de l'argent sur le compte courant/Livret A/épargne")
    print("Taper 5: pour afficher le solde sur le compte courant")
    print("Taper 6: pour faire le virement du compte")
    print("Taper 7: pour retirer de l'argent sur le compte courant")
    print("Taper 8: pour cloturer votre compte client")
    print("Taper 0: pour fermer le programme \n")
  
    choix = Int(readLine()!)!   
    
    switch choix
    {
    case 1:
    //Creation d'un compte client en saisissant les données
        print("Entrez votre prénom s'il vous plait.")
        let cPrenom = readLine()
        
        print("Entrez votre nom s'il vous plait.")
        let cNom = readLine()
        
        print("Entrez votre adresse s'il vous plait.")
        let cAdresse = readLine()
        
        print("Entrez votre departement s'il vous plait.")
        let cdepartement = readLine()
        
        print("Entrez votre numéro de telephone s'il vous plait.")
        let cNumerotelephone = readLine()
        
        print("Entrez votre numéro de type de compte s'il vous plait. \n 1.Compte Courant \n 2.Livret A \n 3.Compte Epargne ")
        let CcompteTypes = Int(readLine()!)
        
        print("Veuillez saisir votre montant pour effectuer le dépôt initial sur votre compte.")
        let cSolde = readLine()
        let solde = Int(cSolde!)
        
        let c1 = customer.créercustomer(prenom: cPrenom ?? "", nom: cNom ?? "", adresse: cAdresse ?? "", departement: cdepartement ?? "", numerotelephone: cNumerotelephone ?? "", compteTypes: CcompteTypes! , solde: solde!)
        customerList.append(c1)
        break;
    case 2:
        //Affichage à l'ensemble des clients
        print("Affichage de l'ensemble des clients:")
        customer.affichagecustomer(customerList: customerList)
        break;
    case 3:
        //Modifier pour mettre à jour l'adresse ou le numéro
        //du client
        print("Veuillez saisir votre ancienne numéro de téléphone.")
        let cOldPhoneNumber = readLine()
        
        print("Veuillez saisir votre nouveau numéro de téléphone.")
        let cNewPhoneNumber = readLine()
        
        print("Veuillez entrer votre nouveau departement.")
        let cNewdepartement = readLine()
        
        print("Veuillez saisir votre nouveau nom de rue.")
        let cNewstreetName = readLine()
        
        customer.modifierCustomer(nouveaunum:cNewPhoneNumber ?? "", anciennum: cOldPhoneNumber ?? "", departement: cNewdepartement ?? "", adresse: cNewstreetName ?? "")
        break;
    case 4:
        //Déposer de l'argent dans votre compte courant
        print("Pour le montant du dépôt sur votre compte, veuillez entrer votre numéro de téléphone.")
        let clPhoneNumber = readLine()
        print("Veuillez saisir le montant de votre dépôt.")
        let cDepositAmount = readLine()
        let cAmount = Int(cDepositAmount!)
        customer.deposerargent(phoneNum: clPhoneNumber ?? "",depositAmount: cAmount!)
        break;
    case 5:
        //Afficher le solde
        print("Pour afficher le solde de votre compte veuillez entrer votre prénom.")
        let cFname = readLine()
        
        print("Veuillez entrer votre nom.")
        let cLname = readLine()
        
        print("Veuillez entrer votre numéro de téléphone.")
        let cphone = readLine()
        
        customer.affichersolde(fName: cFname ?? "",lname:cLname ?? "", phoneNum: cphone ?? "")
        break;
    case 6:
        //Virement du compte
        print("Pour les virements de montant de votre compte vers un autre compte, veuillez saisir votre numéro.")
        let fromPhoneNo = readLine()
        
        print("Veuillez saisir le transfert vers le numéro de téléphone.")
        let toPhoneNo = readLine()
        
        print("Veuillez saisir le montant du compte")
        let num = Int(readLine()!)
        
        customer.transfersolde(fromPhoneNo: fromPhoneNo ?? "", toPhoneNo: toPhoneNo ?? "", solde: num ?? 0)
    break;
    case 7:
        //Retirer de l'argent dans votre compte client
        print("Pour retirer du dépôt sur votre compte, veuillez entrer votre numéro de téléphone.")
        let clPhoneNumber = readLine()
        
        print("Veuillez saisir le montant de votre dépôt.")
        let cDepositAmount = readLine()
        let cAmount = Int(cDepositAmount!)
        
        customer.retirersolde(phoneNum: clPhoneNumber ?? "",withdrawAmount: cAmount!)
        break;
    case 8:
        //Suppression du compte
        print("Pour cloturer votre compte, veuillez entrer votre numéro de téléphone.")
        let cAccount = readLine()
        customer.deleteCustomer(phoneNo: cAccount ?? "")
        print("Votre compte client a été bien supprimé")
    case 0:
        //Fermeture du programme
    break;
    default:
    break;
    }
}