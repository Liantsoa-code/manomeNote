# 🛠️ Guide : Identifier et Arrêter un Port Usé (Windows)

Si vous recevez une erreur indiquant qu'un port (ex: **8080**) est déjà utilisé, voici comment le libérer.

---

## 1. Identifier le processus (PID) utilisant un port

Ouvrez un terminal (PowerShell ou CMD) et tapez :

### Via PowerShell (Recommandé)
Remplacez **8080** par le port que vous cherchez :
```powershell
Get-NetTCPConnection -LocalPort 8080 | Select-Object LocalPort, OwningProcess, State
```

### Via CMD (Express)
```cmd
netstat -ano | findstr :8080
```
> Le **PID** est le dernier nombre affiché à droite de la ligne.

---

## 2. Identifier quelle application possède ce PID
Une fois que vous avez le **PID** (ex: `1234`), vous pouvez voir quel programme c'est :
```powershell
tasklist /FI "PID eq 1234"
```

---

## 3. Arrêter (Kill) le processus pour libérer le port

⚠️ **Attention** : Cela va stopper immédiatement l'application concernée.

### Méthode par PID (Le plus rapide)
```powershell
taskkill /PID 1234 /F
```

### Méthode par Port directement (PowerShell uniquement)
Ceci combine la recherche et la suppression en une seule commande (exemple pour le port **8080**) :
```powershell
Stop-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess -Force
```

---

## 🚀 Résumé pour Spring Boot
Si votre projet `Forage` ne veut pas démarrer car le port est bloqué :
1. **Trouver le PID** : `netstat -ano | findstr :8080`
2. **Tuer le PID** : `taskkill /PID <PID_TROUVE> /F`
3. **Relancer le projet** : `mvn spring-boot:run`
