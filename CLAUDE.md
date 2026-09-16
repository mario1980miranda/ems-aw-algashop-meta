# CodeTruck AlgaShop

Repo meta regroupant des microservices Spring Boot via git submodules.
Lire @README.md pour le workflow submodules.

## Structure
- `microservices/<nom>/` : un submodule = un repo GitHub indépendant (`ems-aw-algashop-<nom>`)
- `docs/` : submodule de documentation

## Environnement
- Java 21 (Temurin, voir `.sdkmanrc`), Gradle wrapper par microservice
- Build/tests d'un service : `cd microservices/<nom> && ./gradlew test`

## Règles
- Ne jamais commiter dans le meta une modification de code : le code se commit dans le submodule, puis on bump la référence dans le meta (skill `/bump-submodule`)
- Chaque microservice a son propre CLAUDE.md : le lire avant de modifier son code
- Langue des réponses : français ; code, noms et commentaires : anglais