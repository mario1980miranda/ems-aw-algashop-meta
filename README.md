# AlgaShop Meta

Repo *meta* regroupant les microservices et la documentation du projet AlgaShop via des **Git submodules**.

## Structure du projet

```
algashop-meta/                     ← repo meta (ems-aw-algashop-meta)
├── docs/                          ← submodule (ems-aw-algashop-docs)
├── microservices/                 ← simple dossier (pas un submodule)
│   ├── ordering/                  ← submodule (ems-aw-algashop-ordering)
│   ├── billing/                   ← submodule (futur)
│   ├── payment/                   ← submodule (futur)
│   └── catalog/                   ← submodule (futur)
├── .gitmodules                    ← fichier généré par Git, liste les submodules
└── README.md
```

> Le dossier `microservices/` est un répertoire ordinaire du repo meta. Chaque submodule à l'intérieur est un repo Git indépendant.

## 1. Créer les repos sur GitHub

Chaque projet est un nouveau repo sur GitHub :

| Repo GitHub                | Rôle                  | Chemin local dans le meta |
|----------------------------|-----------------------|---------------------------|
| `ems-aw-algashop-meta`     | Repo parent (meta)    | `algashop-meta/`          |
| `ems-aw-algashop-ordering` | Microservice Ordering | `microservices/ordering/` |
| `ems-aw-algashop-docs`     | Documentation         | `docs/`                   |

> ⚠️ **Important** : chaque repo destiné à devenir un submodule doit contenir **au moins un commit** avant d'être ajouté au meta. Un submodule est une référence vers un commit précis — sans commit, `git submodule add` échoue avec `fatal: You are on a branch yet to be born`.

Si un repo est vide, l'initialiser d'abord :

```bash
git clone git@github.com:mario1980miranda/ems-aw-algashop-ordering.git
cd ems-aw-algashop-ordering
git commit --allow-empty -m "chore: initial commit"
git push origin main
```

## 2. Configurer le repo meta et ses submodules

```bash
# Cloner le repo meta dans un dossier local nommé "algashop-meta"
git clone git@github.com:mario1980miranda/ems-aw-algashop-meta.git algashop-meta
cd algashop-meta

# Ajouter les submodules
git submodule add git@github.com:mario1980miranda/ems-aw-algashop-ordering.git microservices/ordering
git submodule add git@github.com:mario1980miranda/ems-aw-algashop-docs.git docs

# Vérifier avant de commiter : .gitmodules, microservices/ordering et docs doivent être "staged"
git status

git add .
git commit -m "chore: initial commit with ordering and docs submodules"
git push origin main
```

> 💡 Dans l'historique Git, un submodule apparaît avec le mode `160000` (*gitlink*) — c'est la signature d'un submodule correctement enregistré.

## 3. Ajouter un nouveau microservice

Quand un nouveau microservice est prêt (avec au moins un commit dans son repo !) :

```bash
git submodule add git@github.com:mario1980miranda/ems-aw-algashop-billing.git microservices/billing
git add .gitmodules microservices/billing
git commit -m "chore: add billing submodule"
git push origin main
```

## 4. Cloner le projet avec ses submodules

```bash
git clone --recurse-submodules git@github.com:mario1980miranda/ems-aw-algashop-meta.git algashop-meta
```

Si le projet a été cloné sans l'option `--recurse-submodules`, initialiser les submodules après coup :

```bash
git submodule update --init --recursive
```

## 5. Workflow de travail avec les submodules

### Travailler dans un submodule

Un submodule est un repo Git complet : on travaille dedans normalement.

```bash
cd microservices/ordering
# ... modifications ...
git add .
git commit -m "feat: ..."
git push origin main
```

### Mettre à jour la référence dans le meta

Après un push dans un submodule, le repo meta voit le submodule comme « modifié ». Il faut commiter la nouvelle référence :

```bash
cd ~/Dev/EMS/algashop/algashop-meta
git add microservices/ordering
git commit -m "chore: bump ordering submodule"
git push origin main
```

### Récupérer les dernières versions de tous les submodules

```bash
git submodule update --remote --merge
```

### Exécuter une commande dans tous les submodules

Très pratique quand le nombre de microservices augmente :

```bash
git submodule foreach git pull origin main
git submodule foreach git status
```

### Vérifier l'état des submodules

```bash
git submodule status
```

Chaque submodule s'affiche avec son chemin et le commit référencé :

```
 abc1234 docs (heads/main)
 def5678 microservices/ordering (heads/main)
```

## 6. Déplacer / renommer un submodule

`git mv` gère tout automatiquement (déplacement + mise à jour de `.gitmodules` et de `.git/modules`) :

```bash
# Exemple : déplacer le submodule "microservices" vers "microservices/ordering"
git mv microservices microservices-tmp
git mv microservices-tmp microservices/ordering

git commit -m "chore: move ordering submodule to microservices/ordering"
git push origin main
```

> Le déplacement en deux temps est nécessaire quand on déplace un dossier « à l'intérieur de lui-même ».

## 7. Dépannage

### Supprimer proprement un submodule

```bash
git submodule deinit -f <chemin>
git rm -f <chemin>
rm -rf .git/modules/<chemin>
git commit -m "chore: remove <chemin> submodule"
```

### `fatal: please make sure that the .gitmodules file is in the working tree`

Le fichier `.gitmodules` a été supprimé du disque mais existe encore dans l'index Git. Le retirer de l'index :

```bash
git rm --cached .gitmodules
```

### `error: '<chemin>/' does not have a commit checked out`

Le submodule pointe vers un repo sans commit, ou son état local est corrompu. Vérifier que le repo distant a au moins un commit, puis supprimer et ré-ajouter le submodule (voir ci-dessus).